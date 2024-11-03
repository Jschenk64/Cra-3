variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.150.0.0/16"
}

variable "subnet1_cidr_block" {
  description = "Public Subnet 1 CIDR block"
  type        = string
  default     = "10.150.10.0/24"
}

variable "subnet2_cidr_block" {
  description = "Public Subnet 2 CIDR block"
  type        = string
  default     = "10.150.20.0/24"
}

variable "availability_zone_1" {
  description = "Availability Zone for Subnet 1"
  type        = string
  default     = "eu-central-1a"
}

variable "availability_zone_2" {
  description = "Availability Zone for Subnet 2"
  type        = string
  default     = "eu-central-1b"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-08ec94f928cf25a9d"
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = "mse-svh105"
}
