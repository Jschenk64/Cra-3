output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.cra-3_vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [aws_subnet.cra-3_pub1.id, aws_subnet.cra-3_pub2.id]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [aws_subnet.cra-3_priv1.id, aws_subnet.cra-3_priv2.id]
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.Cra-3_igw.id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.cra-3_pub_rt.id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.cra-3_priv_rt.id
}