# 🧠 Synapse-Shell

> **Transform your terminal into an expert. Use local AI directly in your pipeline.**

Synapse-Shell is the "interpreter" for your Linux system. It takes complex data from your commands (logs, code, tables) and explains it to you in plain English – **100% private, local, and free.**

---

## 🌟 What makes Synapse-Shell special?

Instead of tediously copying error messages into a website, you just "pipe" them directly to the AI.

### Why you will love it:
* **Privacy:** Your data never leaves your machine.
* **GPU-Friendly:** The tool loads the AI, answers, and purges the VRAM immediately. Your PC stays fast.
* **Unix-Style:** It integrates seamlessly with commands like `ls`, `grep`, or `tail`.

---

## 💡 Cool things you can do

### 🚦 The "What is happening" Check (For Beginners)
Confused by a process list? Just ask:
`ps aux --sort=-%mem | head -5 | s "Which program uses the most RAM and is it dangerous?"`

### 🛠️ The "Script Doctor" (For Developers)
Bash script not working? Let the AI find the bug:
`cat my_script.sh | s "Find the error and give me the corrected code."`

### 🔍 The "Command Explainer" (For Learning)
Found a complex command online? Understand it instantly:
`echo "find . -type f -mtime -7 -print" | s "Explain this command step by step."`

### 🕵️ The "Security Sentinel"
Check who logged into your PC:
`last -n 5 | s "Analyze these logins. Does this look like normal activity?"`

---

## 🚀 Installation in 60 Seconds

1. **Prerequisite:** [Ollama](https://ollama.com) installed.
2. **Install:**
   `git clone https://github.com/axeljerabek/synapse-shell.git`
   `cd synapse-shell && chmod +x install.sh && ./install.sh`
3. **Activate:**
   Run `source ~/.bashrc`. Now you can just use the shortcut **`s`**!

---
**Created with ❤️ by Axel Jerabek**