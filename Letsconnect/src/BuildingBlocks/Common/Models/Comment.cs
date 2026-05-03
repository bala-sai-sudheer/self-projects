using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LetsConnect.Common.Models
{
    [Table("Comments")]
    public class Comment : BaseEntity
    {
        [Required]
        public Guid PostId { get; set; }

        [Required]
        public Guid UserId { get; set; }

        public Guid? ParentCommentId { get; set; }

        [Required]
        public string Content { get; set; } = string.Empty;

        public bool IsDeleted { get; set; } = false;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey("PostId")]
        public virtual Post Post { get; set; } = null!;

        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;

        [ForeignKey("ParentCommentId")]
        public virtual Comment? ParentComment { get; set; }
        public virtual ICollection<Comment> Replies { get; set; } = new List<Comment>();
        public virtual ICollection<CommentLike> CommentLikes { get; set; } = new List<CommentLike>();
    }
}
