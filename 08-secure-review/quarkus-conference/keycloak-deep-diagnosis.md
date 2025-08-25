# Deep Diagnosis: Keycloak "Invalid nonce" Error

## Problem Summary
- ✅ Token is issued: `[KEYCLOAK] Token expires in 900 s`
- ❌ Token is immediately cleared: `[KEYCLOAK] Invalid nonce, clearing token`
- ❌ Frontend receives empty tokens: `{idToken: undefined, refreshToken: undefined, token: undefined}`
- ❌ Error persists with both Standard and Implicit flows

## Root Cause Analysis

This error typically occurs when:
1. **Client configuration mismatch** between Keycloak and frontend
2. **Version compatibility issues** between Keycloak and @react-keycloak/web
3. **Session/state management problems**
4. **CORS or security configuration issues**

## Step-by-Step Diagnosis

### 1. Check Keycloak Version
```bash
# Check Keycloak version in admin console
# Look for version number in the footer or about section
```

### 2. Verify Client Configuration
In Keycloak Admin Console → Clients → `frontend-service`:

**General Settings:**
- ✅ Client ID: `frontend-service`
- ✅ Client Protocol: `openid-connect`
- ✅ Access Type: `public`

**Capability Config:**
- ✅ Client authentication: `OFF`
- ✅ Authorization: `OFF`
- ✅ Standard flow: `ON` (for standard) or `OFF` (for implicit)
- ✅ Implicit flow: `OFF` (for standard) or `ON` (for implicit)
- ✅ PKCE Method: `Choose...` (not specified)

**Valid Redirect URIs:**
- ✅ `http://localhost:8080/*`
- ✅ `http://172.17.0.1:8080/*`

**Web Origins:**
- ✅ `http://localhost:8080`
- ✅ `http://172.17.0.1:8080`

### 3. Test Basic Connectivity
Use the "Debug Config" button to verify:
- ✅ Keycloak realm is accessible
- ✅ Client configuration is correct
- ✅ No CORS errors

### 4. Test Minimal Configuration
Use the "Basic Auth" button to test the simplest possible flow.

## Potential Solutions

### Solution 1: Recreate the Client
1. **Delete the current client:**
   - Go to Clients → `frontend-service`
   - Click "Delete" button
   - Confirm deletion

2. **Create a new client:**
   - Click "Create client"
   - Client ID: `frontend-service-new`
   - Client Protocol: `openid-connect`
   - Root URL: `http://172.17.0.1:8080`

3. **Configure the new client:**
   - Access Type: `public`
   - Valid Redirect URIs: `http://172.17.0.1:8080/*`
   - Web Origins: `http://172.17.0.1:8080`
   - Standard flow: `ON`
   - Implicit flow: `OFF`
   - PKCE Method: `Choose...`

4. **Update frontend configuration:**
   ```javascript
   // In keycloak.js
   const keycloak = new Keycloak({
     url: 'http://localhost:8888',
     realm: 'quarkus',
     clientId: 'frontend-service-new'  // Update this
   });
   ```

### Solution 2: Use Different Authentication Flow
Try using **Direct Access Grants** instead:

1. **In Keycloak:**
   - Enable "Direct access grants" in Capability config
   - Disable Standard and Implicit flows

2. **In Frontend:**
   ```javascript
   initOptions={{ 
     onLoad: "check-sso",
     checkLoginIframe: false,
     enableLogging: true,
     flow: 'direct'
   }}
   ```

### Solution 3: Check for Version Compatibility
Verify the versions are compatible:

```bash
# Check @react-keycloak/web version
npm list @react-keycloak/web

# Check keycloak-js version
npm list keycloak-js
```

**Compatible versions:**
- @react-keycloak/web: ^3.4.0
- keycloak-js: ^21.0.0

### Solution 4: Clear Browser State
1. **Clear all browser data:**
   - Cookies
   - Local Storage
   - Session Storage
   - Cache

2. **Try in incognito/private mode**

## Testing Steps

1. **Click "Debug Config"** - Check Keycloak accessibility
2. **Click "Basic Auth"** - Test minimal configuration
3. **If still failing, try Solution 1** (recreate client)
4. **If still failing, try Solution 2** (direct access grants)

## Expected Results

After successful fix:
- ✅ No "Invalid nonce" errors
- ✅ Token received and stored: `{token: "eyJhbGciOiJSUzI1NiIs...", ...}`
- ✅ Authentication state: `true`
- ✅ Speakers data loads automatically

## Next Steps

If none of these solutions work, we may need to:
1. **Check Keycloak server logs** for detailed error messages
2. **Try a different Keycloak version**
3. **Use a different authentication library** (like `@auth0/auth0-react`)
