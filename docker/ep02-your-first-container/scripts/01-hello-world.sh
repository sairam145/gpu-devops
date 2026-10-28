#!/usr/bin/env bash
# Episode 2, part 1 — Your first container: hello-world.
# Shows the image being pulled, the container running, and the container stopping
# as soon as its main process ends.
source "$(dirname "$0")/lib.sh"
require_docker

step "Run hello-world (first time: Docker pulls the image from Docker Hub)"
run docker run --label "$LABEL" hello-world
pause

step "Run it again: no download this time, the image is cached locally"
run docker run --label "$LABEL" hello-world
pause

step "Both containers ran, printed, and exited (STATUS: Exited (0))"
run docker ps -a --filter "label=$LABEL"
note "Rule: a container lives exactly as long as its main process."
