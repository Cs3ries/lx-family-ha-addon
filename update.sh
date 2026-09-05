#!/usr/bin/env bash
set -euo pipefail

# Skript zum manuellen Prüfen und Aktualisieren auf das neueste Original-Release
echo "========================================================"
echo " Prüfe auf neue Releases von laxxx-lab/lx-family-planner"
echo "========================================================"

LATEST_VERSION=""

# 1. Versuch: GitHub API
LATEST_JSON=$(curl -sL --max-time 5 -H "User-Agent: HA-Addon-Updater" https://api.github.com/repos/laxxx-lab/lx-family-planner/releases/latest 2>/dev/null || true)
LATEST_TAG=$(echo "$LATEST_JSON" | grep -m1 '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' || true)
RELEASE_BODY=""
if [ -n "$LATEST_TAG" ]; then
  LATEST_VERSION="${LATEST_TAG#v}"
  if command -v jq >/dev/null 2>&1; then
    RELEASE_BODY=$(echo "$LATEST_JSON" | jq -r '.body // empty' 2>/dev/null || true)
  fi
fi

# 2. Fallback: package.json aus dem main-Branch
if [ -z "$LATEST_VERSION" ]; then
  PKG_JSON=$(curl -sL --max-time 5 https://raw.githubusercontent.com/laxxx-lab/lx-family-planner/main/package.json 2>/dev/null || true)
  LATEST_VERSION=$(echo "$PKG_JSON" | grep -m1 '"version":' | sed -E 's/.*"version":[[:space:]]*"([^"]+)".*/\1/' || true)
fi

if [ -z "$LATEST_VERSION" ]; then
  echo "Fehler: Konnte die neueste Version von GitHub nicht abrufen." >&2
  exit 1
fi

CURRENT_VERSION=$(grep '^version:' lx-family/config.yaml | awk '{print $2}' | tr -d '"')

echo "Installierte Add-on Version: ${CURRENT_VERSION}"
echo "Neueste Original-Version:    ${LATEST_VERSION}"
echo ""

if [ "$LATEST_VERSION" = "$CURRENT_VERSION" ]; then
  echo "✅ Das Add-on ist bereits auf dem aktuellsten Stand (${CURRENT_VERSION})."
  exit 0
fi

echo "🚀 Aktualisiere Add-on auf Version ${LATEST_VERSION}..."

# Update config.yaml und build.yaml
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' -E "s/^version:.*/version: \"${LATEST_VERSION}\"/" lx-family/config.yaml
  sed -i '' -E "s|ghcr.io/laxxx-lab/lx-family-planner:[^\"']+|ghcr.io/laxxx-lab/lx-family-planner:${LATEST_VERSION}|g" lx-family/build.yaml
else
  sed -i -E "s/^version:.*/version: \"${LATEST_VERSION}\"/" lx-family/config.yaml
  sed -i -E "s|ghcr.io/laxxx-lab/lx-family-planner:[^\"']+|ghcr.io/laxxx-lab/lx-family-planner:${LATEST_VERSION}|g" lx-family/build.yaml
fi

# Update CHANGELOG.md
DATE=$(date +'%Y-%m-%d')
TEMP_FILE=$(mktemp)
{
  echo "# Changelog"
  echo ""
  echo "## ${LATEST_VERSION} (${DATE})"
  echo ""
  if [ -n "$RELEASE_BODY" ] && [ "$RELEASE_BODY" != "null" ]; then
    echo "### Neuheiten im Original-Release (laxxx-lab/lx-family-planner):"
    echo "$RELEASE_BODY" | sed -E '/^#[[:space:]]+.*(1\.[0-9]+|LX Family).*/d; s/^##[[:space:]]+/#### /'
    echo ""
    echo "### Add-on Änderungen:"
  fi
  echo "- Aktualisiert auf LX Family ${LATEST_VERSION} aus dem Original-Repository (laxxx-lab/lx-family-planner)."
  echo "- Ingress-Proxy Schicht (Nginx) und Pfad-Rewriting aktiv."
  echo ""
  sed '/^# Changelog/d' lx-family/CHANGELOG.md
} > "$TEMP_FILE"
mv "$TEMP_FILE" lx-family/CHANGELOG.md

echo "✅ Add-on Dateien erfolgreich auf ${LATEST_VERSION} aktualisiert!"
echo ""
echo "Nächste Schritte:"
echo "1. Git-Commit erstellen:"
echo "   git add lx-family/config.yaml lx-family/build.yaml lx-family/CHANGELOG.md"
echo "   git commit -m \"chore(release): update LX Family to ${LATEST_VERSION} (ingress-ready)\""
echo "   git push"
echo "2. Im Home Assistant Add-on Store nach Aktualisierungen suchen."
