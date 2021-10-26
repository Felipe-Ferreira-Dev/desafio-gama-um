provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2_db_dev" {
  ami                         = "ami-09e67e426f25ce0d7"
  instance_type               = "t2.micro"
  key_name                    = "id_rsa_jenkins"
  subnet_id                   = "subnet-02dd0ed058fa41755"
  associate_public_ip_address = true
  root_block_device {
    encrypted   = true
    volume_size = 20
  }
   
  tags = {
    Name = "ec2-db-dev"
  }
  vpc_security_group_ids = ["${aws_security_group.sg_db.id}"]
}

resource "aws_instance" "ec2_db_stage" {
  ami                         = "ami-09e67e426f25ce0d7"
  instance_type               = "t2.medium"
  key_name                    = "id_rsa_jenkins"
  subnet_id                   = "subnet-02dd0ed058fa41755"
  associate_public_ip_address = true
  root_block_device {
    encrypted   = true
    volume_size = 20
  }
   
  tags = {
    Name = "ec2-db-stage"
  }
  vpc_security_group_ids = ["${aws_security_group.sg_db.id}"]
}

resource "aws_instance" "ec2_db_prod" {
  ami                         = "ami-09e67e426f25ce0d7"
  instance_type               = "t2.large"
  key_name                    = "id_rsa_jenkins"
  subnet_id                   = "subnet-02dd0ed058fa41755"
  associate_public_ip_address = true
  root_block_device {
    encrypted   = true
    volume_size = 20
  }
   
  tags = {
    Name = "ec2-db-prod"
  }
  vpc_security_group_ids = ["${aws_security_group.sg_db.id}"]
}

resource "aws_security_group" "sg_db" {
  name        = "sg_db"
  description = "sg mysql and ssh inbound traffic"
  vpc_id      = "vpc-08e4ed3899b973f28"

  ingress = [
    {
      cidr_blocks = ["0.0.0.0/0"]
      description      = "SSH from VPC"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks      = ""
      description      = "Mysql"
      from_port        = 3306
      to_port          = 3306
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = ["sg-010d4de15095a15a6"]
      self             = false
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids  = null,
      security_groups : null,
      self : null,
      description : "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "sg_db"
  }
}

# terraform refresh para mostrar o ssh
output "output_ec2_dev" {
  value = [
    "ec2-db-dev",
    "id: ${aws_instance.ec2_db_dev.id}",
    "private: ${aws_instance.ec2_db_dev.private_ip}",
    "public_ip: ${aws_instance.ec2_db_dev.public_ip}",
    "public_dns: ${aws_instance.ec2_db_dev.public_dns}",
    "ssh -i ssh -i ~/.ssh/id_rsa_itau ubuntu@${aws_instance.ec2_db_dev.public_dns}"
  ]
}

# terraform refresh para mostrar o ssh
output "output_ec2_stage" {
  value = [
    "ec2-db-stage",
    "id: ${aws_instance.ec2_db_stage.id}",
    "private: ${aws_instance.ec2_db_stage.private_ip}",
    "public_ip: ${aws_instance.ec2_db_stage.public_ip}",
    "public_dns: ${aws_instance.ec2_db_stage.public_dns}",
    "ssh -i ssh -i ~/.ssh/id_rsa_itau ubuntu@${aws_instance.ec2_db_stage.public_dns}"
  ]
}

ec2_db_prod
# terraform refresh para mostrar o ssh
output "output_ec2_prod" {
  value = [
    "ec2-db-prod",
    "id: ${aws_instance.ec2_db_prod.id}",
    "private: ${aws_instance.ec2_db_prod.private_ip}",
    "public_ip: ${aws_instance.ec2_db_prod.public_ip}",
    "public_dns: ${aws_instance.ec2_db_prod.public_dns}",
    "ssh -i ssh -i ~/.ssh/id_rsa_itau ubuntu@${aws_instance.ec2_db_prod.public_dns}"
  ]
}


