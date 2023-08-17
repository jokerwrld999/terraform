output "public_ip" {
  description = "Public IP"
  value       = aws_instance.web.public_ip
}