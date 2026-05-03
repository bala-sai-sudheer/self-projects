using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LetsConnect.Common.Data;
using LetsConnect.Common.Models;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Authorization;

namespace UserService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly LetsConnectDbContext _context;
        private readonly IConfiguration _configuration;

        public AuthController(LetsConnectDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        [HttpPost("register")]
        public async Task<ActionResult> Register([FromBody] RegisterRequest request)
        {
            try
            {
                if (await _context.Users.AnyAsync(u => u.Email == request.Email))
                    return BadRequest(new { message = "Email already exists" });

                if (await _context.Users.AnyAsync(u => u.Username == request.Username))
                    return BadRequest(new { message = "Username already exists" });

                var user = new User
                {
                    Id = Guid.NewGuid(),
                    Username = request.Username,
                    Email = request.Email,
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.Password),
                    FullName = request.FullName,
                    CreatedAt = DateTime.UtcNow,
                    IsActive = true
                };

                _context.Users.Add(user);
                await _context.SaveChangesAsync();

                var token = GenerateJwtToken(user);
                var refreshToken = GenerateRefreshToken(user);

                return Ok(new {
                    token,
                    refreshToken = refreshToken.Token,
                    expiresAt = refreshToken.ExpiresAt,
                    user = new {
                        id = user.Id,
                        username = user.Username,
                        email = user.Email,
                        fullName = user.FullName,
                        postCount = 0
                    }
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }

        [HttpPost("login")]
        public async Task<ActionResult> Login([FromBody] LoginRequest request)
        {
            try
            {
                var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == request.Email);
                if (user == null || !BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
                    return Unauthorized(new { message = "Invalid credentials" });

                user.LastLogin = DateTime.UtcNow;
                await _context.SaveChangesAsync();

                var token = GenerateJwtToken(user);
                var refreshToken = GenerateRefreshToken(user);

                // Count actual posts
                var postCount = await _context.Posts.CountAsync(p => p.UserId == user.Id && !p.IsDeleted);

                return Ok(new {
                    token,
                    refreshToken = refreshToken.Token,
                    expiresAt = refreshToken.ExpiresAt,
                    user = new {
                        id = user.Id,
                        username = user.Username,
                        email = user.Email,
                        fullName = user.FullName,
                        postCount = postCount
                    }
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }

        [HttpGet("profile")]
        public async Task<ActionResult> GetProfile()
        {
            try
            {
                var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userIdClaim))
                    return Unauthorized();

                var userId = Guid.Parse(userIdClaim);
                var user = await _context.Users.FindAsync(userId);
                if (user == null) return NotFound();

                // Count actual posts
                var postCount = await _context.Posts.CountAsync(p => p.UserId == userId && !p.IsDeleted);
                var followerCount = await _context.Followers.CountAsync(f => f.FollowingId == userId);
                var followingCount = await _context.Followers.CountAsync(f => f.FollowerId == userId);

                return Ok(new {
                    id = user.Id,
                    username = user.Username,
                    email = user.Email,
                    fullName = user.FullName,
                    bio = user.Bio,
                    profilePicture = user.ProfilePicture,
                    website = user.Website,
                    isPrivate = user.IsPrivate,
                    isVerified = user.IsVerified,
                    postCount = postCount,
                    followerCount = followerCount,
                    followingCount = followingCount,
                    createdAt = user.CreatedAt
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }

        private string GenerateJwtToken(User user)
        {
            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Name, user.Username)
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(
                _configuration["Jwt:Key"] ?? "YourSuperSecretKeyThatIsAtLeast32BytesLong!@#$%^&*()"));
            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"] ?? "LetsConnect",
                audience: _configuration["Jwt:Audience"] ?? "LetsConnect",
                claims: claims,
                expires: DateTime.UtcNow.AddHours(24),
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        private RefreshToken GenerateRefreshToken(User user)
        {
            var refreshToken = new RefreshToken
            {
                Id = Guid.NewGuid(),
                UserId = user.Id,
                Token = Guid.NewGuid().ToString(),
                ExpiresAt = DateTime.UtcNow.AddDays(7),
                CreatedAt = DateTime.UtcNow
            };

            _context.RefreshTokens.Add(refreshToken);
            return refreshToken;
        }
    }

    public class RegisterRequest
    {
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;
    }

    public class LoginRequest
    {
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
    }
}
