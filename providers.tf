terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "aws" {
  region = "us-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}
