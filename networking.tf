# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name    = "basic-vpc"
    Project = local.project
  }
}

# Create Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = local.zone

  tags = {
    Name    = "basic-subnet"
    Project = local.project
  }
}

# Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name    = "basic-igw"
    Project = local.project
  }
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    carrier_gateway_id = "0.0.0.0/0"
    gateway_id         = aws_internet_gateway.main.id
  }

  tags = {
    Name    = "basic-route-table"
    Project = local.project
  }
}

# Associate Route table with Subnet
resource "aws_route_table_association" "main" {
  route_table_id = aws_route_table.main.id
  subnet_id      = aws_subnet.main.id
}
