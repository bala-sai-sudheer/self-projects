using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LetsConnect.Common.Models
{
    [Table("PostMedia")]
    public class PostMedia : BaseEntity
    {
        [Required]
        public Guid PostId { get; set; }

        [Required]
        [MaxLength(500)]
        public string MediaUrl { get; set; } = string.Empty;

        [Required]
        [MaxLength(20)]
        public string MediaType { get; set; } = "IMAGE";

        [MaxLength(500)]
        public string? ThumbnailUrl { get; set; }
        public int OrderIndex { get; set; } = 0;
        public int Duration { get; set; } = 0;
        public int? Width { get; set; }
        public int? Height { get; set; }

        [ForeignKey("PostId")]
        public virtual Post Post { get; set; } = null!;
    }
}
