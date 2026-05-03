using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LetsConnect.Common.Models
{
    [Table("Messages")]
    public class Message : BaseEntity
    {
        [Required]
        public Guid SenderId { get; set; }

        [Required]
        public Guid ReceiverId { get; set; }

        public string? Content { get; set; }

        [MaxLength(20)]
        public string MessageType { get; set; } = "TEXT";

        [MaxLength(500)]
        public string? MediaUrl { get; set; }
        public bool IsRead { get; set; } = false;
        public bool IsDeleted { get; set; } = false;

        [ForeignKey("SenderId")]
        public virtual User Sender { get; set; } = null!;

        [ForeignKey("ReceiverId")]
        public virtual User Receiver { get; set; } = null!;
    }
}
