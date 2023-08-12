output "password" {
	value = [for k in random_password.secret: nonsensitive(k.result)]
}

