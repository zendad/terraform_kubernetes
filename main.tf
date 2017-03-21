# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}


# Create a VPC to launch our instances into
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags {
        Name = "kubernete_vpc"
    }
}

# Create a subnet to launch our instances into
resource "aws_subnet" "main" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "${var.aws_availability_zone}"

    tags {
        Name = "kubernete_subnet"
    }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "kubernete_gw"
    }
}


# Our default security group to access
# the instance over SSH and HTTP
resource "aws_security_group" "main" {
  name        = "kubernete_sg"
  description = "Used for kubernete"
  vpc_id      = "${aws_vpc.main.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access tomcat from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


 # kubernettes ports
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # kubernettes ports
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # open all tcp ports for the whole vpc
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # open all udp ports for the whole vpc
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/16"]
  }



  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# Create instance
resource "aws_instance" "main" {
  count = 2
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "${var.aws_ec2_user}"
  }

  availability_zone = "${var.aws_availability_zone}"

  instance_type = "${var.aws_instance_type}"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${var.aws_ami_ubuntu}"

  # The name of our SSH keypair we created above.
  key_name = "${var.aws_ec2_keyname}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.main.id}"]
  subnet_id = "${aws_subnet.main.id}"
  
  tags {
        Name = "kubernete-host-${count.index}"
    }
}


