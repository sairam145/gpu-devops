#!/usr/bin/env bash
# Episode 2, part 4 — Run commands inside a running container with docker exec.
# In the video we use an interactive shell:  docker exec -it web bash
# This script runs the same commands one at a time so you can repeat the demo.
source "$(dirname "$0")/lib.sh"
require_docker
docker container inspect "$NAME" >/dev/null 2>&1 || { echo "Run ./02-run-nginx.sh first."; exit 1; }

step "Hostname inside = the container ID (UTS namespace)"
run docker exec "$NAME" hostname
run docker ps --filter "name=^${NAME}$" --format 'Container ID: {{.ID}}'
pause

step "The OS inside the container (the image's OS, not yours)"
run docker exec "$NAME" sh -c 'grep PRETTY_NAME /etc/os-release'
pause

step "Change the page nginx serves — inside the running container"
run docker exec "$NAME" sh -c 'echo "Hello from inside" > /usr/share/nginx/html/index.html'
printf '%s$ curl localhost:%s%s\n' "$C_CMD" "$PORT" "$C_OFF"
http_get "http://localhost:$PORT"
echo
note "This change lives only in this container's writable layer. 06-stop-kill-rm.sh proves it."
note "Try the interactive version yourself:  docker exec -it $NAME bash   (type exit to leave)"
