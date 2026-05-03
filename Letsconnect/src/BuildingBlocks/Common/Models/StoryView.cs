using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LetsConnect.Common.Models
{
    [Table("StoryViews")]
    public class StoryView : BaseEntity
    {
        [Required]
        public Guid StoryId { get; set; }

        [Required]
        public Guid UserId { get; set; }

        public DateTime ViewedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey("StoryId")]
        public virtual Story Story { get; set; } = null!;

        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;
    }
}
