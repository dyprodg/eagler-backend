variable "aws_region" {
  description = "Die AWS-Region, in der die Ressourcen erstellt werden"
  default     = "eu-central-1"
}

variable "source_bucket_name" {
  description = "Der Name des S3-Source-Buckets"
  default     = "eagler-pictures-source-bucket"
}

variable "target_bucket_name" {
  description = "Der Name des S3-Target-Buckets"
  default     = "eagler-pictures-target-bucket"
}

variable "lambda_function_name" {
  description = "Der Name der Lambda-Funktion"
  default     = "eagler-image_processor"
}

variable "docker_image_uri" {
  description = "URI des Docker-Images für die Lambda-Funktion"
  type        = string
  default     = "283919506801.dkr.ecr.eu-central-1.amazonaws.com/python-s3-eagler:latest"
}

variable "lambda_memory_size" {
  description = "Der Speicherplatz, der der Lambda-Funktion zugewiesen wird (in MB)"
  default     = 256
}

variable "lambda_timeout" {
  description = "Das Zeitlimit für die Lambda-Funktion (in Sekunden)"
  default     = 10
}

variable "lambda_handler" {
  description = "The handler of the Lambda function"
  default     = "function/lambda_function.lambda_handler"  # Updated the default value to match the file structure
}

variable "lambda_runtime" {
  description = "The runtime of the Lambda function"
  default     = "python3.11"
}

variable "lambda_architecture" {
  description = "The architecture of the Lambda function"
  default     = ["x86_64"]
}

variable "source_bucket_cors_allowed_origins" {
  description = "CORS erlaubte Ursprünge für den Source-Bucket"
  default     = ["*"]
}

variable "target_bucket_cors_allowed_origins" {
  description = "CORS erlaubte Ursprünge für den Target-Bucket"
  default     = ["*"]
}

variable "github_connection" {
  description = "The connection to GitHub"
  default     = "arn:aws:codestar-connections:eu-central-1:283919506801:connection/2eb166a7-605d-4e03-bb58-3c2d2af5da4e"
}

variable "github_repository" {
  description = "The GitHub repository"
  default     = "dyprodg/eagler-backend"
}

variable "github_branch" {
  description = "The GitHub branch"
  default     = "main"
}

variable "s3_artifact_bucket_name" {
  description = "The name of the S3 bucket for the CodePipeline artifact"
  default     = "eagler-artifact-image-processor"
}

variable "codebuild_compute_type" {
  description = "The compute type of the CodeBuild project"
  default     = "BUILD_LAMBDA_2GB"

}

variable "codebuild_image" {
  description = "The image of the CodeBuild project"
  default     = "aws/codebuild/amazonlinux-x86_64-lambda-standard:python3.11"

}

variable "codebuild_env_type" {
  description = "The environment type of the CodeBuild project"
  default     = "LINUX_LAMBDA_CONTAINER"
}

variable "build_log_group_name" {
  description = "The name of the CloudWatch Logs group"
  default     = "eagler-build-image-processor"
}

variable "build_log_stream_name" {
  description = "The name of the CloudWatch Logs stream"
  default     = "eagler-build-image-processor"
}

variable "build_project_name" {
  description = "The name of the CodeBuild project"
  default     = "eagler-build-image-proccessor"
}