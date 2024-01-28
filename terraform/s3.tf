# Source S3 Bucket
resource "aws_s3_bucket" "source_bucket" {
  bucket = var.source_bucket_name
}

resource "aws_s3_bucket_public_access_block" "source_bucket_public_access_block" {
  bucket = aws_s3_bucket.source_bucket.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "source_bucket_policy" {
  bucket = aws_s3_bucket.source_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*"
        Action    = [
          "s3:GetObject",
          "s3:PutObject",
        ]
        Resource  = "${aws_s3_bucket.source_bucket.arn}/*"
      },
    ]
  })
}



# Source S3 Bucket CORS (PUT Origins "*" for now)
resource "aws_s3_bucket_cors_configuration" "source_bucket_cors" {
  bucket = aws_s3_bucket.source_bucket.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT"]
    allowed_origins = var.source_bucket_cors_allowed_origins
    expose_headers  = ["ETag"]
    max_age_seconds = var.lambda_timeout
  }
}

# Target S3 Bucket
resource "aws_s3_bucket" "target_bucket" {
  bucket = var.target_bucket_name
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.target_bucket.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}


# Target S3 Bucket Policy (GET "*" any user needs access)
resource "aws_s3_bucket_policy" "target_bucket_policy" {
  bucket = aws_s3_bucket.target_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = [
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource  = "${aws_s3_bucket.target_bucket.arn}/*"
      },
    ],
  })
}

# Target S3 Bucket CORS (GET)
resource "aws_s3_bucket_cors_configuration" "target_bucket_cors" {
  bucket = aws_s3_bucket.target_bucket.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = var.target_bucket_cors_allowed_origins
    expose_headers  = []
    max_age_seconds = var.lambda_timeout
  }
}