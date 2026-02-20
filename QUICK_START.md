# ⚡ Quick Start - Sierra Nevada Dashboard

## 🎯 Opción 1: Correr Localmente (5 minutos)

```bash
cd /home/alvaro/.openclaw/workspace/sierra-nevada-dashboard

# Instalar y ejecutar
npm install
npm start

# Abrir navegador
open http://localhost:3000
```

✅ ¡Dashboard activo!

---

## 🚀 Opción 2: Deployan en Railway (10 minutos)

### Paso 1: Crear repo en GitHub
```bash
# Ir a https://github.com/new
# Nombre: sierra-nevada-dashboard
# Crear
```

### Paso 2: Subir código
```bash
cd /home/alvaro/.openclaw/workspace/sierra-nevada-dashboard

git remote add origin https://github.com/TU_USUARIO/sierra-nevada-dashboard.git
git branch -M main
git push -u origin main
```

### Paso 3: Conectar Railway
1. Ir a https://railway.app
2. Sign in con GitHub
3. New Project
4. Deploy from GitHub repo
5. Seleccionar: sierra-nevada-dashboard
6. ¡Esperar 2-3 minutos! 🎉

### Paso 4 (Opcional): Dominio personalizado
```
properties.anayalvaro.com

1. En Railway: Settings → Networking → Custom Domain
2. O en tu registrador DNS:
   - Crear CNAME: properties → <railway-url>
   - Esperar 10-30 minutos para propagación
```

---

## 📊 Verificar que funciona

```bash
# Local
curl http://localhost:3000/api/properties | jq '.total'
# Output: 41

# Production (después de deployan)
curl https://properties.anayalvaro.com/api/properties | jq '.total'
# Output: 41
```

---

## 🎨 Características clave

| Feature | Disponible |
|---------|-----------|
| Dashboard visual | ✅ |
| 41 propiedades | ✅ |
| Filtros (precio, score, zona) | ✅ |
| Scoring automático (1-10) | ✅ |
| Enlaces a Pisos.com | ✅ |
| Mobile responsive | ✅ |

---

## 📱 URLs después de deployment

- **Local**: `http://localhost:3000`
- **Railway**: `https://xxxx.up.railway.app` (auto-generada)
- **Custom**: `https://properties.anayalvaro.com` (después de DNS)
- **API**: `/api/properties` (JSON de propiedades)

---

## ❓ Problemas comunes

### Puerto 3000 en uso
```bash
lsof -i :3000
kill -9 <PID>
```

### Git authentication failed
```bash
# SSH
git remote set-url origin git@github.com:TU_USUARIO/sierra-nevada-dashboard.git

# O HTTPS (requiere token)
git config credential.helper store
git push
```

### Properties no se cargan
Verificar: `/home/alvaro/.openclaw/workspace/sierra-nevada-monitor/data/properties.json` existe

---

## 📚 Documentación adicional

- **Detailed**: `DEPLOYMENT.md`
- **Setup**: `SETUP_INSTRUCTIONS.md`
- **Full**: `README.md`

---

## ✨ ¡Ya está!

Dashboard completamente funcional y listo para usar.

```
┌─────────────────────────────┐
│ 🏔️  Sierra Nevada Properties │
│ 📊  41 propiedades únicas   │
│ 🎯  Filtros avanzados       │
│ ⭐  Scoring inteligente     │
│ ✅  100% Listo             │
└─────────────────────────────┘
```

¿Preguntas? Ver documentación en el proyecto.
