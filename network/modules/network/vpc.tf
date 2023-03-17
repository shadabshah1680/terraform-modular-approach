

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_config.vpc_cidr_block

  tags = {
    Name = "${var.project_name}-${terraform.workspace}-vpc"
  }
}

resource "aws_subnet" "public_subnets" {
  for_each = toset(var.vpc_config.public_subnet_cidr_blocks)

  map_public_ip_on_launch = true
  availability_zone = element(
    data.aws_availability_zones.available.names,
    index(var.vpc_config.public_subnet_cidr_blocks, each.key) % length(data.aws_availability_zones.available.names),
  )
  cidr_block = each.key
  vpc_id     = aws_vpc.vpc.id

  tags = merge(local.tags, { Name = "${var.project_name}-public-${index(var.vpc_config.public_subnet_cidr_blocks, each.key)}" }, { Tier = "Public" } )
}
resource "aws_subnet" "private_subnets" {
  for_each = toset(var.vpc_config.private_subnet_cidr_blocks)

  map_public_ip_on_launch = false
  availability_zone = element(
    data.aws_availability_zones.available.names,
    index(var.vpc_config.private_subnet_cidr_blocks, each.key) % length(data.aws_availability_zones.available.names),
  )
  cidr_block = each.key
  vpc_id     = aws_vpc.vpc.id

  tags = merge(local.tags, { Name = "${var.project_name}-private-${index(var.vpc_config.private_subnet_cidr_blocks, each.key)}" }, { Tier = "Private" } )
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.eip.id
  subnet_id     = local.private_subnets[0].id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.igw]
}
resource "aws_eip" "eip" {
  # subnet_id = aws_subnet.private_subnet_ids[0].id
  vpc      = true
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
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
  tags = {
    Name = "${var.project_name}-${terraform.workspace}-private-rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  for_each = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_assoc" {
  for_each = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}