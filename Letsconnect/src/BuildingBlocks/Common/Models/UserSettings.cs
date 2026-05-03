using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LetsConnect.Common.Models
{
    [Table("UserSettings")]
    public class UserSettings : BaseEntity
    {
        [Required]
        public Guid UserId { get; set; }

        public bool NotificationsEnabled { get; set; } = true;
        public bool EmailNotifications { get; set; } = true;
        public bool DarkMode { get; set; } = false;

        [MaxLength(10)]
        public string Language { get; set; } = "en";

        [MaxLength(20)]
        public string Theme { get; set; } = "default";

        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;
    }
}
