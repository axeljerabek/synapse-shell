# Synapse-Shell

Synapse-Shell is a minimalist command-line interface (CLI) that acts as a bridge between standard POSIX pipes and local Large Language Models (LLMs) via the Ollama API. It is designed for system administrators and developers who need to perform semantic analysis on terminal output without leaving the shell environment.

## Core Principles
* **Non-Interactive Processing:** Unlike typical AI chat interfaces, Synapse-Shell focuses on one-shot command execution within a pipeline.
* **VRAM Management:** The tool enforces 'OLLAMA_KEEP_ALIVE=0', ensuring that the model is offloaded from the GPU immediately after the inference is completed, preserving resources for other tasks.
* **Data Sovereignty:** By utilizing local Ollama instances, sensitive system data or proprietary code remains entirely on-premises.

## Technical Usage
The tool reads from 'stdin' and prepends it to the user-provided prompt, allowing for context-aware processing.

### System Diagnostics
Pipe system state information for immediate interpretation:
`top -b -n 1 | head -n 20 | synapse-shell 'Identify processes with abnormal CPU consumption'`

### Log Filtering and Summarization
Extract meaning from verbose log files:
`journalctl -u ssh | tail -n 50 | synapse-shell 'List unique IP addresses and frequency of failed login attempts'`

### Code Analysis
Review or refactor snippets directly from the file system:
`cat main.c | synapse-shell 'Provide a security audit focusing on buffer overflows'`

## Installation
1. Ensure a local Ollama instance is accessible.
2. Clone this repository.
3. Run './install.sh' to create a symlink in /usr/local/bin/ and a shell alias 's'.

## Configuration
Settings are stored in '~/.synapse-shell.conf'. You can modify the default model or specify it per execution using the '-m' flag.

---
Author: Axel Jerabek
