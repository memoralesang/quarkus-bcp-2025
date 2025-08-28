# Fix for "Invalid nonce" Error in Keycloak

## Problem
The token is being cleared immediately after login due to "Invalid nonce" error:
```
[KEYCLOAK] Token expires in 300 s
[KEYCLOAK] Invalid nonce, clearing token
```

## Root Cause
This happens when there's a mismatch between the PKCE configuration in Keycloak and the frontend, or when the nonce validation fails.

## Solution Steps

### 1. Check Keycloak Client Configuration

1. **Open Keycloak Admin Console:**
   - URL: `http://localhost:8888/admin`
   - Login with admin credentials

2. **Navigate to Client Settings:**
   - Realm: `quarkus`
   - Clients → `frontend-service`

3. **Check Advanced Settings:**
   - Go to "Advanced" tab
   - Look for "PKCE Code Challenge Method"
   - **Set it to "Choose..."** (this disables PKCE enforcement)

4. **Alternative: Configure PKCE Properly**
   - If you want to keep PKCE, set "PKCE Code Challenge Method" to "S256"
   - Make sure "Client authentication" is OFF (since it's a public client)

### 2. Test the Fix

1. **Restart your frontend** to pick up the configuration changes
2. **Try the "Test No PKCE" button** (orange button)
3. **Check the console logs** for:
   - ✅ No more "Invalid nonce" errors
   - ✅ Token being received and stored properly
   - ✅ Authentication state changing to `true`

### 3. If PKCE is Required

If your organization requires PKCE, ensure:

1. **Frontend Configuration:**
   ```javascript
   initOptions={{ 
     onLoad: "check-sso",
     pkceMethod: "S256",  // Re-enable this
     checkLoginIframe: false,
     enableLogging: true
   }}
   ```

2. **Keycloak Client Configuration:**
   - PKCE Code Challenge Method: "S256"
   - Client authentication: OFF
   - Valid redirect URIs: `http://172.17.0.1:8080/*`
   - Web Origins: `http://172.17.0.1:8080`

### 4. Alternative: Use Standard Flow

If PKCE continues to cause issues, you can use the standard authorization code flow:

1. **In Keycloak:**
   - Set "PKCE Code Challenge Method" to "Choose..."

2. **In Frontend:**
   - Remove `pkceMethod: "S256"` from initOptions

## Expected Behavior After Fix

1. **Login Flow:**
   - Click login → Redirect to Keycloak
   - Enter credentials → Redirect back to frontend
   - Token received and stored ✅

2. **Console Logs:**
   ```
   ✅ Authentication successful!
   🎫 Keycloak tokens received: {token: "...", refreshToken: "..."}
   ✅ Access token received: eyJhbGciOiJSUzI1NiIs...
   ```

3. **UI Changes:**
   - "Login with Keycloak" button disappears
   - "Welcome, user!" message appears
   - Speakers data loads automatically

## Troubleshooting

If the problem persists:

1. **Clear browser cache and cookies**
2. **Check browser console for CORS errors**
3. **Verify Keycloak is running on port 8888**
4. **Ensure backend is running on port 8082**
5. **Check that redirect URI matches exactly**

## Security Note

Disabling PKCE reduces security slightly, but the standard authorization code flow is still secure for server-side applications. For production, consider implementing PKCE properly or using a server-side flow.
