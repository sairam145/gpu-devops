#!/usr/bin/env bash
# Episode 2, part 3 — See what's running, walk the lifecycle, read logs.
# Run 02-run-nginx.sh first.
source "$(dirname "$0")/lib.sh"
require_docker
docker container inspect "$NAME" >/dev/null 2>&1 || { echo "Run ./02-run-nginx.sh first."; exit 1; }

step "Running containers only"
run docker ps
pause

step "All containers, including stopped ones"
run docker ps -a
pause

step "Lifecycle: stop -> it disappears from 'docker ps' but still exists"
run docker stop "$NAME"
run docker ps -a --filter "name=^${NAME}$"
pause

step "Start the SAME container again"
run docker start "$NAME"
wait_http "http://localhost:$PORT"
pause

step "Make a few requests so there is something in the logs"
for _ in 1 2 3; do http_get "http://localhost:$PORT" >/dev/null; done
echo "(sent 3 requests)"

step "Logs = everything the main process writes to stdout/stderr"
run docker logs --tail 10 "$NAME"
pause

step "With timestamps"
run docker logs -t --tail 3 "$NAME"
note "Follow live with: docker logs -f $NAME   (Ctrl+C stops following, not the container)"
