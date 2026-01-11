#!/bin/bash

# Pfade definieren
SOURCE_SCRIPT="$(pwd)/synapse-shell.sh"
TARGET_BINARY="/usr/local/bin/synapse-shell"

echo "--- Synapse-Shell Installer ---"

# Prüfen ob die Quelldatei existiert
if [ ! -f "$SOURCE_SCRIPT" ]; then
    echo "Fehler: synapse-shell.sh nicht im aktuellen Verzeichnis gefunden!"
    exit 1
fi

# Ausführbar machen
chmod +x "$SOURCE_SCRIPT"

# Symlink im System erstellen
echo "Erstelle System-Link in $TARGET_BINARY..."
ln -sf "$SOURCE_SCRIPT" "$TARGET_BINARY"

# Alias für die aktuelle Sitzung und dauerhaft in .bashrc setzen
if ! grep -q "alias s='synapse-shell'" ~/.bashrc; then
    echo "Setze Alias 's' in ~/.bashrc..."
    echo "alias s='synapse-shell'" >> ~/.bashrc
fi

echo "Fertig! Du kannst jetzt 'synapse-shell' oder einfach nur 's' nutzen."
echo "Hinweis: Gib 'source ~/.bashrc' ein, um den Kurz-Befehl 's' sofort zu aktivieren."
