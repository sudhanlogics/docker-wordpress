#!/bin/bash

# ================================
# Docker Install Script for Ubuntu
# ================================

# 1. Update packages
sudo apt-get update

# 2. Install dependencies
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 3. Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 4. Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Install Docker Engine + Compose plugin
sudo apt-get update
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# 6. Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# 7. Add current user to docker group (no sudo needed)
sudo usermod -aG docker $USER

echo ""
echo "Docker installed successfully!"
echo "Run: newgrp docker   (to apply group change without logout)"
echo ""
docker --version
docker compose version
