# 🚀 Guía de Deployment

## Deployment en Railway

### Paso 1: Preparar el repositorio GitHub

```bash
# Crear repo en GitHub primero (si no existe)
# https://github.com/new

# Configurar remoto
cd /home/alvaro/.openclaw/workspace/sierra-nevada-dashboard
git remote add origin https://github.com/TU_USUARIO/sierra-nevada-dashboard.git
git branch -M main
git push -u origin main
```

### Paso 2: Conectar con Railway

1. Ir a https://railway.app
2. Sign in con GitHub
3. Click en "New Project"
4. Seleccionar "Deploy from GitHub repo"
5. Buscar y seleccionar "sierra-nevada-dashboard"
6. Railway detectará automáticamente que es Node.js

### Paso 3: Variables de entorno (Railway)

El proyecto no necesita variables especiales, pero puedes agregar:
- `NODE_ENV`: production

### Paso 4: Configurar subdominio

Una vez deployado en Railway:

1. En el dashboard de Railway, ir a tu proyecto
2. Hacer click en el servicio
3. Ir a "Settings" → "Networking"
4. Click en "Generate Domain"
5. Copiar la URL auto-generada
6. O configurar un dominio custom si tienes acceso a anayalvaro.com:
   - Ir a tu registrador DNS
   - Agregar CNAME: `properties.anayalvaro.com` → URL de Railway

### Paso 5: Verificar

- Acceder a: https://properties.anayalvaro.com (o URL de Railway)
- Verificar que los filtros funcionan
- Probar enlaces a Pisos.com

## Variables de Entorno Soportadas

```env
PORT=3000                    # Auto-configurado por Railway
NODE_ENV=production          # Modo producción
DATA_SOURCE_PATH=/path/to/data  # Ruta a properties.json (default: /home/alvaro/.openclaw/workspace/sierra-nevada-monitor/data/properties.json)
```

## Monitoreo

En Railway puedes:
- Ver logs en tiempo real
- Configurar alertas
- Ver métricas de uso

## Actualizaciones

Para actualizar el dashboard después de cambios:
```bash
git add .
git commit -m "Update: descripción de cambios"
git push origin main
```

Railway auto-redeploy cuando detecta push a main.

## Troubleshooting

### Error: "Cannot find module 'express'"
```bash
npm install
npm start
```

### Properties no se cargan
Verificar que `/home/alvaro/.openclaw/workspace/sierra-nevada-monitor/data/properties.json` existe y es accesible.

### Puerto ya en uso localmente
```bash
lsof -i :3000
kill -9 <PID>
```

## URLs importantes

- Dashboard: `https://properties.anayalvaro.com`
- Railway Dashboard: `https://railway.app`
- GitHub Repo: `https://github.com/TU_USUARIO/sierra-nevada-dashboard`
- API Properties: `https://properties.anayalvaro.com/api/properties`
