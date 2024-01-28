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


variable "source_bucket_cors_allowed_origins" {
  description = "CORS erlaubte Ursprünge für den Source-Bucket"
  default     = ["*"]
}

variable "target_bucket_cors_allowed_origins" {
  description = "CORS erlaubte Ursprünge für den Target-Bucket"
  default     = ["*"]
}
