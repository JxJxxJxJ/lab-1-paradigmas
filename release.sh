#!/bin/bash

# Me detengo si cualquier comando retorna error (rc != 0)
set -e

# 1. Verificar que estoy en RAMA_DESEADA (la rama que quiero hacer release)
BRANCH_ACTUAL="$(git rev-parse --abbrev-ref HEAD)"
BRANCH_DESEADA="main" # Por defecto main
if [[ $BRANCH_ACTUAL != $BRANCH_DESEADA ]]; then
  echo "⚠️ Este script debe ejecutarse en la rama $BRANCH_DESEADA. Rama actual: $BRANCH_ACTUAL"
  exit 1
fi

# 2. Veo si hay cambios en el repositorio sin commitear
# -n "String" == True si la cadena es no-vacia
if [[ -n "$(git status --porcelain)" ]]; then
  echo "⚠️ Hay cambios sin confirmar en el repositorio. Haz commit o descarta los cambios antes de continuar."
  exit 1
fi

# 3. Verificar que los commits cumplen con el formato de Conventional Commits
# Se ejecuta cog check --from-latest-tag para asegurarse de que los commits 
# desde el último tag cumplen con las reglas de Conventional Commits.
# Si siempre se usaron convcommits entonces es innecesario.
echo "✅ Verificando el historial de commits..."
if cog check --from-latest-tag; then # == 0 on success 
  echo "✔️ Historial de commits verificado con éxito."
else # Hay commits no convencionales
  echo "❌ Hay commits no convencionales."
  exit 1
fi

# 4. Realizar el bump automático de versión con Cocogitto
#    Esto actualizará el CHANGELOG.md y creara el commit de versión + el tag.
echo "🚀 Ejecutando bump automático..."
cog bump --auto

# 5. Obtener la nueva versión generada (ya se crearon el commit y el tag)
VERSION=$(cog -v get-version) # Guarda la version x.y.z despues del bump 
echo "🔖 Version actualizada: $VERSION"

# 6. Subir los cambios y tags a GitHub
echo "📤 Subiendo cambios y tags a GitHub... (O al que sea)"
git push origin main --follow-tags

# 7. Crear o actualizar un release en GitHub utilizando el CHANGELOG.md generado
TAG="v$VERSION"
echo "📦 Procesando release en GitHub para el tag $TAG..."
if gh release view "$TAG" >/dev/null 2>&1; then
  echo "⚠️ El release $TAG ya existe, se actualizará..."
  gh release edit "$TAG" --notes-file CHANGELOG.md --title "$VERSION"
else
  gh release create "$TAG" --title "$VERSION" --notes-file CHANGELOG.md
fi

echo "🎉 ¡Lanzamiento completado con éxito!"
