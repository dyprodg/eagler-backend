output "source_bucket_arn" {
  value       = aws_s3_bucket.source_bucket.arn
  description = "ARN des S3-Source-Buckets"
}

output "target_bucket_arn" {
  value       = aws_s3_bucket.target_bucket.arn
  description = "ARN des S3-Target-Buckets"
}

output "lambda_function_arn" {
  value       = aws_lambda_function.image_lambda.arn
  description = "ARN der Lambda-Funktion"
}
