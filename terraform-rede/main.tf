provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "vpc_desafio" {
  cidr_block       = "10.10.0.0/22"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-desafio-gama-um"
  }
}


#=====================SUBNETS publicas
resource "aws_subnet" "sb_desafio_1a" {
  vpc_id            = aws_vpc.vpc_desafio.id
  cidr_block        = "10.10.0.8/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "sb1a-pb-desafio-gama-um"
  }

}

resource "aws_subnet" "sb_desafio_1b" {
  vpc_id            = aws_vpc.vpc_desafio.id
  cidr_block        = "10.10.0.16/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "sb1b-pb-desafio-gama-um"
  }
}
#=====================SUBNETS publicas

#=====================SUBNET privada
resource "aws_subnet" "sb_desafio_1c" {
  vpc_id            = aws_vpc.vpc_desafio.id
  cidr_block        = "10.10.0.16/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = false
  
  tags = {
    Name = "sb1c-pv-desafio-gama-um"
  }

}
#=====================SUBNET privada

resource "aws_internet_gateway" "igw_desafio" {
  vpc_id = aws_vpc.vpc_desafio.id

  tags = {
    Name = "igw-desafio-gama-um"
  }
}

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

resource "aws_nat_gateway" "ntg_desafio" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = aws_subnet.sb_desafio_1c.id
  depends_on    = [aws_internet_gateway.igw_desafio]
 
  tags = {
    Name        =  "ntg-desafio-gama-um"
  }
}

resource "aws_route_table" "rt_pb__desafio" {
  vpc_id = aws_vpc.vpc_desafio.id

  route = [
    {
      carrier_gateway_id         = ""
      cidr_block                 = "0.0.0.0/0"
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = aws_internet_gateway.igw_desafio.id
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    }
  ]

  tags = {
    Name = "rt-pb-desafio-gama-um"
  }
}

resource "aws_route_table" "rt_pv__desafio" {
  vpc_id = aws_vpc.vpc_desafio.id

  route = [
    {
      carrier_gateway_id         = ""
      cidr_block                 = "0.0.0.0/0"
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             =  
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    }
  ]

  tags = {
    Name = "rt-pv-desafio-gama-um"
  }
}

resource "aws_route_table_association" "1a" {
 
  subnet_id      = aws_subnet.sb_desafio_1a.id
  route_table_id = aws_route_table.rt_desafio.id
}

resource "aws_route_table_association" "1b" {
 
  subnet_id      = aws_subnet.sb_desafio_1b.id
  route_table_id = aws_route_table.rt_desafio.id
}

