resource "digitalocean_ssh_key" "my_public_key" {
	name = "my_public_key"
	public_key = var.my_public_key
}


data "digitalocean_ssh_key" "terraform" {
        name = "REBRAIN.SSH.PUB.KEY"
}


resource "digitalocean_droplet" "my-vm" {
	image    = var.vm_image
	name     = var.vm_name
	region   = var.region
	size     = var.rm_size
	ssh_keys = [data.digitalocean_ssh_key.terraform.fingerprint, digitalocean_ssh_key.my_public_key.fingerprint]
	tags     = [var.email, "devops", var.task_name]
	
}

