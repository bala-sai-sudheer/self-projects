using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LetsConnect.Common.Data;
using LetsConnect.Common.Models;
using System.Security.Claims;

namespace MessageService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class MessageController : ControllerBase
    {
        private readonly LetsConnectDbContext _context;

        public MessageController(LetsConnectDbContext context)
        {
            _context = context;
        }

        [HttpGet("conversations")]
        public async Task<ActionResult> GetConversations()
        {
            try
            {
                var userId = GetUserId();
                if (userId == null) return Unauthorized();

                var sentMessages = await _context.Messages
                    .Where(m => m.SenderId == userId && !m.IsDeleted)
                    .Include(m => m.Receiver)
                    .OrderByDescending(m => m.CreatedAt)
                    .Take(50)
                    .ToListAsync();

                var receivedMessages = await _context.Messages
                    .Where(m => m.ReceiverId == userId && !m.IsDeleted)
                    .Include(m => m.Sender)
                    .OrderByDescending(m => m.CreatedAt)
                    .Take(50)
                    .ToListAsync();

                // Group by conversation partner
                var conversations = new Dictionary<Guid, object>();
                
                foreach (var msg in sentMessages)
                {
                    if (!conversations.ContainsKey(msg.ReceiverId))
                    {
                        conversations[msg.ReceiverId] = new {
                            userId = msg.ReceiverId,
                            username = msg.Receiver.Username,
                            fullName = msg.Receiver.FullName,
                            lastMessage = msg.Content,
                            lastMessageTime = msg.CreatedAt
                        };
                    }
                }
                
                foreach (var msg in receivedMessages)
                {
                    if (!conversations.ContainsKey(msg.SenderId))
                    {
                        conversations[msg.SenderId] = new {
                            userId = msg.SenderId,
                            username = msg.Sender.Username,
                            fullName = msg.Sender.FullName,
                            lastMessage = msg.Content,
                            lastMessageTime = msg.CreatedAt
                        };
                    }
                }

                return Ok(conversations.Values.OrderByDescending(c => ((dynamic)c).lastMessageTime));
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }

        [HttpGet("conversation/{otherUserId}")]
        public async Task<ActionResult> GetConversation(Guid otherUserId)
        {
            try
            {
                var userId = GetUserId();
                if (userId == null) return Unauthorized();

                var messages = await _context.Messages
                    .Where(m => !m.IsDeleted &&
                        ((m.SenderId == userId && m.ReceiverId == otherUserId) ||
                         (m.SenderId == otherUserId && m.ReceiverId == userId)))
                    .Include(m => m.Sender)
                    .Include(m => m.Receiver)
                    .OrderBy(m => m.CreatedAt)
                    .Select(m => new {
                        id = m.Id,
                        senderId = m.SenderId,
                        senderUsername = m.Sender.Username,
                        receiverId = m.ReceiverId,
                        receiverUsername = m.Receiver.Username,
                        content = m.Content,
                        createdAt = m.CreatedAt
                    })
                    .ToListAsync();

                return Ok(messages);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }

        [HttpPost("send")]
        public async Task<ActionResult> SendMessage([FromBody] SendMessageRequest request)
        {
            try
            {
                var userId = GetUserId();
                if (userId == null) return Unauthorized(new { message = "Not authenticated" });

                if (string.IsNullOrWhiteSpace(request.Content))
                    return BadRequest(new { message = "Message cannot be empty" });

                var message = new Message
                {
                    Id = Guid.NewGuid(),
                    SenderId = userId.Value,
                    ReceiverId = request.ReceiverId,
                    Content = request.Content,
                    CreatedAt = DateTime.UtcNow
                };

                _context.Messages.Add(message);
                await _context.SaveChangesAsync();

                return Ok(new { 
                    id = message.Id, 
                    content = message.Content,
                    senderId = message.SenderId,
                    receiverId = message.ReceiverId,
                    message = "Message sent!" 
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }

        private Guid? GetUserId()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdClaim)) return null;
            return Guid.Parse(userIdClaim);
        }
    }

    public class SendMessageRequest
    {
        public Guid ReceiverId { get; set; }
        public string? Content { get; set; }
    }
}
