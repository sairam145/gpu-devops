#!/usr/bin/env bash
# Episode 2, part 2 — Run a web server in the background.
#   -d           detached (background)
#   --name web   friendly name
#   -p 8080:80   HOST port 8080 -> CONTAINER port 80 (left side = your machine)
source "$(dirname "$0")/lib.sh"
require_docker
remove_demo_container "$NAME"

step "Start nginx in the background"
run docker run -d --name "$NAME" --label "$LABEL" -p "$PORT:80" "$NGINX_IMAGE"
wait_http "http://localhost:$PORT"
pause

step "Call it from the host"
printf '%s$ curl localhost:%s%s\n' "$C_CMD" "$PORT" "$C_OFF"
http_get "http://localhost:$PORT" | grep -i "<title>" || true
note "Open http://localhost:$PORT in your browser to see the nginx welcome page."
