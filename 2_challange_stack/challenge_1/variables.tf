variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-1"
}

variable "dns_support" {
  description = "Enable DNS Support"
  type        = bool
  default     = true
}