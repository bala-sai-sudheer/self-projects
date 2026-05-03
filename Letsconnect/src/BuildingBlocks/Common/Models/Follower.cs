using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LetsConnect.Common.Models
{
    [Table("Followers")]
    public class Follower : BaseEntity
    {
        [Required]
        public Guid FollowerId { get; set; }

        [Required]
        public Guid FollowingId { get; set; }

        [MaxLength(20)]
        public string Status { get; set; } = "PENDING";

        // Navigation properties
        [ForeignKey("FollowerId")]
        public virtual User FollowerUser { get; set; } = null!;

        [ForeignKey("FollowingId")]
        public virtual User FollowingUser { get; set; } = null!;
    }
}
