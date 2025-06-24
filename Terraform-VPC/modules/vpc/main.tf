resource "aws_vpc" "proj2" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = var.name
  }
}
resource "aws_subnet" "subnets" {
  count = length(var.subnets)
  vpc_id     = aws_vpc.proj2.id
  cidr_block = var.subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet-${count.index + 1}-proj2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.proj2.id

  tags = {
    Name = "igw-proj2"
  }
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.proj2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "routetable-1-proj2"
  }
}

resource "aws_route_table_association" "a" {
  count = length((var.subnets))
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.rt.id
}