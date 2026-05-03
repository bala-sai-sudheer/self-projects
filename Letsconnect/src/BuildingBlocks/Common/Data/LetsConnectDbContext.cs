// src/BuildingBlocks/Common/Data/LetsConnectDbContext.cs
using Microsoft.EntityFrameworkCore;
using LetsConnect.Common.Models;

namespace LetsConnect.Common.Data
{
    public class LetsConnectDbContext : DbContext
    {
        public LetsConnectDbContext(DbContextOptions<LetsConnectDbContext> options) : base(options) { }

        public DbSet<User> Users { get; set; }
        public DbSet<Follower> Followers { get; set; }
        public DbSet<Post> Posts { get; set; }
        public DbSet<PostMedia> PostMedia { get; set; }
        public DbSet<PostLike> PostLikes { get; set; }
        public DbSet<Comment> Comments { get; set; }
        public DbSet<CommentLike> CommentLikes { get; set; }
        public DbSet<Story> Stories { get; set; }
        public DbSet<StoryView> StoryViews { get; set; }
        public DbSet<Message> Messages { get; set; }
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<Hashtag> Hashtags { get; set; }
        public DbSet<PostHashtag> PostHashtags { get; set; }
        public DbSet<Bookmark> Bookmarks { get; set; }
        public DbSet<UserSettings> UserSettings { get; set; }
        public DbSet<RefreshToken> RefreshTokens { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // User configuration
            modelBuilder.Entity<User>(entity =>
            {
                entity.HasIndex(e => e.Username).IsUnique();
                entity.HasIndex(e => e.Email).IsUnique();
            });

            // Follower configuration
            modelBuilder.Entity<Follower>(entity =>
            {
                entity.HasOne(f => f.FollowerUser)
                      .WithMany(u => u.Following)
                      .HasForeignKey(f => f.FollowerId)
                      .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(f => f.FollowingUser)
                      .WithMany(u => u.Followers)
                      .HasForeignKey(f => f.FollowingId)
                      .OnDelete(DeleteBehavior.Restrict);
            });

            // Post configuration
            modelBuilder.Entity<Post>(entity =>
            {
                entity.HasOne(p => p.User)
                      .WithMany(u => u.Posts)
                      .HasForeignKey(p => p.UserId);
            });

            // PostHashtag composite key
            modelBuilder.Entity<PostHashtag>(entity =>
            {
                entity.HasKey(ph => new { ph.PostId, ph.HashtagId });
            });
        }
    }
}
