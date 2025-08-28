#!/bin/bash

echo "=== Testing Keycloak Authentication ==="

# Test 1: Check if Keycloak is running
echo "1. Testing Keycloak connection..."
if curl -s http://localhost:8888/realms/quarkus > /dev/null; then
    echo "✅ Keycloak is running"
else
    echo "❌ Keycloak is not running on http://localhost:8888"
    exit 1
fi

# Test 2: Check if Quarkus backend is running
echo "2. Testing Quarkus backend..."
if curl -s http://localhost:8082/speakers/health > /dev/null; then
    echo "✅ Quarkus backend is running"
else
    echo "❌ Quarkus backend is not running on http://localhost:8082"
    exit 1
fi

# Test 3: Test authentication endpoint
echo "3. Testing authentication..."
TOKEN_RESPONSE=$(curl -s -X POST http://localhost:8888/realms/quarkus/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password" \
  -d "client_id=frontend-service" \
  -d "username=testuser" \
  -d "password=password")

if echo "$TOKEN_RESPONSE" | grep -q "access_token"; then
    echo "✅ Authentication successful"
    TOKEN=$(echo "$TOKEN_RESPONSE" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
    echo "Token obtained: ${TOKEN:0:20}..."
else
    echo "❌ Authentication failed"
    echo "Response: $TOKEN_RESPONSE"
    exit 1
fi

# Test 4: Test API access with token
echo "4. Testing API access..."
API_RESPONSE=$(curl -s -H "Authorization: Bearer $TOKEN" http://localhost:8082/speakers)

if [ $? -eq 0 ]; then
    echo "✅ API access successful"
    echo "Response: $API_RESPONSE"
else
    echo "❌ API access failed"
    echo "Response: $API_RESPONSE"
fi

echo "=== Test completed ==="
