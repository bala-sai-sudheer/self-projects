using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LetsConnect.Common.Data;

namespace NotificationService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class NotificationController : ControllerBase
    {
        private readonly LetsConnectDbContext _context;

        public NotificationController(LetsConnectDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult> GetNotifications()
        {
            try
            {
                var notifications = await _context.Notifications
                    .Include(n => n.Actor)
                    .OrderByDescending(n => n.CreatedAt)
                    .Take(20)
                    .Select(n => new {
                        id = n.Id,
                        actor = n.Actor.Username,
                        type = n.Type,
                        message = n.Message,
                        isRead = n.IsRead,
                        createdAt = n.CreatedAt
                    })
                    .ToListAsync();

                return Ok(notifications);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }
    }
}
