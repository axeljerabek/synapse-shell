# 🧠 Synapse-Shell (v1.8)

### What is Synapse-Shell?
Synapse-Shell is a lightweight bridge that connects your Linux terminal directly to local AI via Ollama. It treats an AI model as a powerful command-line utility—similar to `grep` or `awk`, but with semantic understanding.

### 🚀 Key Features (New in v1.8)
* **🧠 Session Memory:** Remembers the last interaction. Ask follow-up questions naturally.
* **🛠️ AI-Fix Mode:** Use `ai-fix` to let the AI analyze and correct your last failed terminal command.
* **📎 File Context:** Use `@filename` to instantly feed local files into the AI's prompt.
* **🖥️ System Awareness:** Use `--sys` to give the AI context about your OS, user, and current path.
* **📋 Clipboard Integration:** Use `--copy` to automatically extract and copy code blocks to your clipboard.
* **🔋 VRAM Efficient:** Purges GPU memory (`OLLAMA_KEEP_ALIVE=0`) immediately after each task.

---

## 💡 Use Cases & Examples

### 🛠️ Smart Troubleshooting
* **Fix Typos:** `lesss file.txt` -> `ai-fix` (Suggests the correct command and explains the error)
* **Analyze Errors:** `ai --fix --copy` (Fixes the last command and puts the solution in your clipboard)

### 📁 File & System Interaction
* **Code Review:** `ai @app.py "Find potential memory leaks in this script"`
* **Multi-File Context:** `ai @index.html @style.css "How do I link these correctly?"`
* **Env-Specific Help:** `ai --sys "How do I install Apache?"` (AI knows if you need `apt`, `dnf`, or `brew`)

### 🔍 System Administration & DevOps
* **Explain Load Spikes:** `(ps aux --sort=-%cpu | head -10) | s 'Who is eating my CPU?'`
* **Network Audit:** `ss -tulpn | s 'Which ports are security risks?'`
* **Log Analysis:** `tail -n 50 /var/log/auth.log | s 'Find failed login attempts'`

### 💻 Development
* **Refactor:** `cat script.py | s 'Rewrite this for better performance'`
* **Unit Tests:** `ai @api.py "Write 3 pytest edge-cases for this"`

---

## 🚀 Quick Start

1.  **Prerequisites:** Have [Ollama](https://ollama.ai/) running.
2.  **Install:** Run `./install.sh`
3.  **Setup Fix-Alias:** Add this to your `~/.bashrc`:
    ```bash
    alias ai-fix='ai --fix "$(history 2 | head -n 1 | sed "s/^[ ]*[0-9]*[ ]*//")"'
    ```
4.  **Use:** `cat log.txt | s 'Analyze this'`

---
**Author:** Axel Jerabek | **Privacy:** 100% Local AI. No data leaves your machine.
