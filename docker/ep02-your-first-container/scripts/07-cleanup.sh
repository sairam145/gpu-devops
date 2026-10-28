#!/usr/bin/env bash
# Episode 2, part 7 — Clean up and reclaim disk space.
# Step 1 removes ONLY the containers these scripts created (labeled gpu-devops=ep02).
# The prune steps affect your whole Docker setup, so they always ask first.
source "$(dirname "$0")/lib.sh"
require_docker

step "Remove the containers created by these scripts"
ids="$(docker ps -aq --filter "label=$LABEL")"
if [[ -n "$ids" ]]; then
  # shellcheck disable=SC2086
  run docker rm -f $ids
else
  echo "Nothing to remove."
fi
pause

step "What is using disk?"
run docker system df
pause

step "Images on this machine"
run docker images

echo
read -rp "Remove the demo images (hello-world, nginx, alpine, ubuntu)? [y/N] " ans
if [[ "$ans" =~ ^[Yy]$ ]]; then
  for img in hello-world "$NGINX_IMAGE" alpine ubuntu; do
    docker rmi "$img" 2>/dev/null && echo "removed $img" || echo "skipped $img (not present or in use)"
  done
fi

echo
note "docker system prune removes ALL stopped containers, unused networks, dangling images and build cache — not just this episode's."
read -rp "Run 'docker system prune' now? [y/N] " ans
if [[ "$ans" =~ ^[Yy]$ ]]; then
  run docker system prune -f
fi
note "Careful: 'docker system prune -a' also deletes every image not used by a container."
