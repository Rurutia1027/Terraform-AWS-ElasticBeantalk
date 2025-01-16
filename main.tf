terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.83.1"
    }
  }
}

# Provider Configuration
provider "aws" {
  region = "us-east-1" # Set the AWS region to US East (N. Virginia)
}


# --- AWS Elastic Beanstalk ---
## Application
resource "aws_elastic_beanstalk_application" "app" {
  name        = "fullstack-app"
  description = "A basic Elastic Beanstalk application"
}

# ## Environment
resource "aws_elastic_beanstalk_environment" "env" {
  name                = "fullstack-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.4.1 running Node.js 22"
  # solution_stack_name = "64bit Amazon Linux 2023 v4.4.2 running Docker"

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }
}
#
# ## App Deployment
# Elastic Beanstalk Application Version
resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = "v1"
  application = aws_elastic_beanstalk_application.app.name
  bucket      = aws_s3_bucket.bucket.id
  key         = aws_s3_bucket_object.app_version.key
}

output "url" {
  value = aws_elastic_beanstalk_environment.env.endpoint_url
}
