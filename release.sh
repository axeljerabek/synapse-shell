#!/bin/bash

# --- CONFIG ---
MAIN_BRANCH="main"

# Prüfen, ob eine Versionsnummer übergeben wurde
if [ -z "$1" ]; then
    echo -e "\033[0;31mUsage: ./release.sh v1.X \"Deine Nachricht\"\033[0m"
    exit 1
fi

VERSION=$1
MESSAGE=${2:-"Release $VERSION"}

echo -e "\033[1;34m--> 1. Staging all changes...\033[0m"
git add .

echo -e "\033[1;34m--> 2. Committing: $MESSAGE\033[0m"
git commit -m "$MESSAGE"

echo -e "\033[1;34m--> 3. Pushing to $MAIN_BRANCH...\033[0m"
git push origin "$MAIN_BRANCH"

echo -e "\033[1;34m--> 4. Handling Tags ($VERSION)...\033[0m"
# Lokalen Tag löschen falls vorhanden
git tag -d "$VERSION" 2>/dev/null
# Remote Tag löschen (um ihn zu aktualisieren)
git push origin :refs/tags/"$VERSION" 2>/dev/null

# Neuen Tag setzen und pushen
git tag "$VERSION"
git push origin "$VERSION"

echo -e "\n\033[1;32m✅ Release $VERSION erfolgreich auf GitHub veröffentlicht!\033[0m"
