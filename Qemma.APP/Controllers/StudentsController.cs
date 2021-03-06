namespace Qemma.APP.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StudentsController : ControllerBase
    {
        private readonly FirestoreDatabase<Student> _studentFirestoreCollection;
        private readonly FirestoreDatabase<Group> _groupFirestoreCollection;
        private readonly FirestoreDatabase<Lesson> _lessonFirestoreCollection;
        private readonly FirestoreDatabase<StudentLesson> _studentLessonFirestoreCollection;

        public StudentsController(FirestoreDatabase<Student> firestoreDatabase,
            FirestoreDatabase<Group> groupFirestoreCollection,
            FirestoreDatabase<StudentLesson> studentLessonFirestoreCollection,
            FirestoreDatabase<Lesson> lessonFirestoreCollection)
        {
            _studentFirestoreCollection = firestoreDatabase;
            _groupFirestoreCollection = groupFirestoreCollection;
            _studentLessonFirestoreCollection = studentLessonFirestoreCollection;
            _lessonFirestoreCollection = lessonFirestoreCollection;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] string queryFilter = null, [FromQuery] int pageNo = 1, [FromQuery] int pageSize = -1, [FromQuery] string orderDir = null, [FromQuery] string orderBy = null)
        {
            try
            {
                var students = await _studentFirestoreCollection.GetByFilterAsync(queryFilter, pageNo, pageSize, orderDir, orderBy);
                return Ok(students);
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
                var student = await _studentFirestoreCollection.GetByKeyAsync(id);
                return Ok(student);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }


        [HttpGet("{id}/chart")]
        public async Task<IActionResult> GetChart([FromRoute] string id, [FromQuery] DateTime? from, [FromQuery] DateTime? to, [FromQuery] ChartOperator chartOperator)
        {
            try
            {
                from ??= DateTime.MinValue;
                to ??= DateTime.UtcNow;

                var studentLessons = (await _studentLessonFirestoreCollection.GetByFilterAsync($"studentId eq {id}", orderBy: "start"))?.Data ?? new List<StudentLesson>();
                var chartPoints = studentLessons
                    .Where(l => l.Start >= from && l.Start <= to)
                    .Select(l =>
                    {
                        var lessonTask = _lessonFirestoreCollection.GetByKeyAsync(l.LessonId);
                        lessonTask.Wait();
                        l.Lesson = lessonTask.Result;
                        return l;
                    })
                    .GroupBy(l => ChartAggregationHelper.GetDateKey(l.Start, chartOperator))
                    .Select(l =>
                    {
                        var total = l.Sum(x => x.Lesson?.QuizDegree ?? 0);
                        var degrees = l.Sum(x => x.QuizDegree);
                        return new ChartPoint<DateTime, double>
                        {
                            Key = l.Key,
                            Value = total == 0 ? 0 : Math.Round(degrees / total * 100, 1)
                        };
                    })
                    .ToList();

                return Ok(new Chart<DateTime, double>
                {
                    Name = "Student-Degrees",
                    Categories = chartPoints.Select(l => l.Key).ToArray(),
                    Data = chartPoints.Select(l => l.Value).ToArray()
                });
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Student student)
        {
            try
            {
                student.RegistrationDate = DateTime.UtcNow;
                student.Status = AccountStatus.Confirmed;
                student.Code = long.Parse(student.RegistrationDate.ToString("yyMMddHHmmss")).ToString("X");

                var group = (await _groupFirestoreCollection.GetByFilterAsync($"year eq {(int)student.Year}"))?.Data?.FirstOrDefault();
                if (group is null) return NoContent();

                student.GroupIds = new List<string> { group.Id };
                var res = await _studentFirestoreCollection.AddAsync(student);

                if (group.StudentIds is null) group.StudentIds = new List<string>();
                group.StudentIds.Add(res);
                await _groupFirestoreCollection.UpdateAsync(group.Id, group);
                return StatusCode(StatusCodes.Status201Created, new
                {
                    id = res,
                    code = student.Code
                });
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPost("filter")]
        public IActionResult Filter([FromBody] List<Student> students, [FromQuery] string queryFilter = null, [FromQuery] int pageNo = 1, [FromQuery] int pageSize = -1, [FromQuery] string orderDir = null, [FromQuery] string orderBy = null)
        {
            try
            {
                var filtered = students.Order(orderDir, orderBy)
                    .CreateFilterExpression(queryFilter)
                    .ToPage(pageNo, pageSize);
                return StatusCode(StatusCodes.Status201Created, filtered);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Put([FromRoute] string id, [FromBody] Student student)
        {
            try
            {
                var groups = (await _groupFirestoreCollection.GetByFilterAsync())?.Data;
                if (groups is null || !groups.Any()) return NoContent();
                var oldGroup = groups.FirstOrDefault(g => g.StudentIds?.Contains(id) == true);
                var newGroup = groups.FirstOrDefault(g => g.Year == student.Year);
                if (newGroup is null) return NoContent();

                student.GroupIds = new List<string> { newGroup.Id };
                await _studentFirestoreCollection.UpdateAsync(id, student);
                
                if (oldGroup?.Year != newGroup.Year)
                {
                    if (newGroup.StudentIds is null) newGroup.StudentIds = new List<string>();
                    newGroup.StudentIds.Add(id);
                    await _groupFirestoreCollection.UpdateAsync(newGroup.Id, newGroup);

                    if (oldGroup != null)
                    {
                        if (oldGroup.StudentIds is null) oldGroup.StudentIds = new List<string>();
                        var removed = oldGroup.StudentIds.Remove(id);
                        if (removed) await _groupFirestoreCollection.UpdateAsync(oldGroup.Id, oldGroup);
                    }
                }
                return StatusCode(StatusCodes.Status202Accepted);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }
    }
}
