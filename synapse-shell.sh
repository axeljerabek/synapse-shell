#!/bin/bash

# --- DEFAULTS ---
CONFIG_FILE="$HOME/.synapse-shell.conf"
CONTAINER_NAME="ollama"
DEFAULT_MODEL="gemma3:4b"

# Lade Konfiguration falls vorhanden
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# Falls in der Config nichts steht, nimm Default
MODEL="${MODEL:-$DEFAULT_MODEL}"

show_help() {
    echo -e "\033[1;36m"
    echo "  ___ _   _ _ __   __ _ _ __  ___  ___ "
    echo " / __| | | | '_ \ / _\` | '_ \/ __|/ _ \\"
    echo " \__ \ |_| | | | | (_| | |_) \__ \  __/"
    echo " |___/\__, |_| |_|\__,_| .__/|___/\___|"
    echo "      |___/            |_|  SHELL v1.1"
    echo -e "\033[0m"
    echo "=============================================================="
    echo "USAGE:"
    echo "  synapse-shell [OPTIONS] \"Your question\""
    echo ""
    echo "OPTIONS:"
    echo "  -m, --model <name>   Nutze ein anderes Modell (z.B. llama3)"
    echo "  --config             Erstelle/Bearbeite die Config-Datei"
    echo "  --help               Zeige diese Hilfe"
    echo ""
    echo "AKTUELL EINGESTELLT:"
    echo "  Modell: $MODEL"
    echo "=============================================================="
    exit 0
}

# Parameter Parsing
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -m|--model) MODEL="$2"; shift ;;
        --config) 
            echo "MODEL=\"$MODEL\"" > "$CONFIG_FILE"
            echo "Konfiguration unter $CONFIG_FILE gespeichert."
            exit 0 ;;
        --help) show_help ;;
        *) break ;;
    esac
    shift
done

# 2. Capture stdin (Pipes)
if [ ! -t 0 ]; then
    STDIN_DATA=$(cat)
fi

QUERY="$*"

if [ -z "$QUERY" ] && [ -z "$STDIN_DATA" ]; then
    show_help
fi

# 3. Prompt bauen
if [ -n "$STDIN_DATA" ]; then
    FINAL_PROMPT="CONTEXT:\n$STDIN_DATA\n\nQUERY: $QUERY"
else
    FINAL_PROMPT="$QUERY"
fi

# 4. Ausführung
docker exec -e OLLAMA_KEEP_ALIVE=0 "$CONTAINER_NAME" ollama run "$MODEL" "$FINAL_PROMPT"
