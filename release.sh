#!/bin/bash

# Salir inmediatamente si algún comando falla
set -e

# 1. Verificar que estamos en la rama correcta (por defecto "main")
BRANCH_ACTUAL=$(git rev-parse --abbrev-ref HEAD)
if [[ "$BRANCH_ACTUAL" != "main" ]]; then
  echo "⚠️ Este script debe ejecutarse en la rama 'main'. Rama actual: $BRANCH_ACTUAL"
  exit 1
fi

# 2. Asegurar que el repositorio está limpio
if [[ -n $(git status --porcelain) ]]; then
  echo "⚠️ Hay cambios sin confirmar en el repositorio. Confirma o descarta los cambios antes de continuar."
  exit 1
fi

# 3. Verificar que los commits cumplen con el formato de Conventional Commits
echo "✅ Verificando el historial de commits..."
cog check --from-latest-tag

# 4. Realizar bump automático de versión con Cocogitto
echo "🚀 Realizando bump de versión automáticamente..."
cog bump --auto

# 5. Obtener la nueva versión (el bump ya creó el commit y la etiqueta)
VERSION=$(cog -v get-version)
echo "🔖 Nueva versión detectada: $VERSION"

# 6. Subir cambios y etiquetas a GitHub
echo "📤 Subiendo cambios y etiquetas a GitHub..."
git push origin main --follow-tags

# 7. Crear un release en GitHub usando el CHANGELOG.md generado por Cocogitto
echo "📦 Creando release en GitHub..."
gh release create "v$VERSION" --title "Lanzamiento $VERSION" --notes-file CHANGELOG.md

echo "🎉 ¡Lanzamiento completado con éxito!"
