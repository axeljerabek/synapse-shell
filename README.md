# 🧠 Synapse-Shell

> **The neural link between your terminal pipes and Local LLMs.**

Synapse-Shell is a lightweight, high-performance CLI tool designed to pipe your terminal output directly into local Large Language Models (like Gemma 3, Llama 3, or Mistral) via Ollama. 

Built with **system administrators** and **developers** in mind, it features automatic VRAM management, making it perfect for machines with limited resources (e.g., 6GB VRAM).

---

## 🚀 Key Features

* **Pipe-Native:** Seamlessly works with `cat`, `grep`, `tail`, `ls`, and more.
* **VRAM Efficient:** Automatically releases GPU memory immediately after the response (`OLLAMA_KEEP_ALIVE=0`).
* **Context Aware:** Automatically combines piped data with your specific questions or instructions.
* **Model Flexible:** Switch between models on the fly with the `-m` flag.
* **Zero Latency:** No heavy Web-UI. Just pure terminal speed.

---

## 🛠️ Installation

1.  **Prerequisites:** * [Docker](https://docs.docker.com/get-docker/) installed.
    * [Ollama](https://ollama.com) running in Docker.

2.  **One-Step Setup:**
    Clone the repo and run the installer:
    ```bash
    git clone [https://github.com/axeljerabek/synapse-shell.git](https://github.com/axeljerabek/synapse-shell.git)
    cd synapse-shell
    chmod +x install.sh
    ./install.sh
    ```

---

## 💡 Usage Examples

### 🔍 System Analysis
Find out why your system is slow or what's eating your RAM:
```bash
(ps aux --sort=-%cpu | head -10; free -h) | synapse-shell "Analyze the system load"
