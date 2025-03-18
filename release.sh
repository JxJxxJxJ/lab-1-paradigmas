#!/bin/bash

# Salir inmediatamente si un comando falla
set -e

# 1. Verificar que estamos en la rama correcta (por defecto 'main')
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

# 4. Generar el changelog desde el último tag
echo "📜 Generando changelog..."
cog changelog > CHANGELOG.md

# 5. Incrementar versión automáticamente según los commits
echo "🚀 Realizando bump de versión..."
cog bump --auto

# 6. Obtener la nueva versión
VERSION=$(cog -v get-version)
echo "🔖 Nueva versión detectada: $VERSION"

# 7. Crear un commit con el changelog actualizado
echo "📌 Creando commit con la nueva versión..."
git add CHANGELOG.md
git commit -m "chore(release): versión $VERSION"

# 8. Crear una etiqueta (tag) con la nueva versión
echo "🏷️ Creando tag v$VERSION..."
git tag "v$VERSION"

# 9. Subir cambios y etiquetas a GitHub
echo "📤 Subiendo cambios y tags a GitHub..."
git push origin main --follow-tags

# 10. Crear un release en GitHub con el changelog como descripción
echo "📦 Creando release en GitHub..."
gh release create "v$VERSION" --title "Lanzamiento $VERSION" --notes-file CHANGELOG.md

echo "🎉 ¡Lanzamiento completado con éxito!"

