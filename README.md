🧠 Synapse-Shell (v2.0.0) — The Gemma 4 Era
🚀 What is Synapse-Shell?
Imagine having a private ChatGPT living directly inside your Linux Terminal.

Synapse-Shell is a lightweight but powerful tool that connects your command line to a local Artificial Intelligence. It doesn't just "chat" — it understands the context of your work. You can inject files, analyze errors, or execute code directly from the AI's response.

The best part: It's 100% private. Everything stays on your machine. Powered by Gemma 4, it now features native reasoning and multimodality.

🛠 Features in v2.0.0 (Gemma 4 Update)
Gemma 4 Native: Optimized for the latest Google model generation (E2B for efficiency, 31B for maximum logic).

Native System Roles: Utilizes Gemma 4's new <|system|> tags for more precise instructions and better instruction-following.

Deep Reasoning: Supports Gemma 4’s new "Thinking Mode" for complex mathematical and logical problems.

Persistent Memory: Increased context memory (5000 characters history) to leverage the 128k/256k context windows of Gemma 4.

Smart File Integration: Inject files using @filename. Use --head or --tail to send only relevant parts (e.g., the end of a log file).

Auto-Fix & Execute: * --fix: Analyzes and corrects the last failed command from your history.

--run: Extracts code blocks from the AI's response and offers interactive (y/N) execution.

VRAM Management: Use --flush to restart the Docker container and immediately free up your GPU's video memory.

💡 Real-World Examples
🤖 Your AI Troubleshooting Partner
Fix your last mistake: Just type ai --fix — Analyzes your last failed command and provides the working version.

Execute Code: ai --run "Create a Python script that counts all PDFs in this folder" — AI writes the code, you just press 'y' to run it.

📂 Working with Files
Full Refactor: ai @app.py "Rewrite the database logic to be async" — With the v2.0 update, the AI is instructed to always return the complete file content.

Log Analysis: ai --tail 20 @/var/log/syslog "Why did the service fail?"

🛠️ Daily DevOps Tasks
Security Check: ai --sys "Which of these open ports are a security risk?"

Explain Mode: ai --explain @setup.sh "What does this script actually do?"

🚀 60-Second Installation
1. 🐳 Setup Ollama (Docker)
Ensure Ollama is running with GPU support:

docker run -d \
  --name ollama \
  --restart always \
  -v ollama:/root/.ollama \
  -p 11434:11434 \
  --gpus all \
  ollama/ollama

2. Download Gemma 4
For most setups (like RTX 2060/3060), we recommend the highly efficient E2B model:

docker exec -it ollama ollama pull gemma4:e2b

3. Install Synapse-Shell

git clone https://github.com/axeljerabek/synapse-shell.git
cd synapse-shell
chmod +x install.sh
./install.sh

4. Smart-Fix Alias (Optional but Recommended)
Add this to your ~/.bashrc to heal terminal errors instantly with fix:

alias fix='ai --fix'

📖 CLI Usage & HelpYou can access the built-in help at any time:ai --helpCommandDescription--newClears the short-term memory (history).--sysAdds OS, Path, and User info as context.--configSaves the current model/prompt to ~/.synapse-shell.conf.--flushFlushes the GPU VRAM.

🔒 Privacy & License
Privacy First: Unlike ChatGPT or Copilot, Synapse-Shell sends ZERO data to the internet. Your data, your AI, your rules.

License: Starting with v2.0, this project follows Google’s move to the Apache 2.0 license. Maximum freedom for developers.

Author: Axel Jerabek | Version: 2.0.0 "The Gemma 4 Era" | License: Apache 2.0
