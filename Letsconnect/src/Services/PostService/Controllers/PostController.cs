using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LetsConnect.Common.Data;
using LetsConnect.Common.Models;
using System.Security.Claims;

namespace PostService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PostController : ControllerBase
    {
        private readonly LetsConnectDbContext _context;

        public PostController(LetsConnectDbContext context)
        {
            _context = context;
        }

        // GET feed with likes and comments
        [HttpGet("feed")]
        public async Task<ActionResult> GetFeed()
        {
            try
            {
                var userId = GetUserId();
                var posts = await _context.Posts
                    .Where(p => !p.IsDeleted)
                    .Include(p => p.User)
                    .Include(p => p.Comments.Where(c => !c.IsDeleted))
                        .ThenInclude(c => c.User)
                    .Include(p => p.PostLikes)
                    .OrderByDescending(p => p.CreatedAt)
                    .Take(20)
                    .Select(p => new {
                        id = p.Id,
                        caption = p.Caption,
                        location = p.Location,
                        createdAt = p.CreatedAt,
                        user = new {
                            id = p.User.Id,
                            username = p.User.Username,
                            fullName = p.User.FullName
                        },
                        comments = p.Comments.OrderBy(c => c.CreatedAt).Select(c => new {
                            id = c.Id,
                            content = c.Content,
                            createdAt = c.CreatedAt,
                            user = new { id = c.User.Id, username = c.User.Username }
                        }),
                        commentCount = p.Comments.Count,
                        likeCount = p.PostLikes.Count,
                        isLiked = userId != null && p.PostLikes.Any(l => l.UserId == userId)
                    })
                    .ToListAsync();
                
                return Ok(posts);
            }
            catch (Exception ex) { return StatusCode(500, new { error = ex.Message }); }
        }

        // GET user posts
        [HttpGet("user/{userId}")]
        public async Task<ActionResult> GetUserPosts(Guid userId)
        {
            try
            {
                var currentUserId = GetUserId();
                var posts = await _context.Posts
                    .Where(p => p.UserId == userId && !p.IsDeleted)
                    .Include(p => p.User)
                    .Include(p => p.Comments.Where(c => !c.IsDeleted))
                        .ThenInclude(c => c.User)
                    .Include(p => p.PostLikes)
                    .OrderByDescending(p => p.CreatedAt)
                    .Select(p => new {
                        id = p.Id,
                        caption = p.Caption,
                        location = p.Location,
                        createdAt = p.CreatedAt,
                        user = new { id = p.User.Id, username = p.User.Username, fullName = p.User.FullName },
                        comments = p.Comments.OrderBy(c => c.CreatedAt).Select(c => new {
                            id = c.Id, content = c.Content, createdAt = c.CreatedAt,
                            user = new { id = c.User.Id, username = c.User.Username }
                        }),
                        commentCount = p.Comments.Count,
                        likeCount = p.PostLikes.Count,
                        isLiked = currentUserId != null && p.PostLikes.Any(l => l.UserId == currentUserId)
                    })
                    .ToListAsync();
                return Ok(posts);
            }
            catch (Exception ex) { return StatusCode(500, new { error = ex.Message }); }
        }

        // CREATE post
        [HttpPost("create")]
        public async Task<ActionResult> CreatePost([FromBody] CreatePostRequest request)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdClaim)) return Unauthorized();
            var userId = Guid.Parse(userIdClaim);
            var post = new Post { Id = Guid.NewGuid(), UserId = userId, Caption = request.Caption, Location = request.Location, CreatedAt = DateTime.UtcNow };
            _context.Posts.Add(post);
            await _context.SaveChangesAsync();
            return Ok(new { id = post.Id, caption = post.Caption, location = post.Location, message = "Post created!" });
        }

        // LIKE post
        [HttpPost("{postId}/like")]
        public async Task<ActionResult> LikePost(Guid postId)
        {
            var userId = GetUserId();
            if (userId == null) return Unauthorized();
            
            var existing = await _context.PostLikes.FirstOrDefaultAsync(l => l.PostId == postId && l.UserId == userId);
            if (existing != null) return BadRequest(new { message = "Already liked" });
            
            _context.PostLikes.Add(new PostLike { Id = Guid.NewGuid(), PostId = postId, UserId = userId.Value });
            await _context.SaveChangesAsync();
            
            var count = await _context.PostLikes.CountAsync(l => l.PostId == postId);
            return Ok(new { likeCount = count, isLiked = true });
        }

        // UNLIKE post
        [HttpDelete("{postId}/like")]
        public async Task<ActionResult> UnlikePost(Guid postId)
        {
            var userId = GetUserId();
            if (userId == null) return Unauthorized();
            
            var like = await _context.PostLikes.FirstOrDefaultAsync(l => l.PostId == postId && l.UserId == userId);
            if (like == null) return NotFound();
            
            _context.PostLikes.Remove(like);
            await _context.SaveChangesAsync();
            
            var count = await _context.PostLikes.CountAsync(l => l.PostId == postId);
            return Ok(new { likeCount = count, isLiked = false });
        }

        // EDIT post
        [HttpPut("{postId}")]
        public async Task<ActionResult> EditPost(Guid postId, [FromBody] CreatePostRequest request)
        {
            var userId = GetUserId();
            if (userId == null) return Unauthorized();
            
            var post = await _context.Posts.FindAsync(postId);
            if (post == null) return NotFound();
            if (post.UserId != userId) return Forbid();
            
            post.Caption = request.Caption;
            post.Location = request.Location;
            post.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();
            return Ok(new { message = "Post updated!" });
        }

        // DELETE post (soft delete)
        [HttpDelete("{postId}")]
        public async Task<ActionResult> DeletePost(Guid postId)
        {
            var userId = GetUserId();
            if (userId == null) return Unauthorized();
            
            var post = await _context.Posts.FindAsync(postId);
            if (post == null) return NotFound();
            if (post.UserId != userId) return Forbid();
            
            post.IsDeleted = true;
            await _context.SaveChangesAsync();
            return Ok(new { message = "Post deleted!" });
        }

        // ADD COMMENT
        [HttpPost("{postId}/comment")]
        public async Task<ActionResult> AddComment(Guid postId, [FromBody] AddCommentRequest request)
        {
            var userId = GetUserId();
            if (userId == null) return Unauthorized();
            if (string.IsNullOrWhiteSpace(request.Content)) return BadRequest();
            
            var comment = new Comment { Id = Guid.NewGuid(), PostId = postId, UserId = userId.Value, Content = request.Content, CreatedAt = DateTime.UtcNow };
            _context.Comments.Add(comment);
            await _context.SaveChangesAsync();
            
            var saved = await _context.Comments.Include(c => c.User).FirstOrDefaultAsync(c => c.Id == comment.Id);
            return Ok(new { id = saved!.Id, content = saved.Content, createdAt = saved.CreatedAt, user = new { id = saved.User.Id, username = saved.User.Username } });
        }

        private Guid? GetUserId()
        {
            var claim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return string.IsNullOrEmpty(claim) ? null : Guid.Parse(claim);
        }
    }

    public class CreatePostRequest { public string? Caption { get; set; } public string? Location { get; set; } }
    public class AddCommentRequest { public string Content { get; set; } = string.Empty; }
}
