resource "digitalocean_ssh_key" "my_public_key" {
	name = "my_public_key"
	public_key = var.my_public_key
}


data "digitalocean_ssh_key" "terraform" {
        name = "REBRAIN.SSH.PUB.KEY"
}

data "aws_route53_zone" "primary" {
	name = "devops.rebrain.srwx.net"
}


resource "digitalocean_droplet" "my-vm" {
	count    = var.server_count
	image    = var.vm_image
	name     = join("",[var.vm_name, "0", count.index+1])
	region   = var.region
	size     = var.rm_size
	ssh_keys = [data.digitalocean_ssh_key.terraform.fingerprint, digitalocean_ssh_key.my_public_key.fingerprint]
	tags     = [var.email, "devops", var.task_name]
          connection {
            type        = "ssh"
            user        = "root"
            private_key = var.private_key
            host        = self.ipv4_address
        }
              provisioner "remote-exec" {
                  inline = [
                  "echo 'root:Password123' | sudo chpasswd"
                   ]

              }
      
}

resource "aws_route53_record" "terraform-4" {
	count   = var.server_count
	zone_id = data.aws_route53_zone.primary.zone_id
	name    = "ivan-abramenko-${count.index}"
	type    = "A"
	ttl     = "300"
	records = [for i in local.vps_ip : digitalocean_droplet.my-vm[0].ipv4_address]
}
