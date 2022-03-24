terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "shared" {
  source = "./modules/shared"

  app_name            = var.app_name
  aws_region          = var.aws_region
  base_url            = var.base_url
  lambda_bucket_name  = var.lambda_bucket_name
  lambda_gateway_name = var.lambda_gateway_name

  # Only allows to instantiate the shared module on the shared workspace
  count = terraform.workspace == "shared" ? 1 : 0
}

module "app" {
  source = "./modules/app"

  pr_id         = var.pr_id
  app_name      = var.app_name
  base_url      = var.base_url
  commit_hash   = var.commit_hash
  current_stage = var.current_stage

  # Only allows to instantiate the app module on non shared and non default workspaces
  count = (
    terraform.workspace == "shared" ? 0 :
    terraform.workspace == "default" ? 0 :
    1
  )
}
