using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Qemma.APP.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountsController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public AccountsController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost("signin")]
        public IActionResult Post([FromBody] Account admin)
        {
            try
            {
                var user = _configuration.GetRequiredSection("user").Get<Account>();
                if (admin.Username?.Trim()?.ToUpper() != user.Username || !Protected.Validate(admin.Password, user.Password)) return BadRequest();

                return StatusCode(StatusCodes.Status201Created, user);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }
    }
}
