namespace PostService.Models
{
    public class PostDTO
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public string? Caption { get; set; }
        public string? Location { get; set; }
        public string? PostType { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    public class CreatePostDTO
    {
        public string? Caption { get; set; }
        public string? Location { get; set; }
        public List<IFormFile>? MediaFiles { get; set; }
    }

    public class UpdatePostDTO
    {
        public string? Caption { get; set; }
        public string? Location { get; set; }
    }

    public class CreateCommentDTO
    {
        public string? Content { get; set; }
        public Guid? ParentCommentId { get; set; }
    }

    public class CommentDTO
    {
        public Guid Id { get; set; }
        public string? Content { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
