#!/bin/bash

# 🚀 Sierra Nevada Dashboard - Automated Deployment
# Este script ejecuta un deployment automático completo a Railway

set -e

REPO_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITHUB_USER="agavino1"
REPO_NAME="sierra-nevada-dashboard"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  🚀 Sierra Nevada Dashboard - Railway Deploy               ║"
echo "║  v1.0 - Automated Deployment                              ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Step 1: GitHub Authentication & Repo Creation
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 STEP 1: GitHub Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Verificar si gh está autenticado
if ! gh auth status &>/dev/null; then
    echo "🔐 GitHub authentication required"
    echo ""
    echo "Iniciando GitHub login..."
    gh auth login --scopes repo,admin:public_key
    echo ""
fi

echo "✅ GitHub authenticated"
echo ""

# Crear o usar repositorio existente
if gh repo view "$GITHUB_USER/$REPO_NAME" &>/dev/null; then
    echo "✅ Repository already exists: https://github.com/$GITHUB_USER/$REPO_NAME"
    
    # Actualizar remota
    cd "$REPO_PATH"
    if git remote | grep -q origin; then
        git remote set-url origin "git@github.com:$GITHUB_USER/$REPO_NAME.git" 2>/dev/null || true
    else
        git remote add origin "git@github.com:$GITHUB_USER/$REPO_NAME.git"
    fi
else
    echo "Creating GitHub repository: $REPO_NAME..."
    cd "$REPO_PATH"
    gh repo create "$REPO_NAME" \
        --public \
        --source="." \
        --remote=origin \
        --push
    echo "✅ Repository created and code pushed"
fi

# Ensure we're on main branch
cd "$REPO_PATH"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$CURRENT_BRANCH" == "master" ]]; then
    git branch -M main
    git push -u origin main -f 2>/dev/null || true
fi

# Push any pending changes
git push origin main 2>/dev/null || echo "No pending changes to push"

echo ""
echo "📍 GitHub Repository: https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""

# Step 2: Railway Authentication
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 STEP 2: Railway Authentication"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Verificar si está autenticado en Railway
if ! railway project list &>/dev/null; then
    echo "🔐 Railway authentication required"
    echo ""
    echo "Iniciando Railway login..."
    echo "(Se abrirá un navegador)"
    echo ""
    railway login
    echo ""
fi

echo "✅ Railway authenticated"
echo ""

# Step 3: Railway Deployment
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 STEP 3: Deployment to Railway"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd "$REPO_PATH"

# Check if project exists in Railway
if railway project list 2>/dev/null | grep -q "$REPO_NAME"; then
    echo "✅ Using existing Railway project: $REPO_NAME"
    railway project switch --name "$REPO_NAME"
else
    echo "Creating new Railway project: $REPO_NAME..."
    railway project create --name "$REPO_NAME"
    echo "✅ Project created"
fi

echo ""
echo "🚀 Starting deployment..."
echo "(This will take 2-5 minutes. You can monitor progress in https://railway.app)"
echo ""

# Inicializar railway si es necesario
if [[ ! -f ".railway" ]]; then
    railway init --name "$REPO_NAME" 2>/dev/null || true
fi

# Deploy
railway up

echo ""
echo "⏳ Waiting for deployment to be ready..."
sleep 15

# Get domain
RAILWAY_DOMAIN=$(railway domain 2>/dev/null || echo "")

if [[ -z "$RAILWAY_DOMAIN" ]]; then
    RAILWAY_DOMAIN="Check your Railway dashboard for the URL"
fi

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  ✅ DEPLOYMENT SUCCESSFUL!                                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📍 GitHub Repository:"
echo "   https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
echo "🌐 Dashboard URL:"
echo "   $RAILWAY_DOMAIN"
echo ""
echo "📊 Railway Dashboard:"
echo "   https://railway.app"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Next Steps:"
echo ""
echo "1. ✅ Verify the dashboard loads:"
echo "     Open: $RAILWAY_DOMAIN"
echo ""
echo "2. (Optional) Configure custom domain:"
echo "     In Railway Dashboard:"
echo "     Settings → Networking → Add Domain"
echo "     Domain: properties.anayalvaro.com"
echo ""
echo "3. Monitor logs in Railway:"
echo "     https://railway.app → Your Project → Logs"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✨ Done!"
echo ""
