// Configuration for different environments
const config = {
  development: {
    keycloakUrl: 'http://localhost:8888',
    keycloakRealm: 'quarkus',
    clientId: 'frontend-service',
    backendUrl: 'http://localhost:8082/',
    frontendUrl: 'http://localhost:62476',
    // Default credentials for testing
    defaultUsername: 'user',
    defaultPassword: 'redhat'
  },
  production: {
    keycloakUrl: process.env.REACT_APP_KEYCLOAK_URL || 'http://localhost:8888',
    keycloakRealm: process.env.REACT_APP_KEYCLOAK_REALM || 'quarkus',
    clientId: process.env.REACT_APP_CLIENT_ID || 'frontend-service',
    backendUrl: process.env.BACKEND || 'http://localhost:8082/',
    frontendUrl: process.env.REACT_APP_FRONTEND_URL || 'http://localhost:62476'
  }
};

const env = process.env.NODE_ENV || 'development';
export default config[env];
