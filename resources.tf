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
	name     = var.vm_name
	region   = var.region
	size     = var.rm_size
	ssh_keys = [data.digitalocean_ssh_key.terraform.fingerprint, digitalocean_ssh_key.my_public_key.fingerprint]
	tags     = [var.email, "devops", var.task_name]
      
        provisioner "remote-exec" {

          connection {
	    type        = "ssh"
            user        = "root"
            private_key = "${file("/home/ivan/ter_02/ter02")}"
            host        = "${self.ipv4_address}"
	}
          inline = [
            "echo 'root:Password123' | sudo chpasswd"
	  ]

	}
	
}

resource "aws_route53_record" "terraform-4" {
	count   = var.server_count
	zone_id = data.aws_route53_zone.primary.zone_id
	name    = "ivan-abramenko-${count.index}.devops.rebrain.srwx.net"
	type    = "A"
	ttl     = "300"
	records = [digitalocean_droplet.my-vm[count.index].ipv4_address]
}
