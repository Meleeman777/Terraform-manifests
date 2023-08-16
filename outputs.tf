output "ssh" {
  value = data.external.ssh_rebrain.result.public_key
}
