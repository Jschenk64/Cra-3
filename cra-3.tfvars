vpc_cidr = "10.150.0.0/16"

public_subnet_cidrs = [
  "10.150.90.0/24",
  "10.150.91.0/24"
]

private_subnet_cidrs = [
  "10.150.92.0/24",
  "10.150.93.0/24"
]

availability_zones = [
  "eu-west-1a",
  "eu-west-1b"
]

region = "eu-west-1"

tags = {
  vpc          = "Kass-3-VPC"
  public_sub1  = "Kass-3-Pub1"
  public_sub2  = "Kass-3-Pub2"
  private_sub1 = "Kass-3-Priv1"
  private_sub2 = "Kass-3-Priv2"
  igw          = "Kass-3-IGW"
  pub_rt       = "Kass-3_Pub_RT"
  priv_rt      = "Kass-3_Priv_RT"
  sg           = "Kass-3-SG"
  eip          = "Kass-3_EIP"
  nat_gw       = "Kass-3_NAT_GW"
}
