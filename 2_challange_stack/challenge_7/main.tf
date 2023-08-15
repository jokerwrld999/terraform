variable "environment" {
    description = "Environment Type"
    type = map
    default = {
        "test" = "us-west-1"
        "production" = "us-west-2"
    }
}

variable "availability_zones" {
    description = "Availability Zones Mapping"
    type = map
    default = {
        "us-east-1" = "us-west-1a,us-west-1b,us-west-1c"
        "us-west-2" = "us-west-2a,us-west-2b,us-west-2c"
    }
}


output "AZs" {
    value = "${element(split(",", lookup(var.availability_zones,var.environment.production)), 2)}"
}