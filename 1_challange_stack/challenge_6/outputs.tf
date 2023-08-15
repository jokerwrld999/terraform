output "public_ip" {
  description = "Public IP Address"
  value = aws_instance.server.public_ip
}

output "private_ip" {
  description = "Private IP Address"
  value = aws_instance.server.private_ip
}