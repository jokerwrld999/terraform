output "public_ip" {
  description = "Public IPs"
  value = [aws_instance.server.*.public_ip]
}

output "private_ip" {
  description = "Private IPs"
  value = [aws_instance.server.*.private_ip]
}