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

data "aws_route53_zone" "primary" {
        name = "devops.rebrain.srwx.net"
}


resource "digitalocean_droplet" "my_vm" {
        image    = var.vm_image
        name     = var.vm_name
        region   = var.region
        size     = var.rm_size
        ssh_keys = [digitalocean_ssh_key.my_public_key.fingerprint , data.external.ssh_rebrain.result.fingerprint]
        tags     = [var.email, "devops", var.task_name]	
}


resource "aws_route53_record" "ansible_6" {
        zone_id = data.aws_route53_zone.primary.zone_id
        name    = var.vm_name
        type    = "A"
        ttl     = "300"
        records = [digitalocean_droplet.my_vm.ipv4_address]
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

