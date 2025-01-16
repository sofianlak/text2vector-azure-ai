terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  cloud {
    organization = "og-sofianlak" # Replace with your organization name
    workspaces {
      name = "tf-cloud-sofianlak" # Replace with your workspace name
    }
  }
}

provider "azurerm" {
  features {}
}