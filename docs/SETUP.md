# Lab Host Setup

Host environment for the capstone Containerlab network (FRR routers + vulnerable containers).
Set up on 2026-10-11. Environment only: no topology, router config, or application code yet.

## Host

| Item | Value |
|---|---|
| Windows | Windows 11 Home 10.0.26200 |
| WSL | WSL2, distro **Ubuntu-22.04** (Ubuntu 22.04.5 LTS), the default distro |
| Kernel | 6.6.87.2-microsoft-standard-WSL2 |
| systemd | Enabled (`/etc/wsl.conf`: `[boot] systemd=true`). It was already on, so no change was made. |
| RAM / swap | 7.6 GiB / 2.0 GiB (WSL default; `.wslconfig` was left as it was) |
| CPUs / disk | 28 vCPU / ~954 GB free on `/` |
| Lab directory | `~/capstone` (Linux filesystem, not `/mnt/c`) |

## Installed

| Component | Version | Method |
|---|---|---|
| Docker Engine (client + server) | 29.9.0 | Official Docker apt repo (`download.docker.com/linux/ubuntu jammy stable`): `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin` |
| Docker storage / cgroups | overlayfs (containerd image store), systemd cgroup driver, cgroup v2 | Default |
| Containerlab | 0.80.0 (commit 492d56f6a, 2026-10-09) | Official installer, `bash -c "$(curl -sL https://get.containerlab.dev)"` |

The install script is kept at `lab/install-host.sh`.

Docker Desktop is still installed on Windows but is **not** used here. Its WSL integration is turned off for Ubuntu-22.04. `docker` resolves to `/usr/bin/docker`, which is the native engine.

## Images

All images are `linux/amd64`. A digest pins the exact image content regardless of what the tag later points to.

| Image:tag | Digest |
|---|---|
| `quay.io/frrouting/frr:10.7.1` | `sha256:e995beaa50fdc9edb35eadcfefa29b7f062cc06f2b812613789b68fa541554d2` |
| `tleemcjr/metasploitable2:latest` | `sha256:e559450b37dccc1909eafa2df5b20bb052e1bd801246f4539a3ef183d5f7288a` |
| `vulnerables/web-dvwa:latest` | `sha256:dae203fe11646a86937bf04db0079adef295f426da68a92b40e3b181f337daa7` |
| `vulhub/httpd:2.4.49` | `sha256:a6c32432b1ed40818488e238769e962a4151ef3b74b54416d9d5d396ba8cab5f` |
| `nicolaka/netshoot:v0.16` | `sha256:b09d9b21381f47a79b3cbcb30da25266dc17186ea00ae65e99fdc51396f48e70` |

To pull an exact image by digest, use `image@sha256:...`, for example
`docker pull vulnerables/web-dvwa@sha256:dae203fe11646a86937bf04db0079adef295f426da68a92b40e3b181f337daa7`.

### Tag choices

- **FRR 10.7.1**: newest stable release on quay.io. There is also a `containerlab-10.7.1` tag; it was not pulled.
- **metasploitable2 `latest`**: the only tag that exists (2018 build). The digest above is what pins it.
- **DVWA `latest`**: the only other tag is `1.9`, a Jan 2017 build. `latest` is a newer Oct 2018 build. I chose `latest`, and the digest above pins it.
- **httpd 2.4.49**: the version vulnerable to CVE-2021-41773.
- **netshoot v0.16**: newest release.
- None of the image names had changed; all five resolved as given.

## Done manually by the user

1. Turned off Docker Desktop WSL integration for Ubuntu-22.04.
2. Ran `sudo bash lab/install-host.sh`, because sudo needs a password.
3. Added themselves to the `clab_admins` group, which Containerlab uses to allow running without sudo.

No `wsl --shutdown` was needed. The user was already in the `docker` group.

## Verification (2026-10-11)

- `docker run --rm hello-world`: printed "Hello from Docker!" when run without sudo.
- `containerlab version`: 0.80.0.
- `docker version`: client and server both 29.9.0.
- `id` shows the groups `docker` (1001) and `clab_admins` (999).
- `free -h`: 7.6 GiB total, 6.3 GiB available.

## Notes

- RAM is tight. metasploitable2 + DVWA + httpd + several FRR nodes may use most of the 7.6 GiB. Check with `docker stats` when the lab is running.
- Keep all lab files under `~/capstone`. Bind mounts from `/mnt/c` or OneDrive cause permission and performance problems.
