namespace Qemma.APP.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GroupsController : ControllerBase
    {
        private readonly FirestoreDatabase<Group> _groupFirestoreCollection;
        private readonly FirestoreDatabase<Lesson> _lessonFirestoreCollection;
        private readonly FirestoreDatabase<Student> _studentFirestoreCollection;

        public GroupsController(FirestoreDatabase<Group> groupFirestoreCollection,
            FirestoreDatabase<Lesson> lessonFirestoreCollection,
            FirestoreDatabase<Student> studentFirestoreCollection)
        {
            _groupFirestoreCollection = groupFirestoreCollection;
            _lessonFirestoreCollection = lessonFirestoreCollection;
            _studentFirestoreCollection = studentFirestoreCollection;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] string queryFilter = null, [FromQuery] int pageNo = 1, [FromQuery] int pageSize = -1, [FromQuery] string orderDir = null, [FromQuery] string orderBy = null)
        {
            try
            {
                var groups = await _groupFirestoreCollection.GetByFilterAsync(queryFilter, pageNo, pageSize, orderDir, orderBy);
                return Ok(groups);
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
                var group = await _groupFirestoreCollection.GetByKeyAsync(id);
                return Ok(group);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Group group)
        {
            try
            {
                var res = await _groupFirestoreCollection.AddAsync(group);
                return StatusCode(StatusCodes.Status201Created, res);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Put([FromRoute] string id, [FromBody] Group group)
        {
            try
            {
                await _groupFirestoreCollection.UpdateAsync(id, group);
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
                var lessonsPage = await _lessonFirestoreCollection.GetByFilterAsync($"GroupId eq {id}");
                var studentsPage = await _studentFirestoreCollection.GetByFilterAsync();
                var lessonIds = lessonsPage.Data.Select(l => l.Id);

                foreach (var student in studentsPage.Data)
                {
                    student.LessonIds = student.LessonIds.Where(l => !lessonIds.Contains(l)).ToList();
                    student.GroupIds = student.GroupIds.Where(groupId => groupId != id).ToList();
                    await _studentFirestoreCollection.UpdateAsync(id, student);
                }

                foreach (var lessonId in lessonIds)
                {
                    await _lessonFirestoreCollection.DeleteAsync(lessonId ?? "");
                }

                await _groupFirestoreCollection.DeleteAsync(id);
                return StatusCode(StatusCodes.Status202Accepted);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }
    }
}
