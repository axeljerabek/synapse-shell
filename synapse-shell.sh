#!/bin/bash

# --- DEFAULTS ---
CONFIG_FILE="$HOME/.synapse-shell.conf"
MEMORY_FILE="/tmp/synapse-shell-memory.tmp"
CONTAINER_NAME="ollama"
DEFAULT_MODEL="gemma3:4b"

# Lade Konfiguration
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"
MODEL="${MODEL:-$DEFAULT_MODEL}"

# --- ROBUSTNESS CHECKS ---
if ! command -v docker >/dev/null; then
    echo -e "\033[0;31mError: Docker ist nicht installiert.\033[0m"
    exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
    docker start "$CONTAINER_NAME" >/dev/null 2>&1
fi

show_help() {
    echo -e "\033[1;36m"
    echo "  ___ _   _ _ __   __ _ _ __  ___  ___ "
    echo " / __| | | | '_ \ / _\` | '_ \/ __|/ _ \\"
    echo " \__ \ |_| | | | | (_| | |_) \__ \  __/"
    echo " |___/\__, |_| |_|\__,_| .__/|___/\___|"
    echo "      |___/            |_|   SHELL v1.9.2"
    echo -e "\033[0m"
    echo "=============================================================="
    echo "USAGE: ai [OPTIONS] \"Frage\" oder @datei"
    echo ""
    echo "FEATURES:"
    echo "  @datei              Inhalt einer Datei einlesen"
    echo "  --sys               System-Kontext hinzufügen"
    echo "  --fix \"cmd\"         Befehl analysieren & korrigieren"
    echo "  --copy              Code in die Ablage kopieren"
    echo ""
    echo "FILTER (für große Dateien/Logs):"
    echo "  --tail [N]          Nur die letzten N Zeilen der Datei lesen"
    echo "  --head [N]          Nur die ersten N Zeilen der Datei lesen"
    echo ""
    echo "STEUERUNG:"
    echo "  --new               Gedächtnis löschen"
    echo "  --flush             Docker & VRAM Reset"
    echo "  --config            Aktuelles Modell speichern"
    echo "=============================================================="
    exit 0
}

# Parameter Parsing
SYS_INFO=""
COPY_TO_CLIPBOARD=false
FIX_MODE_CMD=""
LINE_FILTER=""
FILTER_VAL=50
REMAINING_ARGS=()

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -m|--model) MODEL="$2"; shift ;;
        --new) rm -f "$MEMORY_FILE"; echo "Memory gelöscht."; exit 0 ;;
        --flush) docker restart "$CONTAINER_NAME" > /dev/null; echo "VRAM geflasht."; exit 0 ;;
        --config) echo "MODEL=\"$MODEL\"" > "$CONFIG_FILE"; echo "Config gespeichert."; exit 0 ;;
        --sys) SYS_INFO=$(echo -e "\n[SYSTEM INFO]\nOS: $(uname -srm), Path: $(pwd), User: $(whoami)") ;;
        --copy) COPY_TO_CLIPBOARD=true ;;
        --tail) LINE_FILTER="tail"; [[ "$2" =~ ^[0-9]+$ ]] && { FILTER_VAL="$2"; shift; } ;;
        --head) LINE_FILTER="head"; [[ "$2" =~ ^[0-9]+$ ]] && { FILTER_VAL="$2"; shift; } ;;
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
        if [ -f "$FILE_PATH" ]; then
            if [ -n "$LINE_FILTER" ]; then
                CONTENT=$($LINE_FILTER -n "$FILTER_VAL" "$FILE_PATH")
                FILE_CONTENT="$FILE_CONTENT\n--- FILE ($LINE_FILTER $FILTER_VAL): $FILE_PATH ---\n$CONTENT\n"
            else
                FILE_CONTENT="$FILE_CONTENT\n--- FILE: $FILE_PATH ---\n$(cat "$FILE_PATH")\n"
            fi
        fi
    else
        FINAL_QUERY_ARGS+=("$arg")
    fi
done

STDIN_DATA=""
[ ! -t 0 ] && STDIN_DATA=$(cat)
QUERY="${FINAL_QUERY_ARGS[*]}"

# Memory laden (begrenzt)
HISTORY=""
[ -f "$MEMORY_FILE" ] && HISTORY=$(tail -c 2000 "$MEMORY_FILE")

# Prompt Strategie
if [ -n "$FIX_MODE_CMD" ]; then
    FINAL_PROMPT="Korragiere diesen Befehl: '$FIX_MODE_CMD'. Erkläre kurz und gib NUR den Code-Block aus."
else
    FINAL_PROMPT="[KONTEXT]$SYS_INFO\n$FILE_CONTENT\n\n[HISTORY]\n$HISTORY\n\n[USER]: $STDIN_DATA $QUERY"
fi

echo -e "\033[1;30m-- Synapse is thinking... --\033[0m"
RESPONSE=$(docker exec -i "$CONTAINER_NAME" ollama run "$MODEL" "$FINAL_PROMPT")

echo -e "$RESPONSE"

# Memory
if [ -z "$FIX_MODE_CMD" ]; then
    { echo "User: $QUERY"; echo "AI: $RESPONSE"; } >> "$MEMORY_FILE"
    echo "$(tail -c 3000 "$MEMORY_FILE")" > "$MEMORY_FILE"
fi

# Clipboard
if [ "$COPY_TO_CLIPBOARD" = true ] && command -v xclip >/dev/null; then
    echo "$RESPONSE" | sed -n '/^```/,/^```/ p' | sed '/^```/d' | tail -n 50 | xclip -selection clipboard
    echo -e "\033[0;32mCode kopiert.\033[0m"
fi
