# 🧠 Synapse-Shell

### What is Synapse-Shell?
Synapse-Shell is a lightweight bridge that connects your Linux terminal directly to local AI. It treats an AI model as a powerful command-line utility—similar to 'grep' or 'awk'.

### What does it do?
It takes the output from any command (via pipes) and sends it to a local LLM with your instructions. The AI processes that data and returns the result directly to your terminal.

### Why use this?
* **Privacy:** 100% local via Ollama. No data leaks.
* **VRAM Efficient:** Purges GPU memory immediately after the task.
* **Unix-Native:** Built for pipes and automation.

---

## 💡 Massive Gallery of Use Cases

### 🔍 System Administration & DevOps
* **Explain Load Spikes:** `(ps aux --sort=-%cpu | head -10) | s 'Who is eating my CPU and should I kill it?'`
* **Storage Cleanup:** `df -h | s 'Identify the most critical partitions and suggest cleanup commands'`
* **System Health:** `uptime | s 'Is this load average normal for a 4-core CPU?'`
* **Network Audit:** `ss -tulpn | s 'Which of these open ports are potential security risks?'`

### 🛡️ Security & Log Analysis
* **Brute-Force Detection:** `tail -n 50 /var/log/auth.log | s 'Find failed login attempts and group them by IP'`
* **Kernel Debugging:** `dmesg | tail -n 20 | s 'Explain these kernel errors in simple terms'`
* **Docker Audits:** `docker logs my_container --tail 20 | s 'What is causing this container to crash?'`

### 💻 Development & Coding
* **Refactor Code:** `cat script.py | s 'Rewrite this using list comprehensions for better performance'`
* **Generate Docs:** `cat function.go | s 'Write a professional Javadoc-style comment for this'`
* **Unit Testing:** `cat api.py | s 'Write 3 edge-case tests for this endpoint using pytest'`
* **SQL Optimization:** `echo "SELECT * FROM users WHERE id > 10" | s 'Is there a more efficient way to write this?'`

### ✍️ Content & Data Processing
* **Format Conversion:** `cat data.csv | s 'Convert this into a clean Markdown table'`
* **Summarization:** `cat long_notes.txt | s 'Give me the 5 most important bullet points'`
* **Translation:** `cat readme_de.md | s 'Translate this into professional English'`

### 🎓 Learning the Terminal
* **Explaining Flags:** `echo "tar -xzvf archive.tar.gz" | s 'What does each flag (x, z, v, f) actually do?'`
* **Command Discovery:** `ls --help | s 'How do I sort this output by file size?'`

## 🚀 Quick Start
1. Have **Ollama** running.
2. Install: `./install.sh`
3. Use the shortcut: `cat log.txt | s 'Analyze this'`

---
Author: Axel Jerabek
