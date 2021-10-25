provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "vpc_desafio" {
  cidr_block       = "10.10.0.0/22"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-desafio-gama-um"
  }
}

variable "range_ip" {
  type    = list(string)
  default = ["0", "8", "16"]
}

resource "aws_subnet" "sb_desafio" {

  for_each          = toset([var.range_ip])
  vpc_id            = aws_vpc.vpc_desafio.id
  cidr_block        = "10.10.0.${each.value}/24"
  availability_zone = "us-east-1a"
  #map_public_ip_on_launch = true

  tags = {
    Name = "sb-desafio-gama-um"
  }
}

resource "aws_internet_gateway" "igw_desafio" {
  vpc_id = aws_vpc.vpc_desafio.id

  tags = {
    Name = "igw-desafio-gama-um"
  }
}

resource "aws_route_table" "rt_desafio" {
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
    Name = "rt-desafio-gama-um"
  }
}

variable "subnet_ids_vpc"{
    type = list(string)
    default = [aws_vpc.vpc_desafio.subnet_ids]
}


resource "aws_route_table_association" "a" {

  for_each       = toset([var.subnet_ids_vpc])
  subnet_id      = "${each.value}"
  route_table_id = aws_route_table.rt_desafio.id
}



