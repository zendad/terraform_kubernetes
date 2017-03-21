variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
}

variable "aws_availability_zone" {
  description = "AWS resourses Availablity zone."
  default     = "us-west-2a"
}

variable "aws_ami_ubuntu" {
  description = "Centos 7 ami"
  default     = "ami-06f84566"
}

variable "aws_instance_type" {
  description = "aws instance type to create"
  default     = "t2.large"
}

variable "aws_ec2_user" {
  description = "aws ec2 user"
  default     = "centos"
}

variable "aws_ec2_keyname" {
  description = "aws ec2 keyname"
  default     = "mongodb_access"
}

variable "aws_ec2_keyfile" {
  description = "aws ec2 keyfile"
  default     = "/home/dereck/.ssh/mongodb_access.pem"
}


variable "aws_access_key" {
  description = "aws access key"
  default     =  "00000000"
}

variable "aws_secret_key" {
  description = "aws secret key"
  default     =  "ooooooooo"
}


