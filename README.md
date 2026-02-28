# 🧠 Synapse-Shell (v1.8)

### 🚀 What is Synapse-Shell?
Imagine having a **private ChatGPT** living directly inside your Linux Terminal. 

Synapse-Shell is a tiny but powerful tool that connects your command line to a local Artificial Intelligence. It doesn't just "chat" — it understands what you are doing. You can pipe the output of any command into it, ask for a fix when you mistype something, or let it analyze your system logs without ever leaving the console.

**Best part:** It's 100% private. Everything stays on your machine.

---

### 🌟 Why you'll love it
* **🧠 It has a Memory:** It remembers what you asked a minute ago. No need to repeat yourself.
* **🛠️ The "Magic" Fix:** Typed `lesss` instead of `less`? Just type `ai-fix` and it fixes the command for you.
* **📎 File Context:** Want the AI to look at a script? Just add `@script.py` to your question.
* **🖥️ System Aware:** It knows if you are on Ubuntu, Fedora, or Mac. It gives you the *right* commands for *your* system.
* **🔋 VRAM Friendly:** It wakes up the AI when you ask, and puts it back to sleep immediately after to save your PC's energy.

---

## 💡 Real-World Examples

### 🤖 Your AI Troubleshooting Partner
* **Fix your last mistake:** Just type `ai-fix` — *Analyzes your last failed command and gives you the working version.*
* **Explain weird errors:** `dmesg | tail | s "What is wrong here?"` — *Translates cryptic system errors into human language.*

### 📂 Working with Files (Easy!)
* **Code Review:** `ai @app.py "Is there a bug in here?"`
* **Learn from files:** `ai @setup.sh "What does this script actually do?"`

### 🛠️ Daily DevOps Tasks
* **Security Check:** `ss -tulpn | s "Are any of these open ports dangerous?"`
* **Cleanup:** `df -h | s "My disk is full, what should I delete?"`

---

## 🚀 Installation in 60 Seconds

### 1. 🐳 Setup Ollama (Docker)
If you don't have Ollama running yet, the easiest way is using Docker with GPU support:

**Run Ollama Container:**

docker run -d \
  --name ollama \
  --restart always \
  -v ollama:/root/.ollama \
  -p 11434:11434 \
  --gpus all \
  ollama/ollama

(Note: Remove --gpus all if you don't have an NVIDIA GPU).

Download the Model:
We recommend the lightweight Gemma 3 (4b) model:

docker exec -it ollama ollama run gemma3:4b

(Type /exit once the download is finished).

2. Install Synapse-Shell

git clone [https://github.com/axeljerabek/synapse-shell.git](https://github.com/axeljerabek/synapse-shell.git)

cd synapse-shell

./install.sh

3. Enable "Smart Fix"

Add this line to the end of your ~/.bashrc file to enable the ai-fix command:

alias ai-fix='ai --fix "$(history 2 | head -n 1 | sed "s/^[ ]*[0-9]*[ ]*//")"'

After adding, restart your terminal or type:

 source ~/.bashrc.

🔒 Privacy First

Unlike ChatGPT or Copilot, Synapse-Shell sends ZERO data to the internet. It uses a local model running inside a Docker container on your own hardware. Your data, your AI, your rules.

Author: Axel Jerabek | Version: 1.8 "The Intelligence Update"


