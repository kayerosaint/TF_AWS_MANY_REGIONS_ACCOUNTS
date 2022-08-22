provider "aws" { // Another account
  alias  = "ANOTHER_AWS_ACCOUNT"
  region = "ca-central-1"
  /* //account credentials
  access_key = "-"
  secret_key = "-"

  assume_role {
    role_arn     = "arn:aws:iam::309602750290:role/RemoteAdministrators"
    session_name = "DEV_SESSION"
  }
  */
}

provider "aws" {
  region = "ca-central-1"
}

provider "aws" {
  region = "us-east-1" //another region
  alias  = "USA"       //another region
}

provider "aws" {
  region = "eu-central-1" //another region
  alias  = "GER"          //another region
}
#==================================================================

data "aws_ami" "defaut_latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "usa_latest_ubuntu" {
  provider    = aws.USA
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "ger_latest_ubuntu" {
  provider    = aws.GER
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
#============================================================================
resource "aws_instance" "my_default_server" {
  instance_type = "t3.micro"
  ami           = data.aws_ami.defaut_latest_ubuntu.id
  tags = {
    Name = "Default Server"
  }
}

resource "aws_instance" "my_usa_server" {
  count         = var.group_prod == "prod" ? 1 : 0
  provider      = aws.USA
  instance_type = "t3.micro"
  ami           = data.aws_ami.usa_latest_ubuntu.id
  tags = {
    Name = "USA Server"
    Name = "Server Number ${count.index + 1}"
  }
}

resource "aws_instance" "my_ger_server" {
  count         = 3
  provider      = aws.GER
  instance_type = (var.group_dev == "dev" ? var.ec2_size["dev"] : var.ec2_size["prod"])
  ami           = data.aws_ami.ger_latest_ubuntu.id
  tags = {
    Name = "GERMANY Server"
  }
}

//----------------------------------------------------------------

// users creation
resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

// create security group

resource "aws_security_group" "my_webserver" {
  name = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.group_dev)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Dynamic SecurityGroup"
    Owner = "Denis Astahov"
  }
}
