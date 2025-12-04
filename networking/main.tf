resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "MyVPC"
    }

  
}
resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
    tags = {
        Name = "MyIG"
    }
  
}
resource "aws_route_table" "name" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.name.id
}
    tags = {
        Name = "MyRouteTable"
    }
}
resource "aws_subnet" "name-1" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "Subnet1-public"
    }
  
}
resource "aws_subnet" "name-2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1b"
  
    tags = {
        Name = "Subnet2-public"
    }
}
resource "aws_subnet" "name-3" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "Subnet3-public"
    }
  
}
resource "aws_subnet" "name-4" {
        vpc_id = aws_vpc.name.id
        cidr_block = "10.0.3.0/24"
        availability_zone = "ap-south-1b"   
        tags = {
            Name = "Subnet4-public"
        }
}
resource "aws_route_table_association" "public" {
  for_each = {
    subnet1 = aws_subnet.name-1.id
    subnet2 = aws_subnet.name-2.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.name.id
}

      

resource "aws_nat_gateway" "name" {
    allocation_id = aws_eip.name.id
    subnet_id = aws_subnet.name-1.id
    tags = {
        Name = "MyNATGateway"
    }
  
}
resource "aws_eip" "name" {

    tags = {
        Name = "MyEIP"
    }
  
}
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.name.id

  
}
    tags = {
        Name = "PrivateRouteTable"
    }
}
resource "aws_route_table_association" "private" {
  for_each = {
    subnet3 = aws_subnet.name-3.id
    subnet4 = aws_subnet.name-4.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "name" {
  name        = "my_custom_sg"
  description = "Custom security group"
  vpc_id      = aws_vpc.name.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my_custom_sg"
  }
}