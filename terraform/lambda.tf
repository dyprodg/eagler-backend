# Create the Lambda Function with Environment Variables
resource "aws_lambda_function" "image_lambda" {
  function_name    = var.lambda_function_name  
  role             = aws_iam_role.lambda_role.arn  
  handler          = var.lambda_handler  
  runtime          = var.lambda_runtime  
  architectures    = var.lambda_architecture  
  memory_size      = var.lambda_memory_size 
  filename         = "dummy.zip"  

  # Environment Variables
  environment {
    variables = {
      TARGET_BUCKET = aws_s3_bucket.target_bucket.id
    }
  }
    
  lifecycle {
    ignore_changes = [filename]
  }
}

# Configure the Notifications for the S3 Bucket
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.source_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ""
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}

# Add a Lambda permission resource to allow S3 to invoke the Lambda function
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source_bucket.arn
}

# IAM Role for the Lambda Function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

# IAM Policy for the Lambda Function
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "A policy that allows the Lambda function to access S3 buckets and CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Effect = "Allow",
        Resource = [
          "${aws_s3_bucket.source_bucket.arn}/*",
          "${aws_s3_bucket.target_bucket.arn}/*"
        ],
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      }
    ],
  })
}


# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}