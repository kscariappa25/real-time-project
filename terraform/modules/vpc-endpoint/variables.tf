variable "name" {
  type        = string
  description = "Name prefix"
}

variable "endpoint_service_name" {
  type        = string
  description = "VPC Endpoint Service name from SANDBOX account"
}

variable "tags" {
  type    = map(string)
  default = {}
}
