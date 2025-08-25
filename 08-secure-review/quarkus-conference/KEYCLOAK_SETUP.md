# Configuración de Keycloak para resolver error 401

## Configuración requerida en Keycloak

### 1. Realm Configuration
- Realm: `quarkus`
- URL: `http://localhost:8888`

### 2. Cliente Backend (`backend-service`)
```
Client ID: backend-service
Client Protocol: openid-connect
Access Type: confidential
Valid Redirect URIs: *
Web Origins: http://localhost:8080
```

### 3. Cliente Frontend (`frontend-service`)
```
Client ID: frontend-service
Client Protocol: openid-connect
Access Type: public
Valid Redirect URIs: http://localhost:8080/*,http://172.17.0.1:8080/*,http://localhost:62476/*,http://172.17.0.1:62476/*,http://0.0.0.0:62476/*
Web Origins: http://localhost:8080,http://172.17.0.1:8080,http://localhost:62476,http://172.17.0.1:62476,http://0.0.0.0:62476
PKCE Code Challenge Method: S256 (o "Not specified" para deshabilitar)
```

### 4. Roles requeridos
Crear los siguientes roles en el realm:
- `read`
- `modify`

### 5. Usuarios disponibles
Los siguientes usuarios ya están configurados en Keycloak:
- Username: `user` - Password: `redhat`
- Username: `superuser` - Password: `redhat`

Ambos usuarios tienen los roles `read` y `modify` asignados.

### 6. Configuración de Mappers (opcional)
Para el cliente `backend-service`, agregar mapper:
```
Name: audience
Mapper Type: Audience
Included Client Audience: backend-service
```

## Verificación de configuración

### 1. Verificar que Keycloak esté corriendo:
```bash
curl http://localhost:8888/realms/quarkus
```

### 2. Verificar endpoint de salud:
```bash
curl http://localhost:8082/speakers/health
```

### 3. Verificar autenticación:
```bash
# Obtener token
curl -X POST http://localhost:8888/realms/quarkus/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password" \
  -d "client_id=frontend-service" \
  -d "username=user" \
  -d "password=redhat"

# Usar token para acceder al API
curl -H "Authorization: Bearer <TOKEN>" http://localhost:8082/speakers
```

## Troubleshooting

### Error 401 - Posibles causas:
1. **Token expirado**: Verificar que el token no haya expirado
2. **Roles faltantes**: Verificar que el usuario tenga los roles `read` y `modify`
3. **Cliente mal configurado**: Verificar que el cliente `backend-service` esté configurado como confidential
4. **CORS**: Verificar que los orígenes estén correctamente configurados
5. **Secret incorrecto**: Verificar que el secret del cliente coincida con el configurado en `application.properties`

### Error PKCE - "Missing parameter: code_challenge_method":
1. **Opción A (Recomendada)**: Configurar PKCE en el frontend con `pkceMethod: "S256"`
2. **Opción B**: Deshabilitar PKCE en Keycloak cambiando "PKCE Code Challenge Method" a "Not specified"

### Logs útiles:
- Revisar logs de Quarkus para errores de autenticación
- Revisar logs del navegador para errores de CORS
- Verificar que el token se esté enviando correctamente en las requests
