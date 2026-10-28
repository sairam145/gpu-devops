#!/usr/bin/env bash
# Episode 1 — See the Linux building blocks of containers on your own machine.
# Read-only: this script changes nothing. Linux (or WSL 2) only.
set -euo pipefail

section() { printf '\n\033[1;36m== %s ==\033[0m\n' "$1"; }

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This script needs Linux. On macOS/Windows, run it inside a Linux VM or WSL 2."
  exit 1
fi

section "1. The kernel every container on this machine would share"
uname -sr

section "2. PID 1 on the host (a container gets its OWN PID 1)"
ps -o pid,comm -p 1

section "3. How many processes the host can see"
echo "$(ps -e --no-headers | wc -l) processes visible from this shell"
echo "(Inside a container you'd typically see only 1 or 2.)"

section "4. Namespaces of this shell (/proc/self/ns)"
echo "Each line is one namespace. A container gets new ones for most of these."
ls -l /proc/self/ns | awk 'NR>1 {print "  " $9 " " $10 " " $11}'

if command -v lsns >/dev/null 2>&1; then
  section "5. Namespaces in use on this machine (lsns)"
  echo "Run with sudo to see every process's namespaces."
  lsns 2>/dev/null | head -n 15 || true
fi

section "6. The cgroup this shell belongs to"
cat /proc/self/cgroup

if [[ -f /sys/fs/cgroup/cgroup.controllers ]]; then
  section "7. Resources cgroups can limit on this machine (cgroup v2)"
  cat /sys/fs/cgroup/cgroup.controllers
fi

printf '\nDone. Namespaces = what a process can SEE. cgroups = what it can USE.\n'
