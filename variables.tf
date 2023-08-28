variable "droplets" {
        type = list
        default = [
        {
	   name  = "abrams1"
	   image = "ubuntu-18-04-x64"
	   size  = "s-1vcpu-1gb"
	},
	{
	   name  = "abrams2"
	   image = "ubuntu-18-04-x64"
	   size  = "s-1vcpu-1gb"
	}
        ]        
}
variable "private_key" {
	type = string
}
variable "do_token" {}
variable "my_public_key" {
	type = string
}
variable "region" {}
variable "email" {}
variable "task_name" {}
variable "access_key" {}
variable "secret_key" {}

