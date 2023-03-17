output "output" {
  value = {
    internet_gateway = aws_internet_gateway.igw
    public_subnets   = local.public_subnets
    private_subnets  = local.private_subnets
    vpc              = aws_vpc.vpc
  }
}
