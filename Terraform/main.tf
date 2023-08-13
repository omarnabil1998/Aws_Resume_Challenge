terraform {
  backend "s3" {
    bucket         = "aws-resume-challenge-tf-state"
    key            = "aws-resume-challenge.tfstate"
    encrypt        = true
    region         = "us-east-1"
    dynamodb_table = "aws-resume-challenge-tf-state-lock"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }
}

data "aws_region" "current" {}
