output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.cra_3_vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [
    aws_subnet.cra_3_pub1.id,
    aws_subnet.cra_3_pub2.id
  ]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [
    aws_subnet.cra_3_priv1.id,
    aws_subnet.cra_3_priv2.id
  ]
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.cra_3_igw.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.cra_3_nat_gw.id
}

output "elastic_ip" {
  description = "The Elastic IP associated with the NAT Gateway"
  value       = aws_eip.cra_3_eip.public_ip
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.cra_3_sg.id
}
