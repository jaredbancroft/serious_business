include "root" {
    path = find_in_parent_folders()
    expose = true
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/vpc.hcl"
  expose = true
}

terraform {
    source = "${include.envcommon.locals.base_source_url}?version=3.10.0"
}

inputs = {
  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${include.root.locals.aws_region}a", "${include.root.locals.aws_region}b", "${include.root.locals.aws_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "prod"
  }
}