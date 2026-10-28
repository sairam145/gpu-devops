#!/usr/bin/env bash
# Episode 2 — Install Docker Engine on Linux using Docker's convenience script.
# Good for learning and test machines. For production servers, install from Docker's
# apt/yum repository instead so you control versions: https://docs.docker.com/engine/install/
# Mac/Windows: install Docker Desktop instead (https://docs.docker.com/desktop/).
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This script is for Linux. On Mac/Windows install Docker Desktop."; exit 1
fi

if command -v docker >/dev/null 2>&1; then
  echo "Docker is already installed: $(docker --version)"
else
  echo "Downloading Docker's install script..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  echo "Running it with sudo (you may be asked for your password)..."
  sudo sh get-docker.sh
  rm -f get-docker.sh
fi

# Make sure the daemon is running and starts on boot (systemd distros).
if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl enable --now docker || true
fi

# Run docker without sudo.
# SECURITY NOTE: members of the docker group effectively have root access on this machine.
if id -nG "$USER" | grep -qw docker; then
  echo "User '$USER' is already in the docker group."
else
  read -rp "Add '$USER' to the docker group so you can run docker without sudo? [y/N] " ans
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    sudo usermod -aG docker "$USER"
    echo "Done. Log out and back in (or run: newgrp docker) for this to take effect."
  fi
fi

echo
echo "Next: ./verify-docker.sh"
