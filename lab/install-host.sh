#!/bin/bash
# Lab host setup: Docker Engine (official apt repo) + Containerlab. Run with sudo.
set -euo pipefail

# Docker Engine - https://docs.docker.com/engine/install/ubuntu/
apt-get update
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker containerd

# docker group (user already a member; idempotent)
usermod -aG docker "${SUDO_USER:-bijan}"

# Containerlab - https://containerlab.dev/install/
bash -c "$(curl -sL https://get.containerlab.dev)"

echo "DONE: $(docker --version) | $(containerlab version 2>/dev/null | grep -i '^ *version')"
