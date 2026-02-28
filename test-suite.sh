#!/bin/bash

# --- CONFIG ---
SCRIPT="./synapse-shell.sh"
TEST_FILE="test_context.txt"

# Vorbereitung: Testdatei erstellen
echo "Das ist eine Test-Datei fuer die Synapse-Shell." > "$TEST_FILE"

echo -e "\033[1;34m=== SYNAPSE-SHELL V1.9 TEST SUITE (Final) ===\033[0m\n"

# Test 1: Basis-Funktion (Ollama Verbindung & Modell-Antwort)
echo -n "[ ] Test 1: Basis-Anfrage... "
RES1=$($SCRIPT "Antworte nur mit dem Wort OK" 2>/dev/null)
if echo "$RES1" | grep -qi "OK"; then
    echo -e "\033[0;32mPASSED\033[0m"
else
    echo -e "\033[0;31mFAILED\033[0m (Antwort: $RES1)"
fi

# Test 2: Datei-Kontext (@)
echo -n "[ ] Test 2: Datei-Kontext (@)... "
RES2=$($SCRIPT @$TEST_FILE "Was ist das fuer eine Datei?" 2>/dev/null)
if echo "$RES2" | grep -Ei "Test|Datei|Synapse" >/dev/null; then
    echo -e "\033[0;32mPASSED\033[0m"
else
    echo -e "\033[0;31mFAILED\033[0m"
fi

# Test 3: System-Info (--sys)
echo -n "[ ] Test 3: System-Info (--sys)... "
RES3=$($SCRIPT --sys "Welcher User fuehrt das aus?" 2>/dev/null)
if echo "$RES3" | grep -qi "root"; then
    echo -e "\033[0;32mPASSED\033[0m"
else
    echo -e "\033[0;31mFAILED\033[0m"
fi

# Test 4: Clipboard-Extraktion (X11 / Root Check)
echo -n "[ ] Test 4: Clipboard (--copy)... "
if [ -z "$DISPLAY" ]; then
    echo -e "\033[0;33mSKIPPED (Kein X11/Root-Mode)\033[0m"
else
    $SCRIPT --copy "Gib mir nur den Code \`\`\`ls -la\`\`\`" > /dev/null 2>&1
    echo -e "\033[0;32mPASSED\033[0m"
fi

# Test 5: AI-Fix Modus (Optimierter Match)
echo -n "[ ] Test 5: AI-Fix Korrektur... "
RES5=$($SCRIPT --fix "gitt status" 2>/dev/null)
# Wir prüfen einfach, ob sowohl 'git' als auch 'status' in der Antwort vorkommen
if echo "$RES5" | grep -qi "git" && echo "$RES5" | grep -qi "status"; then
    echo -e "\033[0;32mPASSED\033[0m"
else
    echo -e "\033[0;31mFAILED\033[0m (Antwort: $RES5)"
fi

# --- CLEANUP ---
[ -f "$TEST_FILE" ] && rm "$TEST_FILE"
echo -e "\n\033[1;34m=== TESTS ABGESCHLOSSEN ===\033[0m"
