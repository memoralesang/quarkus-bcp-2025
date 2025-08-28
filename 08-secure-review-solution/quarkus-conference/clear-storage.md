# Solución: QuotaExceededError - Almacenamiento lleno

## Problema identificado:
```
QuotaExceededError: Failed to execute 'setItem' on 'Storage': Setting the value of 'kc-callback-abbe79f9-dce7-4582-8529-669b0c903455' exceeded the quota.
```

El navegador no puede guardar más datos en localStorage/sessionStorage porque está lleno.

## Solución paso a paso:

### Opción 1: Limpiar desde las DevTools (Recomendado)

1. **Abre las DevTools** (F12)
2. **Ve a la pestaña "Application"** (o "Aplicación")
3. **En el panel izquierdo, busca:**
   - **Local Storage** → `http://172.17.0.1:8080`
   - **Session Storage** → `http://172.17.0.1:8080`
   - **Cookies** → `http://172.17.0.1:8080`
4. **Haz clic derecho en cada uno y selecciona "Clear"** (Limpiar)
5. **Recarga la página** (F5)

### Opción 2: Limpiar todo el navegador

1. **Abre Configuración del navegador**
2. **Busca "Borrar datos de navegación"**
3. **Selecciona:**
   - ✅ Cookies y otros datos del sitio
   - ✅ Archivos en caché e imágenes
   - ✅ Datos del sitio web
4. **Haz clic en "Borrar datos"**

### Opción 3: Modo incógnito

1. **Abre una ventana incógnita/privada** (Ctrl+Shift+N)
2. **Ve a** `http://172.17.0.1:8080`
3. **Prueba la autenticación**

## Verificación:

Después de limpiar, deberías ver:
- ✅ No más errores de "QuotaExceededError"
- ✅ Keycloak puede guardar datos de callback
- ✅ El flujo de autenticación funciona correctamente

## Prevención:

Para evitar este problema en el futuro:
- Limpia regularmente el almacenamiento del navegador
- Usa modo incógnito para pruebas
- Considera implementar limpieza automática de datos antiguos

