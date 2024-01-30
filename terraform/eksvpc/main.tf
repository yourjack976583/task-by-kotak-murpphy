resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = merge({
    Name = format("%s-AWS-%s-%s-VPC", var.project, var.networks, var.env, )
  }, local.tags)
}


resource "aws_subnet" "public" {
  count                   = length(var.publicsubnet_id)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.publicsubnet_id[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true


  tags = merge({
    Name = format("%s-AWS-public-%s-%s-%s", var.project, var.networks, var.env, element(var.availability_zones, count.index))
  }, local.tag2name)
}
resource "aws_subnet" "private" {
   count                   = length(var.privatesubnet_id)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.privatesubnet_id[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true


  tags = merge({
    Name = format("%s-AWS-private-%s-%s-%s", var.project, var.networks, var.env, element(var.availability_zones, count.index))
  }, local.tag2name)
}


resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = merge({
    Name = format("%s-AWS-%s-%s-PUB-RT", var.project, var.networks, var.env, )
  }, local.tag2name)
}

resource "aws_route_table_association" "public" {
  count          = length(var.publicsubnet_id)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = merge({
    Name = format("%s-AWS-%s-%s-PVT-RT", var.project, var.networks, var.env, )
  }, local.tags)
}

resource "aws_route_table_association" "private" {
  count          = length(var.privatesubnet_id)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge({
    Name = format("%s-AWS-%s-%s-IGW", var.project, var.networks, var.env, )
  }, local.tags)
}


resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public[0].id
}


resource "aws_eip" "lb" {
  vpc = true
}
