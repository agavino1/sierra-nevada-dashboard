# 🚀 Deployment Manual - Sierra Nevada Dashboard

El código está listo para deployment en Railway. Sigue estos pasos:

## Paso 1: Crear Repository en GitHub

### Opción A: Usando GitHub CLI (recomendado)

```bash
cd /home/alvaro/.openclaw/workspace/sierra-nevada-dashboard

# Login a GitHub (si no estás autenticado)
gh auth login

# Crear el repositorio público
gh repo create sierra-nevada-dashboard --public --source=. --remote=origin --push
```

### Opción B: Manualmente en GitHub.com

1. Ve a https://github.com/new
2. Crea un nuevo repositorio:
   - **Owner:** agavino1 (tu cuenta)
   - **Repository name:** sierra-nevada-dashboard
   - **Description:** Dashboard para apartamentos en Sierra Nevada
   - **Visibility:** Public
   - **Initialize repository:** No (deja vacío)
3. Click en "Create repository"

### Opción C: Usando SSH (si GitHub CLI no funciona)

```bash
cd /home/alvaro/.openclaw/workspace/sierra-nevada-dashboard

# Configurar remota (ya debería estar lista)
git remote add origin git@github.com:agavino1/sierra-nevada-dashboard.git

# Cambiar a rama main y hacer push
git branch -M main
git push -u origin main
```

## Paso 2: Deploy a Railway

### Opción A: Usando Railway CLI + GitHub Integration

```bash
# Login a Railway (abrirá navegador)
railway login

# Inicializar proyecto Railway
railway init --name sierra-nevada-dashboard

# Hacer deploy
railway up
```

### Opción B: UI de Railway (más fácil si tienes dudas)

1. Ve a https://railway.app
2. Sign in con GitHub (recomendado)
3. Click en "New Project"
4. Selecciona "Deploy from GitHub repo"
5. Busca "sierra-nevada-dashboard"
6. Railway detectará automáticamente:
   - ✅ Node.js
   - ✅ Port 3000
   - ✅ Procfile
   - ✅ railway.json config

7. Click en "Deploy"
8. Espera 2-5 minutos mientras se construye y despliega

## Paso 3: Verificar el Deployment

Una vez que Railway indica que está "Running" (verde):

```bash
# Obtener la URL de tu deployment
railway domain

# O acceder al dashboard de Railway:
# https://railway.app → Tu proyecto → Ver URL
```

La URL será algo como: `https://sierra-nevada-dashboard-prod.up.railway.app`

## Paso 4: Verificar que funciona

1. Abre la URL en el navegador
2. Verifica que:
   - ✅ Cargan los apartamentos
   - ✅ Los filtros funcionan
   - ✅ Los enlaces a Pisos.com son válidos

## Paso 5: (Opcional) Mapear Dominio Custom

Si quieres usar `properties.anayalvaro.com`:

1. En Railway Dashboard → Tu Proyecto → Settings → Networking
2. Click en "Add custom domain"
3. Ingresar: `properties.anayalvaro.com`
4. Railway te dará un CNAME
5. En tu registrador DNS (GoDaddy, Namecheap, etc.):
   - Crear registro CNAME: `properties` → `[railway-cname]`
   - Puede tardar 24-48h en propagar

## Troubleshooting

### "Cannot find module 'express'"
```bash
npm install
npm start
```

### Properties no se cargan
El archivo `data/properties.json` ya está incluido. Si falla:
- Verificar que el archivo existe: `ls -lh data/properties.json`
- Verificar logs en Railway dashboard

### Port ya en uso
```bash
lsof -i :3000
kill -9 <PID>
npm start
```

### Dominio no resuelve
- Verifica que el CNAME está correcto en tu registrador DNS
- Espera 24-48h para que se propague
- Usa la URL de Railway directamente mientras esperas

## URLs Finales

Una vez desplegado:

- **Dashboard Live:** https://sierra-nevada-dashboard-prod.up.railway.app (o tu URL)
- **GitHub Repo:** https://github.com/agavino1/sierra-nevada-dashboard
- **Railway Dashboard:** https://railway.app
- **API Endpoint:** https://[tu-url]/api/properties (JSON con datos)

## Preguntas Frecuentes

**P: ¿Se actualizará automáticamente cuando hago push a GitHub?**
A: Sí, si usas GitHub Integration en Railway. Cualquier push a `main` deployará automáticamente.

**P: ¿Dónde veo los logs?**
A: En Railway Dashboard → Tu Proyecto → Logs

**P: ¿Puedo usar una base de datos?**
A: Los datos están en `data/properties.json` por ahora. Para actualizar, actualiza el archivo y haz push.

**P: ¿Cómo actualizo los datos de propiedades?**
A: El monitor en sierra-nevada-monitor actualiza `properties.json`. Los cambios se syncan cuando haces push a GitHub.

---

**Necesitas ayuda?**
- Railway docs: https://docs.railway.app
- GitHub docs: https://docs.github.com
- Telegram: Envía un mensaje si algo falla
