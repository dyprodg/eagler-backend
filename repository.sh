#!/bin/bash

AWS_REGION="eu-central-1"
ECR_REPOSITORY_NAME="python-s3-eagler"

# Create an ECR repository
aws ecr create-repository --repository-name $ECR_REPOSITORY_NAME --region $AWS_REGION

echo "ECR repository $ECR_REPOSITORY_NAME created."