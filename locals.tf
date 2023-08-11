locals {
	vps_ip = digitalocean_droplet.my-vm[*].ipv4_address
}

