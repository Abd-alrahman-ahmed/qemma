namespace Qemma.APP.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StudentLessonsController : ControllerBase
    {
        private readonly FirestoreDatabase<StudentLesson> _studentLessonFirestoreCollection;
        private readonly FirestoreDatabase<Lesson> _lessonFirestoreCollection;
        private readonly FirestoreDatabase<Student> _studentFirestoreCollection;

        public StudentLessonsController(FirestoreDatabase<StudentLesson> studentLessonFirestoreCollection,
            FirestoreDatabase<Lesson> lessonFirestoreCollection,
            FirestoreDatabase<Student> studentFirestoreCollection)
        {
            _studentLessonFirestoreCollection = studentLessonFirestoreCollection;
            _lessonFirestoreCollection = lessonFirestoreCollection;
            _studentFirestoreCollection = studentFirestoreCollection;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] string queryFilter = null, [FromQuery] int pageNo = 1, [FromQuery] int pageSize = -1, [FromQuery] string orderDir = null, [FromQuery] string orderBy = null)
        {
            try
            {
                var lessons = await _studentLessonFirestoreCollection.GetByFilterAsync(queryFilter, pageNo, pageSize, orderDir, orderBy);
                lessons.Data = lessons.Data.Select(l =>
                {
                    var studentTask = _studentFirestoreCollection.GetByKeyAsync(l.StudentId);
                    studentTask.Wait();
                    l.Student = studentTask.Result;

                    var lessonTask = _lessonFirestoreCollection.GetByKeyAsync(l.LessonId);
                    lessonTask.Wait();
                    l.Lesson = lessonTask.Result;
                    return l;
                }).ToList();
                return Ok(lessons);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] StudentLesson studentLesson)
        {
            try
            {
                studentLesson.Lesson = null;
                studentLesson.Student = null;
                var studentId = studentLesson.StudentId ?? "";
                var lessonId = studentLesson.LessonId ?? "";

                var student = await _studentFirestoreCollection.GetByKeyAsync(studentId);
                if (student is null) return NoContent();
                if (student.LessonIds is null) student.LessonIds = new List<string>();

                var lesson = await _lessonFirestoreCollection.GetByKeyAsync(lessonId);
                if (lesson is null) return NoContent();
                if (lesson.StudentIds is null) lesson.StudentIds = new List<string>();

                var res = await _studentLessonFirestoreCollection.AddAsync(studentLesson);
                
                student.LessonIds.Add(res);
                student.TotalDegree += lesson.QuizDegree;
                student.Degree += studentLesson.QuizDegree;
                await _studentFirestoreCollection.UpdateAsync(studentId, student);

                lesson.StudentIds.Add(res);
                await _lessonFirestoreCollection.UpdateAsync(lessonId, lesson);

                return StatusCode(StatusCodes.Status201Created, res);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Put([FromRoute] string id, [FromBody] StudentLesson studentLesson)
        {
            try
            {
                studentLesson.Lesson = null;
                studentLesson.Student = null;
                await _studentLessonFirestoreCollection.UpdateAsync(id, studentLesson);
                return StatusCode(StatusCodes.Status202Accepted);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] string id, [FromQuery] string studentId, [FromQuery] string lessonId)
        {
            try
            {
                var student = await _studentFirestoreCollection.GetByKeyAsync(studentId);
                if (student is null) return NoContent();
                if (student.LessonIds is null) student.LessonIds = new List<string>();

                var lesson = await _lessonFirestoreCollection.GetByKeyAsync(lessonId);
                if (lesson is null) return NoContent();
                if (lesson.StudentIds is null) lesson.StudentIds = new List<string>();

                student.LessonIds = student.LessonIds.Where(sl => sl != id).ToList();
                await _studentFirestoreCollection.UpdateAsync(studentId, student);
                lesson.StudentIds = lesson.StudentIds.Where(sl => sl != id).ToList();
                await _lessonFirestoreCollection.UpdateAsync(lessonId, lesson);

                await _studentLessonFirestoreCollection.DeleteAsync(id);
                return StatusCode(StatusCodes.Status202Accepted);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }
    }
}
