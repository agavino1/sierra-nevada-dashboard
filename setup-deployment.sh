#!/bin/bash

echo "🚀 Sierra Nevada Dashboard - Setup de Deployment"
echo "==============================================="
echo ""

# Verificar que tenemos git
if ! command -v git &> /dev/null; then
    echo "❌ Git no está instalado"
    exit 1
fi

# Verificar que tenemos node
if ! command -v node &> /dev/null; then
    echo "❌ Node.js no está instalado"
    exit 1
fi

echo "✅ Git y Node.js detectados"
echo ""

# Preguntar por usuario de GitHub
echo "Para crear el repositorio en GitHub, necesitamos:"
read -p "👤 Usuario de GitHub: " github_user
read -p "🔑 Token de GitHub (o presiona Enter para configurar manualmente): " github_token

if [ -z "$github_user" ]; then
    echo "❌ Usuario de GitHub es requerido"
    exit 1
fi

# Configurar git remote
REPO_URL="https://github.com/${github_user}/sierra-nevada-dashboard.git"

echo ""
echo "📝 Configurando repositorio remoto..."
git remote add origin "$REPO_URL" 2>/dev/null || git remote set-url origin "$REPO_URL"

# Renombrar a main si es necesario
echo "🔄 Asegurando rama principal como 'main'..."
git branch -M main 2>/dev/null || true

# Instalar dependencias
echo ""
echo "📦 Instalando dependencias..."
npm install

# Commit
echo ""
echo "💾 Haciendo commit inicial..."
git add -A
git commit -m "Initial commit: Sierra Nevada Properties Dashboard" --allow-empty

# Push
echo ""
echo "📤 Subiendo a GitHub..."
if [ -z "$github_token" ]; then
    echo "⚠️  Configurar autenticación SSH o HTTPS en Git"
    echo "   Para HTTPS: git config credential.helper store"
    echo "   Luego: git push -u origin main"
else
    git push -u origin main
fi

echo ""
echo "✅ Setup completado!"
echo ""
echo "Próximos pasos:"
echo "1. Ir a https://railway.app"
echo "2. Conectar con GitHub"
echo "3. Seleccionar el repositorio 'sierra-nevada-dashboard'"
echo "4. Railway auto-detectará Node.js y deployará"
echo "5. Configurar dominio: properties.anayalvaro.com"
echo ""
echo "Para más detalles, ver DEPLOYMENT.md"
