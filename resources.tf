resource "digitalocean_ssh_key" "my_public_key" {
	name = "my_public_key"
	public_key = file(var.my_public_key)
}

data "external" "ssh_rebrain" {
	program = ["bash", "./key.sh"]
	query = {
		do_token = var.do_token
	}
}


resource "digitalocean_droplet" "my_vm" {
	image    = var.vm_image
	name     = var.vm_name
	ssh_keys = [digitalocean_ssh_key.my_public_key.fingerprint , data.external.ssh_rebrain.result.fingerprint]
	region   = var.region
	size     = var.rm_size
	tags     = [var.email, "devops", var.task_name]
	
}

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tftpl",
    {
		names =  digitalocean_droplet.my_vm[*].name,
		ips = digitalocean_droplet.my_vm[*].ipv4_address

    }
  )
  filename = "ansible/inventory.yml"
}

