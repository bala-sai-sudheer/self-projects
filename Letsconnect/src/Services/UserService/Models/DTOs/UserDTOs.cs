// src/Services/UserService/Models/DTOs/UserDTOs.cs
namespace UserService.Models.DTOs
{
    public class RegisterUserDTO
    {
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;
    }

    public class LoginDTO
    {
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
    }

    public class UserProfileDTO
    {
        public Guid Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;
        public string? Bio { get; set; }
        public string? ProfilePicture { get; set; }
        public string? Website { get; set; }
        public bool IsPrivate { get; set; }
        public bool IsVerified { get; set; }
        public int FollowerCount { get; set; }
        public int FollowingCount { get; set; }
        public int PostCount { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    public class UpdateProfileDTO
    {
        public string? FullName { get; set; }
        public string? Bio { get; set; }
        public string? Website { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Gender { get; set; }
        public bool? IsPrivate { get; set; }
    }

    public class AuthResponseDTO
    {
        public string Token { get; set; } = string.Empty;
        public string RefreshToken { get; set; } = string.Empty;
        public DateTime ExpiresAt { get; set; }
        public UserProfileDTO User { get; set; } = null!;
    }
}
