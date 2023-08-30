variable "droplets" {
        type = list
        default = [
        {
	   name  = "abrams-app1"
	},
	{
	   name  = "abrams-app2"
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
variable "size" {}
variable "name" {}
variable "image" {}

