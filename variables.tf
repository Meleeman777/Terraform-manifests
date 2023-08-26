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
	   image = "centos-7-x64"
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
variable "vm_name" {}
variable "region" {}
variable "rm_size" {}
variable "email" {}
variable "task_name" {}
variable "vm_image" {}
variable "access_key" {}
variable "secret_key" {}

