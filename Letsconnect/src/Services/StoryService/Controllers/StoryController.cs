using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LetsConnect.Common.Data;
using LetsConnect.Common.Models;

namespace StoryService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class StoryController : ControllerBase
    {
        private readonly LetsConnectDbContext _context;

        public StoryController(LetsConnectDbContext context)
        {
            _context = context;
        }

        [HttpGet("feed")]
        public async Task<ActionResult> GetStoriesFeed()
        {
            try
            {
                var stories = await _context.Stories
                    .Where(s => !s.IsDeleted && s.ExpiresAt > DateTime.UtcNow)
                    .Include(s => s.User)
                    .OrderByDescending(s => s.CreatedAt)
                    .Take(20)
                    .Select(s => new {
                        id = s.Id,
                        userId = s.UserId,
                        username = s.User.Username,
                        mediaUrl = s.MediaUrl,
                        caption = s.Caption,
                        createdAt = s.CreatedAt,
                        expiresAt = s.ExpiresAt
                    })
                    .ToListAsync();

                return Ok(stories);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }
    }
}
