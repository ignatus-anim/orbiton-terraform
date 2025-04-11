#!/bin/bash
# Update system
apt update -y
apt upgrade -y

# Install Docker
apt install -y docker.io
systemctl start docker
systemctl enable docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Install Nginx
apt install -y nginx
systemctl start nginx
systemctl enable nginx

# Pull and run the Docker image
docker pull ignatusa3/tiny-node-app:1.0
docker run -d -p 4000:4000 --name tiny-node-app ignatusa3/tiny-node-app:1.0

