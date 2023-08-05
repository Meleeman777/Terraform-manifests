resource "gitlab_project" "ter_01" {
	name = "ter_01"
	description = "My project"
	visibility_level = "private"
	namespace_id = var.namespace_id
}

data "gitlab_group" "devops_users_repo" {
	full_path = "devops_users_repos/5229"
}

resource "gitlab_deploy_key" "terraform_key" {
        project = var.project_id
        title   = "terraform deploy key"
        key     = var.ssh_key
}
