output "public_ip" {
  description = "Public IP"
  value       = module.myapp-webserver.public_ip
}