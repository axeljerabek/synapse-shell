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

 source ~/.bashrc

🔒 Privacy First

Unlike ChatGPT or Copilot, Synapse-Shell sends ZERO data to the internet. It uses a local model running inside a Docker container on your own hardware. Your data, your AI, your rules.

________________________________________________________________________________________________________________________________________________________________________________________________________________________________

Usage and output example:



root@home:/home/axel/dev/synapse-shell# ai Was macht dieses script @synapse-shell.sh ?
-- Synapse is thinking... --
Okay, let's break down this shell script (`synapse-shell.sh`) and analyze the provided snippet.

**Overall Purpose**

The script is a command-line interface (CLI) for interacting with the Ollama AI model. It's designed to provide a context-aware chat experience, leveraging a local Ollama container, a memory store, and potentially the user's command history.  It aims to provide helpful hints, analyze commands, and even copy code snippets to the clipboard.

**Key Components and Breakdown of the Provided Snippet**

1. **Configuration:**
   - `CONFIG_FILE`:  Stores settings like the default Ollama container name and model.
   - `MEMORY_FILE`:  Used for persisting the conversation history.
   - `CONTAINER_NAME`: The name of the Docker container running Ollama.
   - `DEFAULT_MODEL`: The default Ollama model to use if one isn't specified.

2. **`show_help()` Function:**
   - Displays the script's usage instructions and available features.  This is crucial for understanding how to use the script.

3. **`get_sys_info()` Function:**
   - Provides system information like OS, current directory, and user.

4. **Parameter Parsing (The `while` loop):**
   - This is the core of the argument handling. It processes command-line arguments (options) passed to the script.
   - `-m|--model`: Sets the Ollama model to use.
   - `--new`: Clears the memory.
   - `--flush`: Restarts the Ollama container (essentially a hard reset, forcing a new container to be created).
   - `--config`: Saves the current model setting to the configuration file.
   - `--sys`:  Calls `get_sys_info()` to populate the `SYS_INFO` variable.
   - `--copy`: Sets the `COPY_TO_CLIPBOARD` flag to `true`.
   - `--fix`: This is interesting. It attempts to analyze the user's command. If the user provides a command after `--fix`, it captures that command.  Otherwise, it tries to extract a command from the user's bash history.  This suggests a feature to help with debugging or understanding the command that Ollama wasn't able to handle.
   - `--help`: Calls the `show_help()` function.
   - `*)`:  Captures any remaining arguments as part of the main query/input.

5. **File Handling (`@file`):**
   - The `@file` option allows the user to input the content of a file. The script reads the file content and appends it to the context.

6. **Input Capture:**
   -  Captures user input both from standard input (`STDIN_DATA`) and from the remaining arguments.

7. **Memory Loading:**
   - Reads the content of the `MEMORY_FILE` to load the previous conversation history.

8. **Prompt Construction:**
   - Builds the prompt sent to the Ollama container, incorporating system information, file content, and the user's input.

9. **Execution and Output:**
   - Executes the Ollama command using `docker exec`.
   - Prints the response from Ollama to the console.

10. **Memory Saving:**
   - Saves the current user query and the assistant's response to the `MEMORY_FILE`.  It also appends a chunk of the memory file to prevent it from becoming too large.

11. **Clipboard Copying:**
    - If `COPY_TO_CLIPBOARD` is true (set by the `--copy` option), it attempts to extract code blocks from the Ollama response and copy them to the clipboard using `xclip`.

**The Final Lines of the Snippet and Their Significance**

```bash
[HISTORY]
User: Was macht dieses script @synapse-shell.sh ?
Assistant: Ich bin mir leider nicht sicher, was das Skript `@synapse-shell.sh` macht. Die bereitgestellte Kontextinformation enthält keine Details über dieses spezifische Skript. Ich kann dir nur Informationen über den Ubuntu 24.04 Kernel geben.

[USER]:  Was macht dieses script ?
```

*   This demonstrates the script's conversational capabilities.  The user asks about the script itself, and the script responds with its own explanation (or rather, a canned response).
*   This highlights the memory mechanism – the "context" is the conversation history, allowing the script to reference previous interactions.
*   It's a simple test case to verify the basic functionality.

**Key Improvements/Observations**

*   **Error Handling:** The script lacks comprehensive error handling. It could benefit from more robust checks for file existence, Docker container availability, and potential errors during command execution.
*   **Command History Analysis:** The `--fix` option is a clever idea for debugging, but it's rudimentary.
*   **Clipboard Integration:**  The script relies on `xclip` to work. It's a good feature to have, but the code extraction is simple and might not handle complex code blocks well.
*   **Prompt Engineering:** The prompt construction is relatively simple.  More sophisticated prompt engineering could significantly improve the quality of the responses from Ollama.

**In summary, `synapse-shell.sh` is a functional script that provides a basic interface to Ollama, incorporating context, memory, and potential debugging tools. The provided snippet demonstrates its core features and conversational flow.**

Do you want me to elaborate on any specific aspect of the script (e.g., the parameter parsing, the prompt construction, or the memory management)?
root@home:/home/axel/dev/synapse-shell#




Author: Axel Jerabek | Version: 1.8 "The Intelligence Update"


