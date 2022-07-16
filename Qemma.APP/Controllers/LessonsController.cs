namespace Qemma.APP.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LessonsController : ControllerBase
    {
        private readonly FirestoreDatabase<Lesson> _lessonFirestoreCollection;
        private readonly FirestoreDatabase<Group> _groupFirestoreCollection;
        private readonly FirestoreDatabase<StudentLesson> _studentLessonFirestoreCollection;

        public LessonsController(FirestoreDatabase<Lesson> lessonFirestoreCollection,
            FirestoreDatabase<Group> groupFirestoreCollection,
            FirestoreDatabase<StudentLesson> studentLessonFirestoreCollection)
        {
            _lessonFirestoreCollection = lessonFirestoreCollection;
            _groupFirestoreCollection = groupFirestoreCollection;
            _studentLessonFirestoreCollection = studentLessonFirestoreCollection;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] string queryFilter = null, [FromQuery] int pageNo = 1, [FromQuery] int pageSize = -1, [FromQuery] string orderDir = null, [FromQuery] string orderBy = null)
        {
            try
            {
                var lessons = await _lessonFirestoreCollection.GetByFilterAsync(queryFilter, pageNo, pageSize, orderDir, orderBy);
                return Ok(lessons);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> Get([FromRoute] string id)
        {
            try
            {
                var lesson = await _lessonFirestoreCollection.GetByKeyAsync(id);
                return Ok(lesson);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Lesson lesson)
        {
            try
            {
                var groupId = lesson.GroupId ?? "";
                var group = await _groupFirestoreCollection.GetByKeyAsync(groupId);
                if (group is null) return NoContent();
                if (group.LessonIds is null) group.LessonIds = new List<string>();

                var res = await _lessonFirestoreCollection.AddAsync(lesson);
                group.LessonIds.Add(res);
                await _groupFirestoreCollection.UpdateAsync(groupId, group);

                return StatusCode(StatusCodes.Status201Created, res);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Put([FromRoute] string id, [FromBody] Lesson lesson)
        {
            try
            {
                await _lessonFirestoreCollection.UpdateAsync(id, lesson);

                var studentLessons = (await _studentLessonFirestoreCollection.GetByFilterAsync($"lessonId eq {id}"))?.Data ?? new List<StudentLesson>();
                foreach (var studenLesson in studentLessons)
                {
                    studenLesson.Start = lesson.Start;
                    studenLesson.QuizDegree = Math.Min(studenLesson.QuizDegree, lesson.QuizDegree);
                    studenLesson.InClassExamDegree = Math.Min(studenLesson.InClassExamDegree, lesson.InClassExamDegree);
                    await _studentLessonFirestoreCollection.UpdateAsync(studenLesson.Id, studenLesson);
                }

                return StatusCode(StatusCodes.Status202Accepted);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] string id)
        {
            try
            {
                await _lessonFirestoreCollection.DeleteAsync(id);
                return StatusCode(StatusCodes.Status202Accepted);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }
    }
}
