resource "gitlab_project" "ter_01" {
	name = "ter_01"
	description = "My project"
	visibility_level = "private"
	namespace_id = var.namespace_id
}

resource "gitlab_deploy_key" "terraform_key" {
        project = var.project_id
        title   = "terraform deploy key"
        key     = var.ssh_key 
        can_push   = "true" 
}
