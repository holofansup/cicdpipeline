## This block to use terraform cloud
terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "MySlave"

    workspaces {
      name = "quypx_workflow"
    }
  }
}

provider "aws" {
  region = "ap-east-1"
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "server" {
  count = 2
  ami           = data.aws_ami.ami.id
  instance_type = "t3.micro"
  subnet_id = "subnet-0a3474edcf6593ef0"
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Server"
  }
}

output "public_ip" {
  value = aws_instance.server.*.public_ip
}