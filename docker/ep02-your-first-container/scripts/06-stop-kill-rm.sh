#!/usr/bin/env bash
# Episode 2, part 6 — stop vs kill vs rm, and proof that container changes don't survive.
# Run 02-run-nginx.sh and 04-exec.sh first to see the full effect.
source "$(dirname "$0")/lib.sh"
require_docker

step "docker stop: SIGTERM, wait up to 10s, then SIGKILL (graceful)"
if ! docker container inspect "$NAME" >/dev/null 2>&1; then
  docker run -d --name "$NAME" --label "$LABEL" -p "$PORT:80" "$NGINX_IMAGE" >/dev/null
  wait_http "http://localhost:$PORT"
fi
printf '%s$ time docker stop %s%s\n' "$C_CMD" "$NAME" "$C_OFF"
time docker stop "$NAME"
pause

step "docker kill: SIGKILL immediately (start it first, then kill)"
run docker start "$NAME"
run docker kill "$NAME"
pause

step "docker rm -f: stop (if needed) and delete the container + its writable layer"
run docker rm -f "$NAME"
pause

step "Recreate it with the exact same command"
run docker run -d --name "$NAME" --label "$LABEL" -p "$PORT:80" "$NGINX_IMAGE"
wait_http "http://localhost:$PORT"
printf '%s$ curl localhost:%s%s\n' "$C_CMD" "$PORT" "$C_OFF"
http_get "http://localhost:$PORT" | grep -i "<title>" || true
note "Back to the default nginx page: changes inside a container die with the container."
note "To keep data, use volumes (Episode 5)."
