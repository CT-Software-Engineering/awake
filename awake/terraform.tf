# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {

  # cloud {
  #   workspaces {
  #     name = "awake"
  #   }
  # }
  backend "s3" {
    bucket = "terraform-state-awake"
    key    = "eks_template.tfstate"
    region = "eu-west-1"
    #dynamodb_table = "your-dynamodb-table-name"
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.47.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.5"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.3.4"
    }
  }

  required_version = ">= 1.3"
}

