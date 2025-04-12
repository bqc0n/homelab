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
