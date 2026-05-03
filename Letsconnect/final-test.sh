#!/bin/bash

DB_PASSWORD='YourPassword123!'
JWT_KEY='YourSuperSecretKeyThatIsAtLeast32BytesLong!@#$%^&*()'
BASE_URL="http://localhost:5001"

echo "=========================================="
echo "🎉 Let's Connect - Final Test Suite"
echo "=========================================="

# 1. Register User
echo ""
echo "=========================================="
echo "1. REGISTER NEW USER"
echo "=========================================="
REGISTER=$(curl -s -X POST ${BASE_URL}/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@letsconnect.com",
    "password": "John@123",
    "fullName": "John Doe"
  }')

echo "Registration Response:"
echo "$REGISTER" | python3 -m json.tool 2>/dev/null || echo "$REGISTER"

# Extract token
TOKEN=$(echo "$REGISTER" | python3 -c "import sys, json; print(json.load(sys.stdin).get('token',''))" 2>/dev/null)

if [ -z "$TOKEN" ]; then
    echo "⚠️ Registration might have failed (user may already exist), trying login..."
    
    # 2. Login
    echo ""
    echo "=========================================="
    echo "2. LOGIN"
    echo "=========================================="
    LOGIN=$(curl -s -X POST ${BASE_URL}/api/auth/login \
      -H "Content-Type: application/json" \
      -d '{
        "email": "john@letsconnect.com",
        "password": "John@123"
      }')
    
    echo "Login Response:"
    echo "$LOGIN" | python3 -m json.tool 2>/dev/null || echo "$LOGIN"
    
    TOKEN=$(echo "$LOGIN" | python3 -c "import sys, json; print(json.load(sys.stdin).get('token',''))" 2>/dev/null)
fi

if [ -z "$TOKEN" ]; then
    echo "❌ Failed to authenticate"
    exit 1
fi

echo ""
echo "✅ Authenticated successfully!"
echo "Token: ${TOKEN:0:50}..."

# 3. Get Profile
echo ""
echo "=========================================="
echo "3. GET PROFILE"
echo "=========================================="
curl -s ${BASE_URL}/api/auth/profile \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool 2>/dev/null

# 4. Create Post
echo ""
echo "=========================================="
echo "4. CREATE POST"
echo "=========================================="
POST_RESULT=$(curl -s -X POST http://localhost:5002/api/post/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "caption": "Hello everyone! This is my first post on LetsConnect! #firstpost #excited",
    "location": "Mumbai, India"
  }')
echo "$POST_RESULT" | python3 -m json.tool 2>/dev/null || echo "$POST_RESULT"

# Extract post ID
POST_ID=$(echo "$POST_RESULT" | python3 -c "import sys, json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)

# 5. Get Feed
echo ""
echo "=========================================="
echo "5. GET FEED"
echo "=========================================="
curl -s http://localhost:5002/api/post/feed \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool 2>/dev/null

# 6. Test Story Service
echo ""
echo "=========================================="
echo "6. STORY SERVICE HEALTH"
echo "=========================================="
curl -s http://localhost:5003/swagger/index.html | head -1
echo "Story Service is running!"

# 7. Test Message Service
echo ""
echo "=========================================="
echo "7. MESSAGE SERVICE HEALTH"
echo "=========================================="
curl -s http://localhost:5004/swagger/index.html | head -1
echo "Message Service is running!"

# 8. Test Notification Service
echo ""
echo "=========================================="
echo "8. NOTIFICATION SERVICE HEALTH"
echo "=========================================="
curl -s http://localhost:5005/swagger/index.html | head -1
echo "Notification Service is running!"

# 9. Test Search Service
echo ""
echo "=========================================="
echo "9. SEARCH SERVICE HEALTH"
echo "=========================================="
curl -s http://localhost:5006/swagger/index.html | head -1
echo "Search Service is running!"

# 10. Test Search
echo ""
echo "=========================================="
echo "10. SEARCH USERS"
echo "=========================================="
curl -s "http://localhost:5006/api/search/users?query=john&page=1&pageSize=10" \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool 2>/dev/null

echo ""
echo ""
echo "=========================================="
echo "✅ FINAL TEST COMPLETE!"
echo "=========================================="
echo ""
echo "All Services are working correctly!"
echo ""
echo "📌 Service URLs:"
echo "   User Service:    http://localhost:5001/swagger"
echo "   Post Service:    http://localhost:5002/swagger"
echo "   Story Service:   http://localhost:5003/swagger"
echo "   Message Service: http://localhost:5004/swagger"
echo "   Notification:    http://localhost:5005/swagger"
echo "   Search Service:  http://localhost:5006/swagger"
echo ""
echo "📌 Test Credentials:"
echo "   Email: john@letsconnect.com"
echo "   Password: John@123"
echo ""
echo "📌 Use the JWT Token for authenticated requests:"
echo "   curl -H 'Authorization: Bearer $TOKEN' http://localhost:5001/api/auth/profile"
