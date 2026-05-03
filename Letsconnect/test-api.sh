#!/bin/bash

echo "=========================================="
echo "LetsConnect API Test Script"
echo "=========================================="

# Register
echo ""
echo "1. Registering user..."
REGISTER=$(curl -s -X POST http://localhost:5001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"demo","email":"demo@test.com","password":"Demo@123","fullName":"Demo User"}')
echo "$REGISTER"

# Extract token
TOKEN=$(echo "$REGISTER" | python3 -c "import sys, json; print(json.load(sys.stdin).get('token',''))" 2>/dev/null)

if [ -z "$TOKEN" ]; then
    echo ""
    echo "2. Registration may have failed, trying login..."
    LOGIN=$(curl -s -X POST http://localhost:5001/api/auth/login \
      -H "Content-Type: application/json" \
      -d '{"email":"demo@test.com","password":"Demo@123"}')
    echo "$LOGIN"
    TOKEN=$(echo "$LOGIN" | python3 -c "import sys, json; print(json.load(sys.stdin).get('token',''))" 2>/dev/null)
fi

if [ -n "$TOKEN" ]; then
    echo ""
    echo "✅ Authenticated! Token: ${TOKEN:0:30}..."
    
    echo ""
    echo "3. Getting Profile..."
    curl -s http://localhost:5001/api/auth/profile \
      -H "Authorization: Bearer $TOKEN"
    
    echo ""
    echo ""
    echo "4. Creating a Post..."
    curl -s -X POST http://localhost:5002/api/post/create \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $TOKEN" \
      -d '{"caption":"Hello LetsConnect! #firstpost","location":"Mumbai, India"}'
    
    echo ""
    echo ""
    echo "5. Getting Feed..."
    curl -s http://localhost:5002/api/post/feed \
      -H "Authorization: Bearer $TOKEN"
else
    echo "❌ Authentication failed"
fi

echo ""
echo ""
echo "=========================================="
echo "Test Complete!"
echo "=========================================="
