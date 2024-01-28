#!/bin/bash

# Update the package list and upgrade existing packages
sudo yum update -y

# Install Python3 and Pip
sudo yum install python3 python3-pip -y

# Install Docker
sudo yum install docker -y

# Add the ec2-user to the Docker group
sudo usermod -a -G docker ec2-user

# Start the Docker service
sudo systemctl start docker

# Enable the Docker service to start on boot
sudo systemctl enable docker

# Output a message that the script is complete
echo "Installation complete. Docker has been added to the 'ec2-user' group and started."