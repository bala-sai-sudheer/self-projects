#!/bin/bash

DB_PASSWORD='YourPassword123!'
JWT_KEY='YourSuperSecretKeyThatIsAtLeast32BytesLong!@#$%^&*()'
REDIS_PASSWORD='YourRedisPassword'

echo "=========================================="
echo "🚀 Starting LetsConnect Application"
echo "=========================================="

# Create network
docker network create letsconnect-network 2>/dev/null

# Infrastructure
echo "Starting MySQL..."
docker run -d --name letsconnect-mysql --network letsconnect-network \
  -e MYSQL_ROOT_PASSWORD=${DB_PASSWORD} -e MYSQL_DATABASE=LetsConnectDB \
  -p 3306:3306 -v letsconnect-mysql-data:/var/lib/mysql mysql:8.0

echo "Starting Redis..."
docker run -d --name letsconnect-redis --network letsconnect-network \
  -p 6379:6379 redis:alpine redis-server --requirepass ${REDIS_PASSWORD}

echo "Waiting for infrastructure (30s)..."
sleep 30

# Initialize DB
echo "Initializing database..."
docker exec -i letsconnect-mysql mysql -uroot -p${DB_PASSWORD} << 'SQL'
CREATE DATABASE IF NOT EXISTS LetsConnectDB;
USE LetsConnectDB;
CREATE TABLE IF NOT EXISTS Users (Id CHAR(36) PRIMARY KEY, Username VARCHAR(50) UNIQUE NOT NULL, Email VARCHAR(100) UNIQUE NOT NULL, PasswordHash VARCHAR(255) NOT NULL, FullName VARCHAR(100) NOT NULL, Bio TEXT, ProfilePicture VARCHAR(500), Website VARCHAR(200), IsPrivate BOOLEAN DEFAULT FALSE, IsVerified BOOLEAN DEFAULT FALSE, CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP, UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, LastLogin DATETIME, IsActive BOOLEAN DEFAULT TRUE);
CREATE TABLE IF NOT EXISTS Posts (Id CHAR(36) PRIMARY KEY, UserId CHAR(36) NOT NULL, Caption TEXT, Location VARCHAR(200), CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP, UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, IsArchived BOOLEAN DEFAULT FALSE, IsDeleted BOOLEAN DEFAULT FALSE, PostType VARCHAR(20) DEFAULT 'IMAGE', FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS Notifications (Id CHAR(36) PRIMARY KEY, UserId CHAR(36) NOT NULL, ActorId CHAR(36) NOT NULL, Type VARCHAR(20) NOT NULL, EntityId CHAR(36), EntityType VARCHAR(50), Message TEXT, IsRead BOOLEAN DEFAULT FALSE, CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS RefreshTokens (Id CHAR(36) PRIMARY KEY, UserId CHAR(36) NOT NULL, Token VARCHAR(500) NOT NULL, ExpiresAt DATETIME NOT NULL, CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP, IsRevoked BOOLEAN DEFAULT FALSE);
CREATE TABLE IF NOT EXISTS Followers (Id CHAR(36) PRIMARY KEY, FollowerId CHAR(36) NOT NULL, FollowingId CHAR(36) NOT NULL, Status VARCHAR(20) DEFAULT 'PENDING', CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP);
SQL

# Microservices
echo "Starting microservices..."
docker run -d --name letsconnect-user-service --network letsconnect-network \
  -e "ConnectionStrings__DefaultConnection=Server=letsconnect-mysql;Port=3306;Database=LetsConnectDB;User=root;Password=${DB_PASSWORD};" \
  -e "ConnectionStrings__Redis=letsconnect-redis:6379,password=${REDIS_PASSWORD}" \
  -e "Jwt__Key=${JWT_KEY}" -e ASPNETCORE_URLS=http://+:80 -p 5001:80 letsconnect-user-service:latest

docker run -d --name letsconnect-post-service --network letsconnect-network \
  -e "ConnectionStrings__DefaultConnection=Server=letsconnect-mysql;Port=3306;Database=LetsConnectDB;User=root;Password=${DB_PASSWORD};" \
  -e "Jwt__Key=${JWT_KEY}" -e ASPNETCORE_URLS=http://+:80 -p 5002:80 letsconnect-post-service:latest

docker run -d --name letsconnect-story-service --network letsconnect-network \
  -e "ConnectionStrings__DefaultConnection=Server=letsconnect-mysql;Port=3306;Database=LetsConnectDB;User=root;Password=${DB_PASSWORD};" \
  -e "Jwt__Key=${JWT_KEY}" -e ASPNETCORE_URLS=http://+:80 -p 5003:80 letsconnect-story-service:latest

docker run -d --name letsconnect-message-service --network letsconnect-network \
  -e "ConnectionStrings__DefaultConnection=Server=letsconnect-mysql;Port=3306;Database=LetsConnectDB;User=root;Password=${DB_PASSWORD};" \
  -e "Jwt__Key=${JWT_KEY}" -e ASPNETCORE_URLS=http://+:80 -p 5004:80 letsconnect-message-service:latest

docker run -d --name letsconnect-notification-service --network letsconnect-network \
  -e "ConnectionStrings__DefaultConnection=Server=letsconnect-mysql;Port=3306;Database=LetsConnectDB;User=root;Password=${DB_PASSWORD};" \
  -e "Jwt__Key=${JWT_KEY}" -e ASPNETCORE_URLS=http://+:80 -p 5005:80 letsconnect-notification-service:latest

docker run -d --name letsconnect-search-service --network letsconnect-network \
  -e "ConnectionStrings__DefaultConnection=Server=letsconnect-mysql;Port=3306;Database=LetsConnectDB;User=root;Password=${DB_PASSWORD};" \
  -e "ConnectionStrings__Redis=letsconnect-redis:6379,password=${REDIS_PASSWORD}" \
  -e "Jwt__Key=${JWT_KEY}" -e ASPNETCORE_URLS=http://+:80 -p 5006:80 letsconnect-search-service:latest

# Gateway
docker run -d --name letsconnect-gateway --network letsconnect-network \
  -e "Jwt__Key=${JWT_KEY}" -e ASPNETCORE_URLS=http://+:80 -p 5000:80 letsconnect-gateway:latest

# Web Client
docker run -d --name letsconnect-web-client --network letsconnect-network \
  -p 80:80 letsconnect-web-client:latest

sleep 15

echo ""
echo "✅ All containers started!"
echo ""
docker ps --filter "name=letsconnect" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo "🌐 Access: http://172.31.5.102"
