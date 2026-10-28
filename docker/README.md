# Docker: Zero to GPU

A complete Docker course, from "what is a container?" to building production GPU container images for AI workloads. No prior Docker experience needed.

## Episodes

| # | Episode | What you learn | Folder |
|---|---|---|---|
| 1 | Why containers exist | VMs vs containers, namespaces, cgroups, image vs container | [ep01](ep01-why-containers-exist/) |
| 2 | Your first container | Install Docker, run, ps, logs, exec, stop, rm, prune | [ep02](ep02-your-first-container/) |
| 3 | Images and registries | Layers, tags vs digests, Docker Hub, push and pull | Coming soon |
| 4 | Your first Dockerfile | FROM, RUN, COPY, CMD, build cache | Coming soon |
| 5 | Volumes and bind mounts | Persisting data | Coming soon |
| 6 | Networking | Bridge, host, port mapping, container DNS | Coming soon |
| 7 | Docker Compose | Multi-container apps | Coming soon |
| 8 | Dockerfile optimization | Multi-stage builds, slim and distroless images | Coming soon |
| 9 | Config and secrets | Env vars, build args, BuildKit secrets | Coming soon |
| 10 | Debugging containers | inspect, stats, exit codes | Coming soon |
| 11 | Resource limits | CPU and memory limits, OOM kills, restart policies | Coming soon |
| 12 | Container security | Non-root users, image scanning, SBOMs | Coming soon |
| 13 | BuildKit and buildx | Multi-arch builds, cache mounts | Coming soon |
| 14 | Docker internals | Build a "container" by hand with namespaces | Coming soon |
| 15 | CI/CD | Build, scan and push with GitHub Actions | Coming soon |
| 16–19 | GPU containers | NVIDIA Container Toolkit, CUDA images, GPU serving | Coming soon |

## How each episode folder works

```
epNN-topic/
├── README.md     ← full written walkthrough of the episode
├── scripts/      ← every command from the video, as runnable scripts
└── slides/       ← the slide deck shown in the video
```

Read the README first. The scripts are there so you can repeat the demos without copying commands by hand.
