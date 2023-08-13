resource "digitalocean_ssh_key" "my_public_key" {
	name = "my_public_key"
	public_key = var.my_public_key
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

resource "random_password" "secret" {
	count            = var.server_count
	length           = 16
	special          = true
	override_special = "!#$%&*()-_=+[]{}:?"
}


resource "digitalocean_droplet" "my-vm" {
	count    = length(var.devs)
	image    = var.vm_image
	name     = format("%s-%s", var.vm_name, count.index)
	region   = var.region
	size     = var.rm_size
	ssh_keys = [digitalocean_ssh_key.my_public_key.fingerprint , data.external.ssh_rebrain.result.fingerprint]
	tags     = [var.email, "devops", var.task_name]
          connection {
            type        = "ssh"
            user        = "root"
            private_key = file(var.private_key)
            host        = self.ipv4_address
        }
              provisioner "remote-exec" {
                  inline = [
                  "/usr/bin/echo \"root:${element(random_password.secret[*].result, count.index)}\" | sudo chpasswd"
                   ]

              }
     
}

resource "aws_route53_record" "terraform-8" {
	count   = length(var.devs)
	zone_id = data.aws_route53_zone.primary.zone_id
	name    = var.devs[count.index]
	type    = "A"
	ttl     = "300"
	records = [digitalocean_droplet.my-vm[count.index].ipv4_address]
}


resource "local_file" "info" {
        content = templatefile(
	          "info.tftpl", {
			names = aws_route53_record.terraform-8[*].name,
			ips = digitalocean_droplet.my-vm[*].ipv4_address
			pass = random_password.secret[*].result
			})
        filename = "inventory.txt"
}
