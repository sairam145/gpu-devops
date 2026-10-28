#!/usr/bin/env bash
# Episode 2, part 8 — Reproduce two common errors on purpose, then fix them.
# Uses its own container names (err-demo-*) and cleans up after itself.
source "$(dirname "$0")/lib.sh"
require_docker
ERR_PORT="${ERR_PORT:-8090}"

cleanup() { docker rm -f err-demo-a err-demo-b >/dev/null 2>&1 || true; }
trap cleanup EXIT
cleanup

step "Error 1: 'port is already allocated'"
run docker run -d --name err-demo-a --label "$LABEL" -p "$ERR_PORT:80" "$NGINX_IMAGE"
note "Now a second container tries to use the same HOST port..."
printf '%s$ docker run -d --name err-demo-b -p %s:80 %s%s\n' "$C_CMD" "$ERR_PORT" "$NGINX_IMAGE" "$C_OFF"
docker run -d --name err-demo-b --label "$LABEL" -p "$ERR_PORT:80" "$NGINX_IMAGE" 2>&1 | grep -i -m1 "error" || true
docker rm -f err-demo-b >/dev/null 2>&1 || true
note "Fix: pick another host port (left side), e.g. -p $((ERR_PORT + 1)):80"
run docker run -d --name err-demo-b --label "$LABEL" -p "$((ERR_PORT + 1)):80" "$NGINX_IMAGE"
pause

step "Error 2: 'The container name is already in use'"
run docker stop err-demo-a
printf '%s$ docker run -d --name err-demo-a %s%s\n' "$C_CMD" "$NGINX_IMAGE" "$C_OFF"
docker run -d --name err-demo-a "$NGINX_IMAGE" 2>&1 | grep -i -m1 "error" || true
note "Names stay taken even by STOPPED containers. Fix: docker rm err-demo-a, then run again."
pause

step "Error 3: 'permission denied ... docker.sock'  (not reproduced here)"
note "Your user isn't in the docker group. Fix: sudo usermod -aG docker \$USER, then log out/in."

step "Error 4: 'my container exits right away'"
note "Its main process ended. Check:  docker ps -a  (exit code)  and  docker logs <name>  (why)."
echo
echo "Cleaning up err-demo containers..."
