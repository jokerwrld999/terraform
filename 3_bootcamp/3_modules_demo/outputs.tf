output "public_ip" {
  description = "Public IP"
  value       = module.myapp_webserver.public_ip
}