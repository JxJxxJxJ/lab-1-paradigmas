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

# 4. Generar el changelog (Cocogitto actualiza el CHANGELOG.md en el bump)
echo "📜 Generando changelog..."
cog changelog > CHANGELOG.md
git add CHANGELOG.md

# 5. Realizar bump automático de versión (esto crea commit y tag si corresponde)
echo "🚀 Realizando bump de versión automáticamente..."
cog bump --auto

# 6. Obtener la nueva versión (el bump ya creó el commit y la etiqueta)
VERSION=$(cog -v get-version)
echo "🔖 Nueva versión detectada: $VERSION"

# 7. Subir cambios y etiquetas a GitHub
echo "📤 Subiendo cambios y etiquetas a GitHub..."
git push origin main --follow-tags

# 8. Crear o actualizar un release en GitHub usando el changelog
TAG="v$VERSION"
echo "📦 Procesando release en GitHub para el tag $TAG..."
if gh release view "$TAG" >/dev/null 2>&1; then
  echo "⚠️ El release $TAG ya existe, se actualizará..."
  gh release edit "$TAG" --notes-file CHANGELOG.md --title "Lanzamiento $VERSION"
else
  gh release create "$TAG" --title "Lanzamiento $VERSION" --notes-file CHANGELOG.md
fi

echo "🎉 ¡Lanzamiento completado con éxito!"

