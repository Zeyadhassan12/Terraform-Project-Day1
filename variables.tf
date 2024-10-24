variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
variable "environment_tag" {
  description = "Tag for the environment"
  default     = "terraformChamps"
}

variable "owner_tag" {
  description = "Owner of the resources"
  default     = "Zeyad Hassan"
}
variable "subnet_cidr" {
  description = "CIDR block for the Subnet"
  default     = "10.0.1.0/24"
}
