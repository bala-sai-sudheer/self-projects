namespace SearchService.Models
{
    public class SearchRequestDTO
    {
        public string Query { get; set; } = string.Empty;
        public string? Type { get; set; } // users, posts, hashtags
        public int Page { get; set; } = 1;
        public int PageSize { get; set; } = 20;
    }

    public class SearchResultDTO<T>
    {
        public IEnumerable<T> Results { get; set; } = new List<T>();
        public int TotalCount { get; set; }
        public int Page { get; set; }
        public int PageSize { get; set; }
        public bool HasMore { get; set; }
    }

    public class UserSearchDTO
    {
        public Guid Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;
        public string? ProfilePicture { get; set; }
        public string? Bio { get; set; }
        public bool IsVerified { get; set; }
        public int FollowerCount { get; set; }
        public int PostCount { get; set; }
    }

    public class PostSearchDTO
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public string Username { get; set; } = string.Empty;
        public string? UserProfilePicture { get; set; }
        public string? Caption { get; set; }
        public string? Location { get; set; }
        public string PostType { get; set; } = string.Empty;
        public string? ThumbnailUrl { get; set; }
        public int LikeCount { get; set; }
        public int CommentCount { get; set; }
        public DateTime CreatedAt { get; set; }
        public List<string> Hashtags { get; set; } = new();
    }

    public class HashtagSearchDTO
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public int PostCount { get; set; }
        public string? TopPostThumbnail { get; set; }
    }

    public class TrendingDTO
    {
        public List<HashtagSearchDTO> TrendingHashtags { get; set; } = new();
        public List<UserSearchDTO> SuggestedUsers { get; set; } = new();
    }

    public class ExploreDTO
    {
        public List<PostSearchDTO> PopularPosts { get; set; } = new();
        public List<HashtagSearchDTO> TrendingHashtags { get; set; } = new();
        public List<UserSearchDTO> SuggestedUsers { get; set; } = new();
    }
}
