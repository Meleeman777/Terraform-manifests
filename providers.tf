terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "3.7.0"
    }
  }
}

provider "gitlab" {
    token = var.gitlab_token
    base_url = var.base_url
}
