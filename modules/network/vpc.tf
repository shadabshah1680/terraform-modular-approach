

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_config.vpc_cidr_block

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.vpc_config.public_subnet_cidr_blocks[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.vpc_config.public_subnet_cidr_blocks[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-public-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.vpc_config.private_subnet_cidr_blocks[0]

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.vpc_config.private_subnet_cidr_blocks[1]

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-private-subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-example-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-public-rt"
  }
}

resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-private-rt-1"
  }
}

resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-private-rt-2"
  }
}

resource "aws_route_table_association" "public_rt_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_2" {
subnet_id = aws_subnet.public_subnet_2.id
route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_1" {
subnet_id = aws_subnet.private_subnet_1.id
route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route_table_association" "private_rt_assoc_2" {
subnet_id = aws_subnet.private_subnet_2.id
route_table_id = aws_route_table.private_rt_2.id
}

output "vpc_id" {
value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
value = [
aws_subnet.public_subnet_1.id,
aws_subnet.public_subnet_2.id
]
}

output "private_subnet_ids" {
value = [
aws_subnet.private_subnet_1.id,
aws_subnet.private_subnet_2.id
]
}