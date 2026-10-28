# GPU DevOps

Hands-on code, scripts and slides for the **GPU DevOps** YouTube series: from your first container all the way to running GPU workloads on Kubernetes in the cloud.

Every video has a matching folder here with:

- a detailed **README** you can follow without watching the video,
- the **scripts** used on screen, ready to run,
- the **slides** shown in the video.

## Series roadmap

| Series | Folder | Status |
|---|---|---|
| Docker: Zero to GPU | [`docker/`](docker/) | In progress |
| Kubernetes: Zero to GPU | `kubernetes/` | Coming soon |
| AWS for DevOps | `aws/` | Coming soon |
| Terraform | `terraform/` | Coming soon |
| GPU DevOps (advanced) | `gpu/` | Coming soon |

Each series ends with GPU topics: GPU containers, GPU scheduling on Kubernetes, GPU instances on AWS, and GPU infrastructure as code.

## How to use this repo

```bash
git clone https://github.com/<your-username>/gpu-devops.git
cd gpu-devops/docker/ep02-your-first-container
cat README.md
```

Then follow the episode README from top to bottom. Scripts live in each episode's `scripts/` folder:

```bash
chmod +x scripts/*.sh
./scripts/verify-docker.sh
```

## Requirements

- A computer running Linux, macOS or Windows (WSL 2 recommended on Windows)
- A terminal
- Docker (installation is covered in [Docker Episode 2](docker/ep02-your-first-container/))

No cloud account or GPU is needed until the GPU episodes. Those will say clearly what hardware they need.

## Repository layout

```
gpu-devops/
├── README.md                          ← you are here
└── docker/
    ├── README.md                      ← Docker series index
    ├── ep01-why-containers-exist/
    │   ├── README.md
    │   ├── scripts/
    │   └── slides/
    └── ep02-your-first-container/
        ├── README.md
        ├── scripts/
        └── slides/
```

## Found a problem?

Open an issue with the episode number, your OS, and the full error message. Pull requests that fix typos or improve explanations are welcome.

## License

[MIT](LICENSE)
