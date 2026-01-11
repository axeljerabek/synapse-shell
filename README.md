# Synapse-Shell

Synapse-Shell is a minimalist CLI that bridges the gap between terminal pipes and local LLMs via Ollama. It turns cryptic terminal output into human-readable analysis.

---

## 🛠 What can you do with it?

### For Beginners
* **Explain the mess:** `ls -la /etc | s 'What are the most important config files here?'`
* **Fix errors:** `cat script.sh | s 'Find the syntax error and fix it.'`
* **Understand commands:** `echo 'find . -mtime +30' | s 'What does this do?'`

### For Professionals
* **Security Audits:** `tail -n 100 /var/log/auth.log | s 'Check for suspicious login patterns'`
* **Refactoring:** `cat file.js | s 'Convert this to modern syntax'`
* **System Health:** `df -h | s 'Identify disks near capacity'`

## ⚙️ Core Principles
* **One-Shot Execution:** Designed for pipelines, not a chat interface.
* **VRAM Efficiency:** Automatically purges GPU memory after inference (KEEP_ALIVE=0).
* **100% Privacy:** Runs locally via Ollama. No data leaks.

## 🚀 Quick Start
1. Have **Ollama** running.
2. Run the installer:
`git clone https://github.com/axeljerabek/synapse-shell.git`
`cd synapse-shell && chmod +x install.sh && ./install.sh`

---
Author: Axel Jerabek
