-- database/init.sql
CREATE DATABASE IF NOT EXISTS LetsConnectDB;
USE LetsConnectDB;

-- Users table
CREATE TABLE Users (
    Id CHAR(36) PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Bio TEXT,
    ProfilePicture VARCHAR(500),
    Website VARCHAR(200),
    IsPrivate BOOLEAN DEFAULT FALSE,
    IsVerified BOOLEAN DEFAULT FALSE,
    PhoneNumber VARCHAR(20),
    Gender VARCHAR(20),
    DateOfBirth DATE,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    LastLogin DATETIME,
    IsActive BOOLEAN DEFAULT TRUE,
    INDEX idx_username (Username),
    INDEX idx_email (Email)
);

-- Followers table
CREATE TABLE Followers (
    Id CHAR(36) PRIMARY KEY,
    FollowerId CHAR(36) NOT NULL,
    FollowingId CHAR(36) NOT NULL,
    Status ENUM('PENDING', 'ACCEPTED', 'BLOCKED') DEFAULT 'PENDING',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (FollowerId) REFERENCES Users(Id) ON DELETE CASCADE,
    FOREIGN KEY (FollowingId) REFERENCES Users(Id) ON DELETE CASCADE,
    UNIQUE KEY unique_follow (FollowerId, FollowingId),
    INDEX idx_follower (FollowerId),
    INDEX idx_following (FollowingId)
);

-- Posts table
CREATE TABLE Posts (
    Id CHAR(36) PRIMARY KEY,
    UserId CHAR(36) NOT NULL,
    Caption TEXT,
    Location VARCHAR(200),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    IsArchived BOOLEAN DEFAULT FALSE,
    IsDeleted BOOLEAN DEFAULT FALSE,
    PostType ENUM('IMAGE', 'VIDEO', 'CAROUSEL', 'REEL') DEFAULT 'IMAGE',
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    INDEX idx_user_posts (UserId, CreatedAt),
    INDEX idx_created (CreatedAt)
);

-- PostMedia table
CREATE TABLE PostMedia (
    Id CHAR(36) PRIMARY KEY,
    PostId CHAR(36) NOT NULL,
    MediaUrl VARCHAR(500) NOT NULL,
    MediaType ENUM('IMAGE', 'VIDEO') NOT NULL,
    ThumbnailUrl VARCHAR(500),
    OrderIndex INT DEFAULT 0,
    Duration INT DEFAULT 0,
    Width INT,
    Height INT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PostId) REFERENCES Posts(Id) ON DELETE CASCADE,
    INDEX idx_post_media (PostId)
);

-- PostLikes table
CREATE TABLE PostLikes (
    Id CHAR(36) PRIMARY KEY,
    PostId CHAR(36) NOT NULL,
    UserId CHAR(36) NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PostId) REFERENCES Posts(Id) ON DELETE CASCADE,
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    UNIQUE KEY unique_like (PostId, UserId),
    INDEX idx_post_likes (PostId)
);

-- Comments table
CREATE TABLE Comments (
    Id CHAR(36) PRIMARY KEY,
    PostId CHAR(36) NOT NULL,
    UserId CHAR(36) NOT NULL,
    ParentCommentId CHAR(36),
    Content TEXT NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    IsDeleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (PostId) REFERENCES Posts(Id) ON DELETE CASCADE,
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    FOREIGN KEY (ParentCommentId) REFERENCES Comments(Id) ON DELETE CASCADE,
    INDEX idx_post_comments (PostId, CreatedAt)
);

-- CommentLikes table
CREATE TABLE CommentLikes (
    Id CHAR(36) PRIMARY KEY,
    CommentId CHAR(36) NOT NULL,
    UserId CHAR(36) NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CommentId) REFERENCES Comments(Id) ON DELETE CASCADE,
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    UNIQUE KEY unique_comment_like (CommentId, UserId)
);

