using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LetsConnect.Common.Models
{
    [Table("PostHashtags")]
    public class PostHashtag
    {
        [Required]
        public Guid PostId { get; set; }

        [Required]
        public Guid HashtagId { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey("PostId")]
        public virtual Post Post { get; set; } = null!;

        [ForeignKey("HashtagId")]
        public virtual Hashtag Hashtag { get; set; } = null!;
    }
}
