#!/usr/bin/env bash
# Episode 2, part 5 — Interactive containers, --rm, and the PID 1 rule.
source "$(dirname "$0")/lib.sh"
require_docker

step "A throwaway Alpine container: list its processes, then auto-delete (--rm)"
note "Interactive version from the video:  docker run -it --rm alpine sh   then type: ps"
run docker run --rm alpine ps
note "The command we ran is PID 1 — the PID namespace from Episode 1."
pause

step "Why does 'docker run ubuntu' exit immediately?"
run docker run --label "$LABEL" ubuntu
run docker ps -a --filter "label=$LABEL" --filter "ancestor=ubuntu" --format 'table {{.Image}}\t{{.Command}}\t{{.Status}}'
note "Its main process is bash. With no terminal attached (-it), bash has nothing to do and exits."
note "Main process ends -> container stops. Exit code 0 = it finished normally, it didn't crash."
