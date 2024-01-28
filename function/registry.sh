#!/bin/bash

# Define vars
AWS_REGION="eu-central-1"
ECR_REPOSITORY_NAME="python-s3-eagler"
IMAGE_TAG="latest"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# Get AWS Account Number
if [ $? -ne 0 ]; then
    echo "Error retrieving AWS account number."
    exit 1
fi

# URI for ECR
ECR_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME"

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
if [ $? -ne 0 ]; then
    echo "Error logging into ECR."
    exit 1
fi

# Build Docker image
docker build -t $ECR_REPOSITORY_NAME .
if [ $? -ne 0 ]; then
    echo "Error building Docker image."
    exit 1
fi

# Tag Docker image
docker tag $ECR_REPOSITORY_NAME:latest $ECR_URI:$IMAGE_TAG
if [ $? -ne 0 ]; then
    echo "Error tagging Docker image."
    exit 1
fi

# Push Docker image to ECR
docker push $ECR_URI:$IMAGE_TAG
if [ $? -ne 0 ]; then
    echo "Error pushing Docker image to ECR."
    exit 1
fi

# Output the URI
echo "Pushed image: $ECR_URI:$IMAGE_TAG"