vpc_cidr = "10.150.0.0/16"

public_subnet_cidrs = [
  "10.150.10.0/24",
  "10.150.11.0/24"
]

private_subnet_cidrs = [
  "10.150.12.0/24",
  "10.150.13.0/24"
]

availability_zones = [
  "eu-central-1a",
  "eu-central-1b"
]

region = "eu-central-1"

tags = {
  vpc          = "Cra-3-VPC"
  public_sub1  = "Cra-3-Pub1"
  public_sub2  = "Cra-3-Pub2"
  private_sub1 = "Cra-3-Priv1"
  private_sub2 = "Cra-3-Priv2"
  igw          = "Cra-3-IGW"
  pub_rt       = "Cra-3_Pub_RT"
  priv_rt      = "Cra-3_Priv_RT"
  sg           = "CRA-3-SG"
  eip          = "CRA-3_EIP"
  nat_gw       = "Cra-3_NAT_GW"
}
