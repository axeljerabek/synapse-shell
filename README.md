# 🧠 Synapse-Shell

> **The neural link between your terminal pipes and Local LLMs.**

Synapse-Shell allows you to pipe any terminal output into local LLMs via Ollama. It is built for speed, privacy, and extreme resource efficiency.

## 💡 Usage Examples

### 🔍 System Analysis
`ps aux --sort=-%cpu | head -5 | synapse-shell "Explain the top resource consumers"`

### 🛡️ Security Audit
`tail -n 20 /var/log/auth.log | synapse-shell "Any suspicious login attempts?"`

### 💻 Coding
`cat script.sh | synapse-shell "Add error handling to this script"`

## 🛠️ Installation
`./install.sh`

---
*Created by Axel Jerabek*
