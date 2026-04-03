#!/bin/bash

# --- DEFAULTS ---
CONFIG_FILE="$HOME/.synapse-shell.conf"
MEMORY_FILE="/tmp/synapse-shell-memory.tmp"
CONTAINER_NAME="ollama"
# Optimiert für RTX 2060 (E2B bietet das beste Speed/Intelligence-Verhältnis bei 6GB)
DEFAULT_MODEL="gemma4:e2b"
MAX_INPUT_CHARS=12000 

# --- SYSTEM PROMPT (Gemma 4 Edition) ---
DEFAULT_SYSTEM_PROMPT="Du bist ein technischer Assistent. Antworte kurz und knapp auf Deutsch. Nutze technisches Fachvokabular. WICHTIG: Wenn nach Code gefragt wird oder Dateien bearbeitet werden, gib immer den VOLLSTÄNDIGEN Inhalt der Datei aus, nicht nur Fragmente."

# Hilfe-Funktion
show_help() {
    echo -e "\033[1;34mSynapse-Shell (Gemma 4 Edition)\033[0m"
    echo -e "Nutzung: ai [OPTIONEN] [DATEI-REFERENZ @datei] [\"DEINE FRAGE\"]\n"
    echo -e "\033[1mOPTIONEN:\033[0m"
    echo -e "  -h, --help      Zeigt diese Hilfe an."
    echo -e "  -m, --model     Überschreibt das Modell (Aktuell: $MODEL)."
    echo -e "  --new           Löscht die lokale Chat-Historie."
    echo -e "  --flush         Startet den Docker-Container neu (VRAM-Reset)."
    echo -e "  --config        Speichert aktuelle Einstellungen in $CONFIG_FILE."
    echo -e "  --sys           Sendet System-Infos (OS, Pfad, User) als Kontext mit."
    echo -e "  --explain       Antwortet ausführlicher (erweitert System-Prompt)."
    echo -e "  --run           Extrahiert Code und bietet direkte Ausführung an (y/N)."
    echo -e "  --fix [CMD]     Korrigiert einen Befehl (oder den letzten aus der History)."
    echo -e "  --tail [N]      Liest nur die letzten N Zeilen einer @datei."
    echo -e "  --head [N]      Liest nur die ersten N Zeilen einer @datei.\n"
    echo -e "\033[1mBEISPIELE:\033[0m"
    echo -e "  ai \"Wie entpacke ich eine .tar.gz Datei?\""
    echo -e "  ai --fix"
    echo -e "  ai @config.json \"Validier dieses JSON Format\""
    echo -e "  cat logs.txt | ai \"Finde die Error-Meldung\""
}

# Lade Konfiguration
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"
MODEL="${MODEL:-$DEFAULT_MODEL}"
SYSTEM_PROMPT="${SYSTEM_PROMPT:-$DEFAULT_SYSTEM_PROMPT}"

# --- ROBUSTNESS CHECKS ---
if ! command -v docker >/dev/null; then
    echo -e "\033[0;31mError: Docker ist nicht installiert.\033[0m"
    exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
    docker start "$CONTAINER_NAME" >/dev/null 2>&1
fi

