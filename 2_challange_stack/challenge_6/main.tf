provider "aws" {
  region= "us-east-1"
}

locals {
  time =  formatdate("MMM DD, YYYY hh:mm:ss ZZZ", "${timestamp()}")
}

output time {
  value       = local.time
  description = "description"
}
