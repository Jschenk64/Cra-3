This Terraform script sets up a Virtual Private Cloud (VPC) infrastructure on AWS with both public and private subnets, an internet gateway, NAT gateway, route tables, and a security group. Here’s a breakdown of each resource and its purpose:

VPC (aws_vpc.cra_3_vpc):

Creates a VPC with a CIDR block defined by var.vpc_cidr.
DNS support and hostnames are enabled for the VPC.
Public Subnets (aws_subnet.cra_3_pub1 and aws_subnet.cra_3_pub2):

Two public subnets are created within the VPC, each in a different availability zone.
map_public_ip_on_launch is set to true to automatically assign public IPs to instances launched in these subnets.
Private Subnets (aws_subnet.cra_3_priv1 and aws_subnet.cra_3_priv2):

Two private subnets are also created in separate availability zones, without public IPs on instances.
Internet Gateway (aws_internet_gateway.cra_3_igw):

Provides internet connectivity for resources in public subnets.
Public Route Table (aws_route_table.cra_3_pub_rt):

Contains a route that directs traffic with a destination CIDR of 0.0.0.0/0 to the internet gateway.
Associated with the public subnets to give them internet access.
Elastic IP (aws_eip.cra_3_eip):

Allocates an Elastic IP, which will be used by the NAT gateway.
NAT Gateway (aws_nat_gateway.cra_3_nat_gw):

Allows instances in private subnets to access the internet for updates and other outbound connections while remaining inaccessible from the internet.
Private Route Table (aws_route_table.cra_3_priv_rt):

Contains a route to allow outbound traffic from the private subnets via the NAT gateway.
Route Table Associations:

Associates the public route table with the public subnets and the private route table with the private subnets.
Security Group (aws_security_group.cra_3_sg):

Allows inbound SSH (port 22) and HTTP (port 80) traffic from any IP (0.0.0.0/0).
Allows all outbound traffic.
Each resource is tagged based on values in var.tags for easy identification in AWS. This setup provides a basic structure for securely hosting applications in AWS with internet-facing and isolated resources.
