using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LetsConnect.Common.Data;

namespace SearchService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SearchController : ControllerBase
    {
        private readonly LetsConnectDbContext _context;

        public SearchController(LetsConnectDbContext context)
        {
            _context = context;
        }

        [HttpGet("users")]
        public async Task<ActionResult> SearchUsers([FromQuery] string query)
        {
            if (string.IsNullOrWhiteSpace(query))
                return Ok(new { results = new List<object>() });

            var users = await _context.Users
                .Where(u => u.IsActive && 
                    (u.Username.Contains(query) || u.FullName.Contains(query)))
                .Take(10)
                .Select(u => new {
                    id = u.Id,
                    username = u.Username,
                    fullName = u.FullName,
                    bio = u.Bio
                })
                .ToListAsync();

            return Ok(new { results = users });
        }

        [HttpGet("ping")]
        public ActionResult Ping()
        {
            return Ok(new { status = "ok", time = DateTime.UtcNow });
        }
    }
}
