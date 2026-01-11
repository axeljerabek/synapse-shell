# 🧠 Synapse-Shell

### What is Synapse-Shell?
Synapse-Shell is a lightweight bridge that connects your Linux terminal directly to local Artificial Intelligence. It treats an AI model not as a chatbot you talk to in a browser, but as a powerful command-line utility—similar to how you use 'grep', 'sed', or 'awk'.

### What does it do?
It takes the text output from any command (via pipes) and sends it to a local Large Language Model (LLM) along with your instructions. The AI processes that data and returns the result directly to your terminal screen.

### How does it help you?
* **Instant Interpretation:** No more googling cryptic error messages. Pipe the error to 's' and get an explanation.
* **Data Transformation:** Need to turn a messy log file into a clean JSON list? Pipe it.
* **Code on the Fly:** Refactor or debug scripts without leaving your editor or terminal.

### Why use this instead of a Web-AI?
* **Privacy & Security:** Sensitive system logs, API keys in files, or proprietary code stay on your machine. Nothing is uploaded to the cloud.
* **Context Awareness:** It automatically 'sees' what your terminal sees. You don't have to copy-paste back and forth.
* **Resource Efficiency:** It is designed for 'one-shot' tasks. It loads the model, does the job, and immediately clears your GPU memory (VRAM), so your computer stays fast for other work.

---

## 💡 Usage Examples

### 🔍 System Diagnostics
`top -b -n 1 | head -n 20 | s 'Which process is the biggest bottleneck?'`

### 🛠️ Scripting & Development
`cat setup.sh | s 'Check this script for potential security risks'`

## 🚀 Quick Start
1. Ensure **Ollama** is running.
2. Install with: `./install.sh`
3. Use the shortcut: `ls -la | s 'What am I looking at?'`

---
Author: Axel Jerabek
