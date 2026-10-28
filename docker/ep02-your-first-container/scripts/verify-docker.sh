#!/usr/bin/env bash
# Episode 2 — Check that Docker is installed and working.
set -uo pipefail

ok()   { printf '\033[1;32m✔\033[0m %s\n' "$*"; }
bad()  { printf '\033[1;31m✘\033[0m %s\n' "$*"; }
FAIL=0

if command -v docker >/dev/null 2>&1; then
  ok "docker CLI found: $(docker --version)"
else
  bad "docker CLI not found — install Docker first (see README)."; exit 1
fi

if docker info >/dev/null 2>&1; then
  ok "Docker daemon is reachable (Client and Server both answer)"
else
  bad "Cannot reach the Docker daemon."
  if docker info 2>&1 | grep -qi "permission denied"; then
    echo "   Your user can't access /var/run/docker.sock."
    echo "   Fix: sudo usermod -aG docker \$USER  then log out/in (or: newgrp docker)"
  else
    echo "   Mac/Windows: start Docker Desktop.  Linux: sudo systemctl start docker"
  fi
  FAIL=1
fi

if [[ $FAIL -eq 0 ]]; then
  echo
  echo "--- docker version ---"
  docker version --format 'Client: {{.Client.Version}}   Server: {{.Server.Version}}'
  echo
  echo "--- quick test: docker run --rm hello-world ---"
  if docker run --rm hello-world >/dev/null 2>&1; then
    ok "hello-world ran successfully — you're ready for Episode 2"
  else
    bad "hello-world failed. Check your internet connection and run it manually to see the error:"
    echo "   docker run --rm hello-world"
    FAIL=1
  fi
fi
exit $FAIL
