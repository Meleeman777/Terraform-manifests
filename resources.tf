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

resource "digitalocean_droplet" "droplet-lb" {
  name     = var.name
  image    = var.image
  region   = var.region
  size     = var.size
  ssh_keys = [digitalocean_ssh_key.my_public_key.fingerprint , data.external.ssh_rebrain.result.fingerprint]
  tags     = [var.email, "devops", var.task_name]
}


resource "digitalocean_droplet" "droplet-apps" {
  for_each = { for droplet in var.droplets : droplet.name => droplet } 
  name     = each.value.name
  image    = var.image
  region   = var.region
  size     = var.size
  ssh_keys = [digitalocean_ssh_key.my_public_key.fingerprint , data.external.ssh_rebrain.result.fingerprint]
  tags     = [var.email, "devops", var.task_name]

}

resource "aws_route53_record" "ansible_12" {
  zone_id    = data.aws_route53_zone.primary.zone_id
  name       = var.name
  type       = "A"
  ttl        = 300
  records    = [digitalocean_droplet.droplet-lb.ipv4_address]
}



resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tftpl",
    {
	lbnames =  digitalocean_droplet.droplet-lb[*].name,
        appnames = [for d in var.droplets: d.name],
        lbips =  digitalocean_droplet.droplet-lb[*].ipv4_address, 
        appips = values(digitalocean_droplet.droplet-apps)[*].ipv4_address       
    }
  )
  filename = "ansible/hosts"
}

resource "terraform_data" "ansible" {
  provisioner "local-exec" {
    command = "ansible-playbook install_nginx.yaml --user=root --private-key=~/.ssh/ansible_key"
  }
  depends_on = [local_file.ansible_inventory]
}
