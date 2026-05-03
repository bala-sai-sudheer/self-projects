using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LetsConnect.Common.Models
{
    [Table("Bookmarks")]
    public class Bookmark : BaseEntity
    {
        [Required]
        public Guid UserId { get; set; }

        [Required]
        public Guid PostId { get; set; }

        [MaxLength(100)]
        public string? CollectionName { get; set; }

        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;

        [ForeignKey("PostId")]
        public virtual Post Post { get; set; } = null!;
    }
}
