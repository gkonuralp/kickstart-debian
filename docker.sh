#!/bin/bash

# Uninstall old Docker versions
echo "Uninstalling old Docker versions..."
for pkg in docker docker-engine docker.io containerd runc; do
    if dpkg -l | grep -q "^ii  $pkg "; then
        sudo apt-get remove -y $pkg
    fi
done

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install prerequisites
echo "Installing prerequisites..."
PREREQS="ca-certificates curl gnupg lsb-release"
for pkg in $PREREQS; do
    if ! dpkg -l | grep -q "^ii  $pkg "; then
        sudo apt-get install -y $pkg
    fi
done

# Add Docker's official GPG key
echo "Adding Docker's GPG key..."
if [ ! -f /etc/apt/keyrings/docker.asc ]; then
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
fi

# Add Docker APT repository
echo "Adding Docker APT repository..."
if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

# Update package list again
sudo apt-get update

# Install Docker packages
echo "Installing Docker..."
DOCKER_PKGS="docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
if command -v docker >/dev/null 2>&1; then
    echo "Docker is already installed."
else
    sudo apt-get install -y $DOCKER_PKGS
fi

# Add current user to docker group
echo "Adding user to docker group..."
if ! groups $USER | grep -q docker; then
    sudo usermod -aG docker $USER
    echo "User added to docker group. You will need to log out and back in for this to take effect."
fi

# Start and enable Docker service
echo "Starting and enabling Docker service..."
if ! systemctl is-active --quiet docker; then
    sudo systemctl start docker
fi
sudo systemctl enable docker

echo "Docker installation complete. Log out and log back in, or run 'newgrp docker' to start using Docker without sudo."
