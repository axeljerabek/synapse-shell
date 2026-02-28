# 🧠 Synapse-Shell (v1.9.2)

### 🚀 What is Synapse-Shell?
Imagine having a **private ChatGPT** living directly inside your Linux Terminal. 

Synapse-Shell is a tiny but powerful tool that connects your command line to a local Artificial Intelligence. It doesn't just "chat" — it understands what you are doing. You can pipe the output of any command into it, ask for a fix when you mistype something, or let it analyze your system logs without ever leaving the console.

**Best part:** It's 100% private. Everything stays on your machine.

---

An AI-powered wrapper for the terminal, designed to bridge the gap between your local shell and LLMs via Ollama.

## 🛠 Features in v1.9.2
* **Persistent Memory:** Maintains context across multiple queries for a conversational flow.
* **System Awareness:** Use `--sys` to provide the AI with OS, Path, and User info for environment-specific commands.
* **File Integration:** Inject file contents directly into your prompt using `@filename`.
* **Smart File Filters (New):** Avoid context overflow by targeting specific parts of large files:
    * `--tail [N]`: Read only the last N lines (perfect for logs).
    * `--head [N]`: Read only the first N lines.
* **Docker Health-Checks:** Automatically detects if the Ollama container is down and attempts to restart it.
* **Auto-Fix:** Use `--fix` to analyze and correct the last failed command from your history.
* **Code Extraction:** Use `--copy` to automatically pipe the AI's code blocks into your clipboard.

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

### 📖 Usage Examples
* **Analyze Logs:** ai --tail 50 @/var/log/syslog "Why did the service fail?"

* **Fix Commands:** ai --fix

* **Refactor Code:** ai @script.sh "Optimize this loop"

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

 source ~/.bashrc

### 🧪 Testing
* Verify your installation and AI connectivity with the built-in test suite:

./test-suite.sh

🔒 Privacy First

Unlike ChatGPT or Copilot, Synapse-Shell sends ZERO data to the internet. It uses a local model running inside a Docker container on your own hardware. Your data, your AI, your rules.

________________________________________________________________________________________________________________________________________________________________________________________________________________________________

TESTING - Usage and output example - the AI thinking about itself:



root@home:/home/axel/dev/synapse-shell# ai Was macht dieses script @synapse-shell.sh genau? Analysiere und gib mir die Möglichkeiten aus.
-- Synapse is thinking... --
Okay, let's break down this `synapse-shell.sh` script and understand its functionality.

**Overall Purpose**

This script is a command-line interface (CLI) for interacting with the Ollama AI model running in a Docker container. It aims to provide a more structured and feature-rich experience than directly using the Ollama command-line tool.

**Key Components and Functionality**

1.  **Configuration:**
    *   `CONFIG_FILE="$HOME/.synapse-shell.conf"`:  Stores configuration settings (e.g., the default model) in a file.
    *   `MODEL="${MODEL:-$DEFAULT_MODEL}"`:  Sets the default Ollama model if no model is specified on the command line.

2.  **Docker Integration:**
    *   The script relies on Docker to run the Ollama model.
    *   It checks if the container (`ollama`) is running and starts it if it's not.

3.  **Help Function (`show_help`)**:
    *   Displays the script's usage instructions, features (like reading files, system context, etc.), and control options (new memory, flush, config).

4.  **Robustness Checks:**
    *   Ensures that Docker is installed.
    *   Verifies that the Ollama container is running.

5.  **Memory Management:**
    *   `MEMORY_FILE="/tmp/synapse-shell-memory.tmp"`: Stores the conversation history in a temporary file.
    *   `--new`: Clears the memory file.
    *   `--flush`: Restarts the Docker container and resets the VRAM (presumably for a fresh start).
    *   `--config`: Saves the selected model to the configuration file.

6.  **Parameter Parsing:**
    *   The `while` loop processes command-line arguments:
        *   `-m` or `--model`: Specifies the Ollama model to use.
        *   `--sys`: Adds system context (likely derived from the current environment).
        *   `--copy`:  Copies the generated code (likely from an Ollama response) to the clipboard.
        *   `--fix`: Attempts to identify and correct errors in a given command.  This is a clever attempt to handle common user mistakes. It retrieves the last 20 lines of your bash history and attempts to fix it.
        *   `--help`: Displays the help message.

7.  **File Handling:**
    *   `@file`:  Reads the content of a file and includes it in the prompt sent to Ollama.
    *   The script handles file reading, checks for file existence, and constructs the prompt appropriately.

8.  **Prompt Construction:**
    *   The script dynamically constructs the prompt sent to Ollama, including:
        *   System context (`SYS_INFO`)
        *   File content (`FILE_CONTENT`)
        *   Conversation history (`HISTORY`)
        *   User input (`STDIN_DATA`)
        *   The command to analyze (if `--fix` is used)

9.  **Interaction with Ollama:**
    *   Executes the Ollama command using `docker exec` with the specified model and prompt.

10. **Output and Memory Storage:**
    *   Displays the response from Ollama.
    *   Stores the conversation (user input and Ollama's response) to the memory file for later use.

11. **Clipboard Integration:**
    *   If the `--copy` option is used, the script attempts to copy the last 20 lines of the Ollama's response to the clipboard.

**How it Works (Example)**

1.  You run the script: `ai @my_file.txt "Summarize this file"`
2.  The script reads `my_file.txt`.
3.  It constructs a prompt including the file's content, the system information, the previous conversation, and your question.
4.  The prompt is sent to the Ollama model running in the Docker container.
5.  Ollama generates a response.
6.  The response is displayed, and the conversation (your question and Ollama's answer) is stored in the `synapse-shell-memory.tmp` file.
7.  If you used the `--copy` option, the response is copied to your clipboard.

**Key Improvements / Features**

*   **Error Handling:**  The script includes checks for Docker and the Ollama container, providing error messages and exit codes.
*   **Memory Management:**  Allows you to clear memory, reset the container, and save your preferred model.
*   **File Input:**  Enables you to feed files to Ollama for analysis or processing.
*   **Interactive Mode:**  Designed for conversational interactions.
*   **Fix Mode:** A unique feature attempts to correct common user mistakes when running commands.

**In essence, this script is a wrapper around the Ollama CLI, adding features like memory management, file input, and a more structured way to interact with the AI model.**

Do you want me to elaborate on a specific aspect of the script (e.g., the prompt construction, the Docker integration, or the memory management)? Or, would you like me to explain any of the code in more detail?





Author: Axel Jerabek | Version: 1.9.2 "The Intelligence Update"


