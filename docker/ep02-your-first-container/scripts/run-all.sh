#!/usr/bin/env bash
# Episode 2 — Run every demo in order, pausing between steps.
# Non-stop mode:  NO_PAUSE=1 ./run-all.sh
set -euo pipefail
cd "$(dirname "$0")"
for s in 01-hello-world.sh 02-run-nginx.sh 03-inspect.sh 04-exec.sh 05-interactive.sh 06-stop-kill-rm.sh 08-common-errors.sh 07-cleanup.sh; do
  printf '\n\033[1;35m##### %s #####\033[0m\n' "$s"
  ./"$s"
done
