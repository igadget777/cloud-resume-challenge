terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.13.0"
    }
  }
  backend "s3" {
    region = "us-east-1"
    bucket = "terraform-state-resume-challenge"
    key    = "default/frontend-backend/terraform.tfstate"

    dynamodb_table = "terraform-locks-resume-challenge"
    encrypt        = true #ensures Terraform state will be encrypted on disk when stored in S3
  }
}


module "backend-module" {
  source = "./backend"

  aws_acm_cert = module.frontend-module.aws_acm_cert
}

module "frontend-module" {
  source = "./frontend"

  api_gw_domain_name          = module.backend-module.api_gw_domain_name
  api_gw_regional_domain_name = module.backend-module.api_gw_regional_domain_name
  api_gw_regional_zone_id     = module.backend-module.api_gw_regional_zone_id
}
