using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LetsConnect.Common.Models
{
    [Table("Users")]
    public class User : BaseEntity
    {
        [Required]
        [MaxLength(50)]
        public string Username { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string Email { get; set; } = string.Empty;

        [Required]
        public string PasswordHash { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string FullName { get; set; } = string.Empty;

        public string? Bio { get; set; }
        public string? ProfilePicture { get; set; }
        public string? Website { get; set; }
        public bool IsPrivate { get; set; } = false;
        public bool IsVerified { get; set; } = false;
        public string? PhoneNumber { get; set; }
        public string? Gender { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public DateTime? LastLogin { get; set; }
        public bool IsActive { get; set; } = true;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

        // Navigation properties
        public virtual ICollection<Follower> Followers { get; set; } = new List<Follower>();
        public virtual ICollection<Follower> Following { get; set; } = new List<Follower>();
        public virtual ICollection<Post> Posts { get; set; } = new List<Post>();
        public virtual UserSettings? UserSettings { get; set; }
    }
}
