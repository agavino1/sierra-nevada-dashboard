# 📋 Instrucciones de Setup e Instalación

## Estructura del Proyecto

```
sierra-nevada-dashboard/
├── server.js                 # Servidor Express principal
├── views/
│   └── index.ejs            # Template del dashboard
├── package.json             # Dependencias Node.js
├── .env.example             # Variables de entorno (ejemplo)
├── Procfile                 # Configuración para Heroku/Railway
├── DEPLOYMENT.md            # Guía de deployment
├── SETUP_INSTRUCTIONS.md    # Este archivo
└── README.md                # Documentación general
```

## Instalación Local

### Requisitos
- Node.js 18+ (o superior)
- npm

### Pasos

1. **Clonar/Descargar el proyecto**
```bash
cd sierra-nevada-dashboard
```

2. **Instalar dependencias**
```bash
npm install
```

3. **Crear archivo .env (opcional)**
```bash
cp .env.example .env
# Editar .env con tus valores si es necesario
```

4. **Iniciar la aplicación**
```bash
npm start
```

5. **Acceder**
- Abrir navegador en: `http://localhost:3000`
- Debe ver el dashboard con las propiedades de Sierra Nevada

## Deployment en Railway

### Opción A: Con script automático

```bash
chmod +x setup-deployment.sh
./setup-deployment.sh
```

Luego seguir las instrucciones en Railway.

### Opción B: Manual

1. **Preparar repositorio GitHub**
```bash
git remote add origin https://github.com/TU_USUARIO/sierra-nevada-dashboard.git
git branch -M main
git push -u origin main
```

2. **Ir a Railway.app**
   - Sign in con GitHub
   - New Project → Deploy from GitHub
   - Seleccionar sierra-nevada-dashboard
   - Railway auto-detectará la configuración

3. **Configurar dominio (opcional)**
   - En Railway: Settings → Networking
   - Generar dominio o conectar dominio personalizado

## Variables de Entorno

```env
PORT=3000                    # Puerto (Railway lo asigna automáticamente)
NODE_ENV=development         # development/production
```

Si necesitas cambiar la ruta de properties.json:
```env
DATA_SOURCE_PATH=/ruta/personalizada/properties.json
```

## Testing

### Verificar instalación local

```bash
# Terminal 1: Iniciar servidor
npm start

# Terminal 2: Test API
curl http://localhost:3000/api/properties

# Debería retornar JSON con lista de propiedades
```

### Verificar en production (Railway)

```bash
curl https://properties.anayalvaro.com/api/properties
```

## Estructura de datos

El dashboard lee de:
```
/home/alvaro/.openclaw/workspace/sierra-nevada-monitor/data/properties.json
```

Formato esperado:
```json
{
  "properties": {
    "pisoscom_xxx": {
      "id": "pisoscom_xxx",
      "url": "https://...",
      "portal": "pisos.com",
      "title": "Apartamento en ...",
      "price": 250000,
      "location": "Sierra Nevada (Monachil)",
      "bedrooms": 3,
      "bathrooms": 2,
      "size_m2": 120,
      "firstSeen": "2026-02-15T...",
      "status": "active"
    }
  }
}
```

## Troubleshooting

### Error: "Cannot find properties.json"
```
Solución: Verificar que el archivo existe en:
/home/alvaro/.openclaw/workspace/sierra-nevada-monitor/data/properties.json
```

### Error: "Port already in use"
```bash
# Encontrar proceso en puerto 3000
lsof -i :3000

# Terminar proceso (example PID: 12345)
kill -9 12345
```

### npm install falla
```bash
# Limpiar cache de npm
npm cache clean --force

# Reinstalar
rm -rf node_modules package-lock.json
npm install
```

### Depuración en Railway
- Ver logs: Railway Dashboard → tu proyecto → Logs
- Ver métricas: Metrics tab
- Configurar alertas: Settings → Alerts

## Mejoras futuras

- [ ] Base de datos para guardar propiedades favoritas
- [ ] Notificaciones por email para nuevas propiedades
- [ ] Mapa interactivo con ubicaciones
- [ ] Gráficos de tendencias de precios
- [ ] Integración con más portales inmobiliarios
- [ ] Dark mode
- [ ] Exportar a CSV/PDF

## Soporte

Documentación adicional:
- Express.js: https://expressjs.com
- EJS Templates: https://ejs.co
- Railway Docs: https://docs.railway.app
- Node.js: https://nodejs.org/docs

## Notas importantes

⚠️ **Datos en vivo**: El dashboard carga propiedades actuales de `properties.json`

⚠️ **URLs de Pisos.com**: Pueden cambiar o expirar. Se recomienda verificar antes de contactar.

⚠️ **Score**: El algoritmo es una valoración objetiva. Usar como referencia, no como única decisión.

✅ **Responsive**: Funciona en desktop, tablet y móvil

✅ **Sin base de datos**: Solo lee JSON estático (fácil para testing)

## Control de versiones

```bash
# Ver historial
git log --oneline

# Hacer cambios
git add .
git commit -m "Descripción de cambios"
git push origin main

# En Railway: Auto-redeploy en push a main
```
