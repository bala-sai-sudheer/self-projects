using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LetsConnect.Common.Models
{
    [Table("Posts")]
    public class Post : BaseEntity
    {
        [Required]
        public Guid UserId { get; set; }

        public string? Caption { get; set; }
        public string? Location { get; set; }
        public bool IsArchived { get; set; } = false;
        public bool IsDeleted { get; set; } = false;
        
        [MaxLength(20)]
        public string PostType { get; set; } = "IMAGE";
        
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

        // Navigation properties
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;
        public virtual ICollection<PostMedia> PostMedia { get; set; } = new List<PostMedia>();
        public virtual ICollection<PostLike> PostLikes { get; set; } = new List<PostLike>();
        public virtual ICollection<Comment> Comments { get; set; } = new List<Comment>();
        public virtual ICollection<PostHashtag> PostHashtags { get; set; } = new List<PostHashtag>();
        public virtual ICollection<Bookmark> Bookmarks { get; set; } = new List<Bookmark>();
    }
}
