using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LetsConnect.Common.Models
{
    [Table("Stories")]
    public class Story : BaseEntity
    {
        [Required]
        public Guid UserId { get; set; }

        [Required]
        [MaxLength(500)]
        public string MediaUrl { get; set; } = string.Empty;

        [Required]
        [MaxLength(20)]
        public string MediaType { get; set; } = "IMAGE";

        [MaxLength(500)]
        public string? ThumbnailUrl { get; set; }
        public string? Caption { get; set; }
        public int Duration { get; set; } = 24;
        public DateTime ExpiresAt { get; set; }
        public bool IsDeleted { get; set; } = false;

        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;
        public virtual ICollection<StoryView> StoryViews { get; set; } = new List<StoryView>();
    }
}
