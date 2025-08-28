Write-Host "=== Testing Keycloak Authentication ===" -ForegroundColor Green

# Test 1: Check if Keycloak is running
Write-Host "1. Testing Keycloak connection..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8888/realms/quarkus" -UseBasicParsing
    Write-Host "✅ Keycloak is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Keycloak is not running on http://localhost:8888" -ForegroundColor Red
    Write-Host "Make sure Keycloak is running on port 8888" -ForegroundColor Yellow
    exit 1
}

# Test 2: Check if Quarkus backend is running
Write-Host "2. Testing Quarkus backend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8082/speakers/health" -UseBasicParsing
    Write-Host "✅ Quarkus backend is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Quarkus backend is not running on http://localhost:8082" -ForegroundColor Red
    exit 1
}

# Test 3: Test authentication endpoint
Write-Host "3. Testing authentication..." -ForegroundColor Yellow
$body = @{
    grant_type = "password"
    client_id = "frontend-service"
    username = "user"
    password = "redhat"
}

try {
    $tokenResponse = Invoke-RestMethod -Uri "http://localhost:8888/realms/quarkus/protocol/openid-connect/token" -Method POST -Body $body -ContentType "application/x-www-form-urlencoded"
    Write-Host "✅ Authentication successful" -ForegroundColor Green
    $token = $tokenResponse.access_token
    Write-Host "Token obtained: $($token.Substring(0, 20))..." -ForegroundColor Green
} catch {
    Write-Host "❌ Authentication failed" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 4: Test API access with token
Write-Host "4. Testing API access..." -ForegroundColor Yellow
$headers = @{
    Authorization = "Bearer $token"
}

try {
    $apiResponse = Invoke-RestMethod -Uri "http://localhost:8082/speakers" -Headers $headers -Method GET
    Write-Host "✅ API access successful" -ForegroundColor Green
    Write-Host "Response: $($apiResponse | ConvertTo-Json)" -ForegroundColor Green
} catch {
    Write-Host "❌ API access failed" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "=== Test completed ===" -ForegroundColor Green
