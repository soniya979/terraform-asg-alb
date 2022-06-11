#create VPC

resource "aws_vpc" "mumbaivpc01" {
  cidr_block       = "10.0.0.0/16" var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "mumbaivpc01"
  }
}

# create IGW

resource "aws_internet_gateway" "mumbaiigw" {
  vpc_id = aws_vpc.mumbaivpc01.id

  tags = {
    Name = "mumbaiigw"
  }
}

#for HA create subnets in different AZs

#create subnets in 'ap-south-1a'

resource "aws_subnet" "pubsn01" {
  vpc_id     = aws_vpc.mumbaivpc01.id
  cidr_block = "10.0.0.0/24"    # var.subnet01_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = "pubsn01"
  }
}

resource "aws_subnet" "pvtsn01" {
  vpc_id     = aws_vpc.mumbaivpc01.id
  cidr_block = "10.0.1.0/24"    # var.subnet01_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = "pvtsn01"
  }
}

#create subnets in 'ap-south-1b'

resource "aws_subnet" "pubsn02" {
  vpc_id     = aws_vpc.mumbaivpc01.id
  cidr_block = "10.0.2.0/24"    # var.subnet01_cidr
  availability_zone = "ap-south-1b"

  tags = {
    Name = "pubsn02"
  }
}

resource "aws_subnet" "pvtsn02" {
  vpc_id     = aws_vpc.mumbaivpc01.id
  cidr_block = "10.0.3.0/24"    # var.subnet01_cidr
  availability_zone = "ap-south-1b"

  tags = {
    Name = "pvtsn02"
  }
}

#create public route_tabel

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.mumbaivpc01.id

  tags = {
    Name = "public-rt"
  }
}

# Associate public subnets to public route tabel

resource "aws_route_table_association" "pubrtasso01" {
  subnet_id      = aws_subnet.pubsn01.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_route_table_association" "pubrtasso02" {
  subnet_id      = aws_subnet.pubsn02.id
  route_table_id = aws_route_table.pubrt.id
}

#  route for interney gateway

resource "aws_route" "publicsnroute" {
  route_table_id = aws_route_table.pubrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id  = aws_internet_gateway.mumbaiigw.id
}

#create Elastic_ip

resource "aws_eip" "mumbaieip" {
  vpc = true
  depends_on = [aws_internet_gateway.mumbaiigw]
}

#create Nat-gateway to access private subnets

resource "aws_nat_gateway" "mumbainatgw" {
  allocation_id = aws_eip.mumbaieip.id
  subnet_id = aws_subnet.pubsn01.id
  depends_on = [aws_internet_gateway.mumbaiigw]
}

#create private-route_tabel

resource "aws_route_table" "pvtrt" {
  vpc_id = aws_vpc.mumbaivpc01.id

  tags = {
    Name = "pvtrt"
  }
}

#Associate private subnets to private route tabel

resource "aws_route_table_association" "pvtrtasso01" {
  subnet_id      = aws_subnet.pvtsn01.id
  route_table_id = aws_route_table.pvtrt.id
}

resource "aws_route_table_association" "pvtrtasso02" {
  subnet_id      = aws_subnet.pvtsn02.id
  route_table_id = aws_route_table.pvtrt.id
}

#add route for nat-gateway

resource "aws_route" "privatesnroute" {
  route_table_id = aws_route_table.pvtrt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.mumbainatgw.id
}
