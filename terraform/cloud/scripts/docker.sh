#!/bin/bash

# Swap settings
sudo fallocate -l 4G /swapfile2
sudo chmod 600 /swapfile2
sudo mkswap /swapfile2
sudo swapon /swapfile2
sudo echo "/swapfile2 none swap nw 0 0" | sudo tee /etc/fstab

# Update pkgs
sudo dnf check-update
sudo dnf update -y

# Docker
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker

# SELinux TODO: SELinuをちゃんと設定
sudo setenforce 0

# Gatus
curl https://raw.githubusercontent.com/bqc0n/homelab/refs/heads/main/files/oci-docker-compose.yaml -o /home/opc/compose.yaml
sudo curl https://raw.githubusercontent.com/bqc0n/homelab/refs/heads/main/files/gatus.yaml -o /etc/gatus.yaml
sudo docker compose -f /home/opc/compose.yaml up -d
