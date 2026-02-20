#!/bin/bash

# 🚀 Sierra Nevada Dashboard - Deployment Script
# Este script automatiza el deployment a Railway y GitHub

set -e

REPO_PATH="/home/alvaro/.openclaw/workspace/sierra-nevada-dashboard"
GITHUB_USER="agavino1"
REPO_NAME="sierra-nevada-dashboard"
GITHUB_REPO="git@github.com:$GITHUB_USER/$REPO_NAME.git"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  🚀 Sierra Nevada Dashboard - Railway Deployment           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Paso 1: GitHub Setup
echo "📋 PASO 1: GitHub Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Verificar si el repo existe en GitHub
echo "Checking if GitHub repo exists..."
if gh repo view "$GITHUB_USER/$REPO_NAME" &>/dev/null; then
    echo "✅ GitHub repo already exists: https://github.com/$GITHUB_USER/$REPO_NAME"
else
    echo "Creating GitHub repo: $REPO_NAME..."
    gh repo create "$REPO_NAME" --public --source="$REPO_PATH" --remote=origin --push
    echo "✅ GitHub repo created and code pushed!"
fi

echo ""
echo "📍 GitHub Repository: https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""

# Paso 2: Verificar remota en git
echo "📋 PASO 2: Configurar remota Git"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd "$REPO_PATH"

if git remote | grep -q origin; then
    CURRENT_REMOTE=$(git remote get-url origin)
    if [[ "$CURRENT_REMOTE" == *"$GITHUB_REPO"* ]]; then
        echo "✅ Remote origin already configured correctly"
    else
        echo "Updating remote origin..."
        git remote set-url origin "$GITHUB_REPO"
        echo "✅ Remote updated"
    fi
else
    echo "Adding remote origin..."
    git remote add origin "$GITHUB_REPO"
    echo "✅ Remote added"
fi

# Cambiar a rama main si está en master
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$CURRENT_BRANCH" == "master" ]]; then
    echo "Renaming branch master → main..."
    git branch -M main
    git push -u origin main
    echo "✅ Branch renamed and pushed"
fi

echo ""
git remote -v
echo ""

# Paso 3: Railway Login y Deployment
echo "📋 PASO 3: Railway Deployment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Verificar si está autenticado en Railway
if ! railway project list &>/dev/null; then
    echo "🔐 Railway login required"
    echo "  Próximamente se abrirá un navegador para autenticarse"
    echo "  O si prefieres, puedes proporcionar tu token manualmente"
    echo ""
    read -p "¿Deseas hacer login interactivo? (s/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        railway login
    else
        read -p "Proporciona tu Railway API token: " railway_token
        export RAILWAY_TOKEN="$railway_token"
    fi
fi

echo ""
echo "Checking Railway authentication..."
if railway project list &>/dev/null; then
    echo "✅ Railway authenticated"
else
    echo "❌ Railway authentication failed"
    exit 1
fi

echo ""
echo "Creating/verifying Railway project..."

# Intenta obtener el proyecto existente o crear uno nuevo
if railway project switch --silent 2>/dev/null || true; then
    echo "✅ Using existing Railway project"
else
    echo "Creating new Railway project..."
    railway project create --name "$REPO_NAME"
    echo "✅ Railway project created"
fi

echo ""
echo "🔧 Deploying to Railway..."
echo "  This will take ~2-5 minutes..."
echo ""

# Navegar al directorio y hacer el deploy
cd "$REPO_PATH"

# Inicializar el proyecto Railway con el código local
if [[ ! -f ".railway" ]]; then
    railway init --name "$REPO_NAME" 2>/dev/null || true
fi

# Hacer deploy
railway up --detach

echo ""
echo "⏳ Waiting for deployment to complete..."
sleep 10

# Obtener la URL de Railway
RAILWAY_URL=$(railway domain 2>/dev/null || echo "https://dashboard.railway.app")

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  ✅ DEPLOYMENT COMPLETADO                                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📍 GitHub Repository:"
echo "   https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
echo "🚀 Railway Project:"
echo "   https://railway.app"
echo ""
echo "🌐 Dashboard URL:"
echo "   $RAILWAY_URL"
echo ""
echo "📊 Próximos pasos:"
echo "   1. Verifica que el dashboard carga en la URL"
echo "   2. (Opcional) Configura dominio custom: properties.anayalvaro.com"
echo "   3. Monitorea los logs en Railway dashboard"
echo ""

# Opcional: Mapear dominio
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -p "¿Deseas configurar el dominio custom? (s/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo "Para mapear properties.anayalvaro.com:"
    echo "  1. Ve a https://railway.app"
    echo "  2. Abre tu proyecto"
    echo "  3. Settings → Domains"
    echo "  4. Agregar dominio: properties.anayalvaro.com"
    echo "  5. Configurar CNAME en tu registrador DNS"
fi

echo ""
echo "✨ ¡Deployment completado!"
echo ""
