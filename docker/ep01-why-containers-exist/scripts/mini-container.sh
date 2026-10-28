#!/usr/bin/env bash
# Episode 1 — Build a tiny "container" by hand, without Docker.
# Uses unshare to start a shell in new PID, mount and UTS (hostname) namespaces.
# Needs root (sudo). Nothing permanent changes: everything disappears when the shell exits.
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This script needs Linux. On macOS/Windows, run it inside a Linux VM or WSL 2."
  exit 1
fi

if [[ "${EUID}" -ne 0 ]]; then
  echo "Please run with sudo:  sudo $0"
  exit 1
fi

if ! command -v unshare >/dev/null 2>&1; then
  echo "unshare not found. Install util-linux (e.g. sudo apt install util-linux)."
  exit 1
fi

echo "Host hostname:            $(hostname)"
echo "Processes the host sees:  $(ps -e --no-headers | wc -l)"
echo
echo "Starting a shell in new PID + mount + UTS namespaces..."
echo "------------------------------------------------------------"

# --pid --fork      : new process tree; the shell becomes PID 1
# --mount-proc      : mount a fresh /proc so ps only sees this tree
# --uts             : own hostname, separate from the host
unshare --pid --fork --mount-proc --uts bash -c '
  hostname mini-container
  echo "Inside hostname:          $(hostname)"
  echo "Processes visible inside:"
  ps -o pid,comm
  echo
  echo "Notice: bash is PID 1, and only this tree is visible."
'

echo "------------------------------------------------------------"
echo "Back on the host. Hostname is still: $(hostname)"
echo "That is the core idea of a container: a normal process with walls."
