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
docker pull ${container_image}
docker run -d -p ${container_port}:${container_port} --name tiny-node-app ${container_image}

