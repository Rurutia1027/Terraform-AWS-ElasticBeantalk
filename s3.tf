# We apply S3 bucket for caching local app/ 's deploy package

# here we create a random string generator for generating random suffix for S3 bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 6
}

# S3 bucket for Application Deployment
resource "aws_s3_bucket" "bucket" {
  bucket = "fullstack-app-deploy-${random_id.bucket_suffix.hex}"
}


resource "aws_s3_bucket_object" "app_version" {
  bucket = aws_s3_bucket.bucket.id
  key    = "index.zip"
  source = "${path.module}/app/index.zip"
}


output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}