-- Stories table
CREATE TABLE Stories (
    Id CHAR(36) PRIMARY KEY,
    UserId CHAR(36) NOT NULL,
    MediaUrl VARCHAR(500) NOT NULL,
    MediaType ENUM('IMAGE', 'VIDEO') NOT NULL,
    ThumbnailUrl VARCHAR(500),
    Caption TEXT,
    Duration INT DEFAULT 24,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    ExpiresAt DATETIME,
    IsDeleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    INDEX idx_user_stories (UserId, CreatedAt),
    INDEX idx_expiry (ExpiresAt)
);

-- StoryViews table
CREATE TABLE StoryViews (
    Id CHAR(36) PRIMARY KEY,
    StoryId CHAR(36) NOT NULL,
    UserId CHAR(36) NOT NULL,
    ViewedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (StoryId) REFERENCES Stories(Id) ON DELETE CASCADE,
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    UNIQUE KEY unique_story_view (StoryId, UserId)
);

-- Messages table
CREATE TABLE Messages (
    Id CHAR(36) PRIMARY KEY,
    SenderId CHAR(36) NOT NULL,
    ReceiverId CHAR(36) NOT NULL,
    Content TEXT,
    MessageType ENUM('TEXT', 'IMAGE', 'VIDEO', 'AUDIO', 'FILE') DEFAULT 'TEXT',
    MediaUrl VARCHAR(500),
    IsRead BOOLEAN DEFAULT FALSE,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsDeleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (SenderId) REFERENCES Users(Id) ON DELETE CASCADE,
    FOREIGN KEY (ReceiverId) REFERENCES Users(Id) ON DELETE CASCADE,
    INDEX idx_conversation (SenderId, ReceiverId, CreatedAt)
);

-- Notifications table
CREATE TABLE Notifications (
    Id CHAR(36) PRIMARY KEY,
    UserId CHAR(36) NOT NULL,
    ActorId CHAR(36) NOT NULL,
    Type ENUM('LIKE', 'COMMENT', 'FOLLOW', 'MESSAGE', 'STORY', 'MENTION') NOT NULL,
    EntityId CHAR(36),
    EntityType VARCHAR(50),
    Message TEXT,
    IsRead BOOLEAN DEFAULT FALSE,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    FOREIGN KEY (ActorId) REFERENCES Users(Id) ON DELETE CASCADE,
    INDEX idx_user_notifications (UserId, CreatedAt)
);

-- Hashtags table
CREATE TABLE Hashtags (
    Id CHAR(36) PRIMARY KEY,
    Name VARCHAR(100) UNIQUE NOT NULL,
    PostCount INT DEFAULT 0,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_hashtag_name (Name)
);

-- PostHashtags table
CREATE TABLE PostHashtags (
    PostId CHAR(36) NOT NULL,
    HashtagId CHAR(36) NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (PostId, HashtagId),
    FOREIGN KEY (PostId) REFERENCES Posts(Id) ON DELETE CASCADE,
    FOREIGN KEY (HashtagId) REFERENCES Hashtags(Id) ON DELETE CASCADE
);

-- Bookmarks table
CREATE TABLE Bookmarks (
    Id CHAR(36) PRIMARY KEY,
    UserId CHAR(36) NOT NULL,
    PostId CHAR(36) NOT NULL,
    CollectionName VARCHAR(100),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    FOREIGN KEY (PostId) REFERENCES Posts(Id) ON DELETE CASCADE,
    UNIQUE KEY unique_bookmark (UserId, PostId)
);

-- UserSettings table
CREATE TABLE UserSettings (
    Id CHAR(36) PRIMARY KEY,
    UserId CHAR(36) UNIQUE NOT NULL,
    NotificationsEnabled BOOLEAN DEFAULT TRUE,
    EmailNotifications BOOLEAN DEFAULT TRUE,
    DarkMode BOOLEAN DEFAULT FALSE,
    Language VARCHAR(10) DEFAULT 'en',
    Theme VARCHAR(20) DEFAULT 'default',
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE
);

-- RefreshTokens table
CREATE TABLE RefreshTokens (
    Id CHAR(36) PRIMARY KEY,
    UserId CHAR(36) NOT NULL,
    Token VARCHAR(500) NOT NULL,
    ExpiresAt DATETIME NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsRevoked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    INDEX idx_token (Token)
);
