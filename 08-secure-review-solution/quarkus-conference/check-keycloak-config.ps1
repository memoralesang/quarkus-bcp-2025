# Check Keycloak Configuration
Write-Host "🔍 Checking Keycloak configuration..." -ForegroundColor Yellow

# Test 1: Check if Keycloak is running
Write-Host "`n1. Testing Keycloak connectivity..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8888/realms/quarkus" -Method Get
    Write-Host "✅ Keycloak is running and accessible" -ForegroundColor Green
} catch {
    Write-Host "❌ Keycloak is not accessible: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 2: Check client configuration
Write-Host "`n2. Testing client configuration..." -ForegroundColor Cyan
try {
    $clientUrl = "http://localhost:8888/realms/quarkus/clients/frontend-service"
    $response = Invoke-RestMethod -Uri $clientUrl -Method Get
    Write-Host "✅ Client 'frontend-service' exists" -ForegroundColor Green
    Write-Host "   Client Type: $($response.clientAuthenticatorType)" -ForegroundColor Gray
    Write-Host "   Public Client: $($response.publicClient)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Cannot access client configuration: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Test authentication flow without PKCE
Write-Host "`n3. Testing authentication flow WITHOUT PKCE..." -ForegroundColor Cyan
$authUrl = "http://localhost:8888/realms/quarkus/protocol/openid-connect/auth"
$fullUrl = "$authUrl?client_id=frontend-service&redirect_uri=http://172.17.0.1:8080/&response_type=code&scope=openid&state=test-no-pkce"
Write-Host "   Auth URL: $fullUrl" -ForegroundColor Gray

# Test 4: Test authentication flow with PKCE
Write-Host "`n4. Testing authentication flow WITH PKCE..." -ForegroundColor Cyan
$pkceFullUrl = "$authUrl?client_id=frontend-service&redirect_uri=http://172.17.0.1:8080/&response_type=code&scope=openid&state=test-with-pkce&code_challenge=test-challenge&code_challenge_method=S256"
Write-Host "   Auth URL with PKCE: $pkceFullUrl" -ForegroundColor Gray

Write-Host "`n📋 Instructions:" -ForegroundColor Yellow
Write-Host "1. Copy the URLs above and test them in your browser" -ForegroundColor White
Write-Host "2. Check if Keycloak shows any errors" -ForegroundColor White
Write-Host "3. Compare the behavior between PKCE and non-PKCE flows" -ForegroundColor White
Write-Host "4. Check the browser console for any 'nonce' related errors" -ForegroundColor White

Write-Host "`n🔧 Keycloak Admin Console:" -ForegroundColor Yellow
Write-Host "   URL: http://localhost:8888/admin" -ForegroundColor White
Write-Host "   Realm: quarkus" -ForegroundColor White
Write-Host "   Client: frontend-service" -ForegroundColor White
Write-Host "   Check: Advanced tab - PKCE Code Challenge Method" -ForegroundColor White
