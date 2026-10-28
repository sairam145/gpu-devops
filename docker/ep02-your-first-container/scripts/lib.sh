#!/usr/bin/env bash
# Shared helpers for the Episode 2 scripts. Sourced, not run directly.
set -euo pipefail

# Everything these scripts create is labeled, so cleanup never touches your own containers.
LABEL="gpu-devops=ep02"
NAME="${NAME:-web}"                 # container name used in the video
PORT="${PORT:-8080}"                # host port; change if 8080 is busy: PORT=8081 ./02-run-nginx.sh
NGINX_IMAGE="${NGINX_IMAGE:-nginx}" # Episode 3 explains why you should pin a tag, e.g. nginx:1.27

C_CMD=$'\033[1;32m'; C_STEP=$'\033[1;36m'; C_WARN=$'\033[1;33m'; C_OFF=$'\033[0m'

step()  { printf '\n%s== %s ==%s\n' "$C_STEP" "$*" "$C_OFF"; }
note()  { printf '%s%s%s\n' "$C_WARN" "$*" "$C_OFF"; }
# Print a command like a terminal prompt, then run it.
run() {
  local out="" a
  for a in "$@"; do
    if [[ "$a" =~ [[:space:]\"\$\>\{\}\*\'] ]]; then out+=" '${a//\'/\'\\\'\'}'"; else out+=" $a"; fi
  done
  printf '%s$%s%s\n' "$C_CMD" "$out" "$C_OFF"
  "$@"
}
# Pause between steps when run interactively. Skip with NO_PAUSE=1.
pause() { if [[ "${NO_PAUSE:-0}" != "1" && -t 0 ]]; then read -rp "Press Enter to continue..." _; fi; }

require_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is not installed. See ./install-docker-linux.sh or the README."; exit 1
  fi
  if ! docker info >/dev/null 2>&1; then
    echo "Docker is installed but the daemon is not reachable."
    echo "  Mac/Windows: start Docker Desktop."
    echo "  Linux:       sudo systemctl start docker"
    echo "  'permission denied'? Add yourself to the docker group (see README)."
    exit 1
  fi
}

http_get() {
  if command -v curl >/dev/null 2>&1; then curl -s "$1"; else wget -qO- "$1"; fi
}

wait_http() {
  local url="$1"
  for _ in $(seq 1 30); do
    if http_get "$url" >/dev/null 2>&1; then return 0; fi
    sleep 0.5
  done
  echo "Timed out waiting for $url"; return 1
}

# Remove our demo container if it exists. Refuse to touch a container we didn't create.
remove_demo_container() {
  local name="$1"
  if docker container inspect "$name" >/dev/null 2>&1; then
    if [[ "$(docker container inspect -f '{{index .Config.Labels "gpu-devops"}}' "$name")" == "ep02" ]]; then
      docker rm -f "$name" >/dev/null
    else
      echo "A container named '$name' already exists and was not created by these scripts."
      echo "Remove it yourself (docker rm -f $name) or use another name: NAME=web2 $0"
      exit 1
    fi
  fi
}