# Parameter Parsing
SYS_INFO=""
FIX_MODE_CMD=""
LINE_FILTER=""
FILTER_VAL=50
EXPLAIN_MODE=false
EXECUTE_CODE=false
REMAINING_ARGS=()

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) show_help; exit 0 ;;
        -m|--model) MODEL="$2"; shift ;;
        --new) rm -f "$MEMORY_FILE"; echo "Memory gelöscht."; exit 0 ;;
        --flush) docker restart "$CONTAINER_NAME" > /dev/null; echo "VRAM geflasht."; exit 0 ;;
        --config) 
            echo "MODEL=\"$MODEL\"" > "$CONFIG_FILE"
            echo "SYSTEM_PROMPT=\"$SYSTEM_PROMPT\"" >> "$CONFIG_FILE"
            echo "MAX_INPUT_CHARS=$MAX_INPUT_CHARS" >> "$CONFIG_FILE"
            echo "Config gespeichert."; exit 0 ;;
        --sys) SYS_INFO=$(echo -e "\n[SYSTEM INFO]\nOS: $(uname -srm), Path: $(pwd), User: $(whoami)") ;;
        --explain) EXPLAIN_MODE=true ;;
        --run) EXECUTE_CODE=true ;;
        --tail) LINE_FILTER="tail"; [[ "$2" =~ ^[0-9]+$ ]] && { FILTER_VAL="$2"; shift; } ;;
        --head) LINE_FILTER="head"; [[ "$2" =~ ^[0-9]+$ ]] && { FILTER_VAL="$2"; shift; } ;;
        --fix)
            if [[ -n "$2" && "$2" != --* ]]; then
                FIX_MODE_CMD="$2"; shift
            else
                FIX_MODE_CMD=$(tail -n 20 "$HOME/.bash_history" 2>/dev/null | grep -vE "^(ai|s |exit|#|--)" | tail -n 1)
            fi ;;
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
            CONTENT=$([ -n "$LINE_FILTER" ] && $LINE_FILTER -n "$FILTER_VAL" "$FILE_PATH" || cat "$FILE_PATH")
            FILE_CONTENT="$FILE_CONTENT\n--- FILE: $FILE_PATH ---\n$CONTENT\n"
        fi
    else
        FINAL_QUERY_ARGS+=("$arg")
    fi
done

STDIN_DATA=""
[ ! -t 0 ] && STDIN_DATA=$(cat | head -c "$MAX_INPUT_CHARS")
QUERY="${FINAL_QUERY_ARGS[*]}"
[ -f "$MEMORY_FILE" ] && HISTORY=$(tail -c 4000 "$MEMORY_FILE")

# --- PROMPT LOGIK ---
INSTRUCTION="$SYSTEM_PROMPT"
[ "$EXPLAIN_MODE" = true ] && INSTRUCTION="$SYSTEM_PROMPT Erkläre die Hintergründe jedoch ausführlicher."

if [ -n "$FIX_MODE_CMD" ]; then
    FINAL_PROMPT="<|system|>\n$INSTRUCTION\n<|user|>\nKorragiere diesen Befehl: '$FIX_MODE_CMD'. Gib NUR den Code-Block aus."
else
    FINAL_PROMPT="<|system|>\n$INSTRUCTION\n$SYS_INFO\n<|user|>\n$FILE_CONTENT\n\n[HISTORY]\n$HISTORY\n\nFrage: $STDIN_DATA $QUERY"
fi

echo -e "\033[1;30m-- Synapse (Gemma 4) is thinking... --\033[0m"
RESPONSE=$(printf "%b" "$FINAL_PROMPT" | head -c "$MAX_INPUT_CHARS" | docker exec -i "$CONTAINER_NAME" ollama run "$MODEL")

echo -e "$RESPONSE"

# --- EXECUTION LOGIK (Y/n) ---
if [ "$EXECUTE_CODE" = true ]; then
    EXTRACTED_CODE=$(echo "$RESPONSE" | sed -n '/^```/,/^```/ p' | sed '/^```/d')
    if [ -n "$EXTRACTED_CODE" ]; then
        echo -e "\n\033[1;33mCode ausführen?\033[0m"
        echo -e "----------------------------------------"
        echo -e "$EXTRACTED_CODE"
        echo -e "----------------------------------------"
        read -p "(y/N): " confirm
        [[ "$confirm" =~ ^[Yy]$ ]] && eval "$EXTRACTED_CODE" || echo "Abgebrochen."
    fi
fi

# Memory Management
if [ -z "$FIX_MODE_CMD" ]; then
    { echo "User: $QUERY"; echo "AI: $RESPONSE"; } >> "$MEMORY_FILE"
    echo "$(tail -c 5000 "$MEMORY_FILE")" > "$MEMORY_FILE"
fi
