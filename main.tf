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
  region = "us-west-2"
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
  ami           = data.aws_ami.ami.id
  instance_type = "t3.micro"
  subnet_id = "subnet-020f103c777289171"
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Server"
  }
}

output "public_ip" {
  value = aws_instance.server.public_ip
}