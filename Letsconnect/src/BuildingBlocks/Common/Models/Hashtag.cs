using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LetsConnect.Common.Models
{
    [Table("Hashtags")]
    public class Hashtag : BaseEntity
    {
        [Required]
        [MaxLength(100)]
        public string Name { get; set; } = string.Empty;

        public int PostCount { get; set; } = 0;

        public virtual ICollection<PostHashtag> PostHashtags { get; set; } = new List<PostHashtag>();
    }
}
