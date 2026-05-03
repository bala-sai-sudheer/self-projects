using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LetsConnect.Common.Models
{
    [Table("Notifications")]
    public class Notification : BaseEntity
    {
        [Required]
        public Guid UserId { get; set; }

        [Required]
        public Guid ActorId { get; set; }

        [Required]
        [MaxLength(20)]
        public string Type { get; set; } = string.Empty;

        public Guid? EntityId { get; set; }
        
        [MaxLength(50)]
        public string? EntityType { get; set; }
        public string? Message { get; set; }
        public bool IsRead { get; set; } = false;

        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;

        [ForeignKey("ActorId")]
        public virtual User Actor { get; set; } = null!;
    }
}
