resource "aws_launch_template" "main" {
  name_prefix   = "my-launch-template"
  # this is Canonical 220.04 Ubuntu AMI ID
  image_id      = "ami-0da9e85793f872825"
  instance_type = "t2.micro"
  key_name      = "fullstack-app-kp"

  vpc_security_group_ids = [aws_security_group.main.id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 10
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  monitoring = true

  iam_instance_profile {
    name = "my-instance-role"
  }

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  user_data = base64encode(<<EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd
  systemctl enable httpd
  systemctl start httpd
  EOF
  )
}