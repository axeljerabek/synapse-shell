#!/bin/bash

# --- DEFAULTS ---
CONFIG_FILE="$HOME/.synapse-shell.conf"
MEMORY_FILE="/tmp/synapse-shell-memory.tmp"
CONTAINER_NAME="ollama"
DEFAULT_MODEL="gemma3:4b"

# Lade Konfiguration
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"
MODEL="${MODEL:-$DEFAULT_MODEL}"

show_help() {
    echo -e "\033[1;36m"
    echo "  ___ _   _ _ __   __ _ _ __  ___  ___ "
    echo " / __| | | | '_ \ / _\` | '_ \/ __|/ _ \\"
    echo " \__ \ |_| | | | | (_| | |_) \__ \  __/"
    echo " |___/\__, |_| |_|\__,_| .__/|___/\___|"
    echo "      |___/            |_|   SHELL v1.9"
    echo -e "\033[0m"
    echo "=============================================================="
    echo "USAGE: ai [OPTIONS] \"Frage\" oder @datei"
    echo ""
    echo "FEATURES:"
    echo "  @datei              Inhalt einer Datei einlesen"
    echo "  --sys               System-Kontext hinzufügen"
    echo "  --fix \"cmd\"         Befehl analysieren & korrigieren"
    echo "  --copy              Extrahiert Code in die Zwischenablage"
    echo ""
    echo "STEUERUNG:"
    echo "  --new               Gedächtnis löschen"
    echo "  --flush             Docker-Container & VRAM Reset"
    echo "  --config            Aktuelles Modell dauerhaft speichern"
    echo "=============================================================="
    exit 0
}

# --- ROBUSTNESS CHECKS (v1.9 Upgrade) ---
if ! command -v docker >/dev/null; then
    echo -e "\033[0;31mError: Docker ist nicht installiert.\033[0m"
    exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
    echo -e "\033[0;33mWarning: Container '$CONTAINER_NAME' läuft nicht.\033[0m"
    echo -e "Starte Container..."
    docker start "$CONTAINER_NAME" >/dev/null 2>&1 || { echo "Fehler: Start fehlgeschlagen."; exit 1; }
fi

# Hilfsfunktionen
get_sys_info() {
    echo -e "\n[SYSTEM INFO]\nOS: $(uname -srm), Path: $(pwd), User: $(whoami)"
}

# Parameter Parsing
SYS_INFO=""
COPY_TO_CLIPBOARD=false
FIX_MODE_CMD=""
REMAINING_ARGS=()

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -m|--model) MODEL="$2"; shift ;;
        --new) rm -f "$MEMORY_FILE"; echo "Memory gelöscht."; exit 0 ;;
        --flush) docker restart "$CONTAINER_NAME" > /dev/null; echo "VRAM geflasht."; exit 0 ;;
        --config) echo "MODEL=\"$MODEL\"" > "$CONFIG_FILE"; echo "Config gespeichert."; exit 0 ;;
        --sys) SYS_INFO=$(get_sys_info) ;;
        --copy) COPY_TO_CLIPBOARD=true ;;
        --fix)
            if [[ -n "$2" && "$2" != --* ]]; then
                FIX_MODE_CMD="$2"; shift
            else
                FIX_MODE_CMD=$(tail -n 20 "$HOME/.bash_history" 2>/dev/null | grep -vE "^(ai|s |exit|#|--)" | tail -n 1)
            fi ;;
        --help) show_help ;;
        *) REMAINING_ARGS+=("$1") ;;
    esac
    shift
done

# Datei-Erkennung (@file)
FILE_CONTENT=""
FINAL_QUERY_ARGS=()
for arg in "${REMAINING_ARGS[@]}"; do
    if [[ $arg == @* ]]; then
        FILE_PATH="${arg#@}"
        [ -f "$FILE_PATH" ] && FILE_CONTENT="$FILE_CONTENT\n--- FILE: $FILE_PATH ---\n$(cat "$FILE_PATH")\n" || echo -e "\033[0;31mDatei $FILE_PATH fehlt.\033[0m"
    else
        FINAL_QUERY_ARGS+=("$arg")
    fi
done

# Input Capture
STDIN_DATA=""
[ ! -t 0 ] && STDIN_DATA=$(cat)
QUERY="${FINAL_QUERY_ARGS[*]}"

[ -z "$QUERY" ] && [ -z "$STDIN_DATA" ] && [ -z "$FIX_MODE_CMD" ] && [ -z "$FILE_CONTENT" ] && show_help

# Memory laden
HISTORY=""
[ -f "$MEMORY_FILE" ] && HISTORY=$(cat "$MEMORY_FILE")

# Prompt Strategie
if [ -n "$FIX_MODE_CMD" ]; then
    FINAL_PROMPT="ANALYSYERE NUR DIESEN BEFEHL: '$FIX_MODE_CMD'. Erkläre kurz den Tippfehler und gib NUR den korrekten Befehl als Code-Block aus."
else
    FINAL_PROMPT="[CONTEXT]$SYS_INFO\n$FILE_CONTENT\n\n[HISTORY]\n$HISTORY\n\n[USER]: $STDIN_DATA $QUERY"
fi

# Ausführung
echo -e "\033[1;30m-- Synapse is thinking... --\033[0m"
RESPONSE=$(docker exec -e OLLAMA_KEEP_ALIVE=0 "$CONTAINER_NAME" ollama run "$MODEL" "$FINAL_PROMPT" 2>&1)

if [[ $RESPONSE == *"Error"* || $RESPONSE == *"failed"* ]]; then
    echo -e "\033[0;31mOllama Error:\033[0m $RESPONSE"
    exit 1
fi

# Ausgabe & Memory
echo -e "$RESPONSE"
if [ -z "$FIX_MODE_CMD" ]; then
    { echo "User: $QUERY"; echo "Assistant: $RESPONSE"; } > "$MEMORY_FILE"
    echo "$(tail -c 4000 "$MEMORY_FILE")" > "$MEMORY_FILE"
fi

# Clipboard (v1.9 Upgrade: Nimmt den letzten Code-Block, falls mehrere existieren)
if [ "$COPY_TO_CLIPBOARD" = true ] && command -v xclip >/dev/null; then
    CODE_BLOCK=$(echo "$RESPONSE" | sed -n '/^```/,/^```/ p' | sed '/^```/d' | tail -n 20)
    if [ -n "$CODE_BLOCK" ]; then
        echo "$CODE_BLOCK" | xclip -selection clipboard
        echo -e "\033[0;32mCode-Block kopiert.\033[0m"
    fi
fi
