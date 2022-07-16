namespace Qemma.APP.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SystemController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly FirestoreDatabase<AppLocale> _localeFirestoreCollection;

        public SystemController(IConfiguration configuration, FirestoreDatabase<AppLocale> localeFirestoreCollection)
        {
            _configuration = configuration;
            _localeFirestoreCollection = localeFirestoreCollection;
        }

        [HttpGet("locales")]
        public async Task<IActionResult> GetLocales()
        {
            try
            {
                var locales = (await _localeFirestoreCollection.GetByFilterAsync())?.Data ?? new List<AppLocale>();
                return StatusCode(StatusCodes.Status200OK, locales);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPut("locales")]
        public async Task<IActionResult> UpdateLocales()
        {
            try
            {
                var files = Directory.GetFiles(@".\wwwroot\locales", "*.json");
                var locales = (await _localeFirestoreCollection.GetByFilterAsync("supported eq true"))?.Data ?? new List<AppLocale>();
                foreach (var file in files)
                {
                    var locale = locales.FirstOrDefault(l => l.Code == Path.GetFileName(file).Split(".").First());
                    if (locale == null) continue;
                    using StreamReader r = new(file);
                    string json = r.ReadToEnd();
                    locale.Translations = JsonSerializer.Deserialize<Dictionary<string, string>>(json);
                    await _localeFirestoreCollection.UpdateAsync(locale.Id, locale);
                }
                return StatusCode(StatusCodes.Status200OK);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPost("login")]
        public IActionResult Login([FromBody] Account admin)
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
