variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.150.0.0/16"
}

variable "instance_tenancy" {
  description = "The instance tenancy for the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_support" {
  description = "Whether to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "public_subnet_cidr_blocks" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.150.10.0/24", "10.150.11.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.150.12.0/24", "10.150.13.0/24"]
}

variable "availability_zones" {
  description = "The availability zones for the subnets"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "internet_gateway_name" {
  description = "The name tag for the Internet Gateway"
  type        = string
  default     = "Cra-3-IGW"
}

variable "public_route_table_name" {
  description = "The name tag for the public route table"
  type        = string
  default     = "Cra-3_Pub_RT"
}

variable "private_route_table_name" {
  description = "The name tag for the private route table"
  type        = string
  default     = "Cra-3_Priv_RT"
}