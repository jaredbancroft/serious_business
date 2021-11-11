locals {
  base_source_url = "tfr:///terraform-aws-modules/vpc/aws//."
}

terraform {
  source = "${local.base_source_url}?version=3.5.0"
}
