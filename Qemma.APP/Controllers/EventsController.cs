namespace Qemma.APP.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EventsController : ControllerBase
    {
        private readonly FirestoreDatabase<QemmaEvent> _qemmaEventFirestoreCollection;

        public EventsController(FirestoreDatabase<QemmaEvent> eventLessonFirestoreCollection)
        {
            _qemmaEventFirestoreCollection = eventLessonFirestoreCollection;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] string queryFilter = null, [FromQuery] int pageNo = 1, [FromQuery] int pageSize = -1, [FromQuery] string orderDir = null, [FromQuery] string orderBy = null)
        {
            try
            {
                var lessons = await _qemmaEventFirestoreCollection.GetByFilterAsync(queryFilter, pageNo, pageSize, orderDir, orderBy);
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
                var qemmaEvent = await _qemmaEventFirestoreCollection.GetByKeyAsync(id);
                return Ok(qemmaEvent);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] QemmaEvent qemmaEvent)
        {
            try
            {
                var res = await _qemmaEventFirestoreCollection.AddAsync(qemmaEvent);
                return StatusCode(StatusCodes.Status201Created, res);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Put([FromRoute] string id, [FromBody] QemmaEvent qemmaEvent)
        {
            try
            {
                await _qemmaEventFirestoreCollection.UpdateAsync(id, qemmaEvent);
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
                await _qemmaEventFirestoreCollection.DeleteAsync(id);
                return StatusCode(StatusCodes.Status202Accepted);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }
    }
}
