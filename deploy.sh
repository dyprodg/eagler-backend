#!/bin/bash

# Navigate to the function directory
cd function

# Execute the script to register and upload the Docker image
IMAGE_URI=$(./registry.sh | grep 'Pushed image:' | awk '{print $3}')

# Check if the image was successfully pushed
if [ -z "$IMAGE_URI" ]; then
    echo "Error uploading the Docker image."
    exit 1
fi

echo "Docker image successfully pushed: $IMAGE_URI"

# Return to the root directory
cd ..

# Update the Terraform variables file with the new image URI
sed -i '' "s#\(variable \"docker_image_uri\".*default *= *\"\)[^\"]*\"#\1$IMAGE_URI\"#" terraform/variables.tf

# Navigate to the Terraform directory
cd terraform

# Execute Terraform commands
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve

echo "Deployment completed."