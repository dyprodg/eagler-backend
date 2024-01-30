#!/bin/bash

# Update the package list
sudo apt-get update -y

# Upgrade existing packages
sudo apt-get upgrade -y

# Install Python3 and Pip
sudo apt-get install python3 python3-pip -y

# Install Docker using the convenience script provided by Docker
# This ensures you get the latest version of Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add the current user to the Docker group
# Replace 'ubuntu' with your actual username if it's different
sudo usermod -aG docker ubuntu

# Start the Docker service
sudo systemctl start docker

# Enable the Docker service to start on boot
sudo systemctl enable docker

# Output a message that the script is complete
echo "Installation complete. Docker has been added to the 'ubuntu' group and started."