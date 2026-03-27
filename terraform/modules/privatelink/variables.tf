variable "name" {
  type        = string
  description = "Name prefix for all resources"
}

variable "sandbox_vpc_id" {
  type        = string
  description = "VPC ID in SANDBOX account"
}

variable "sandbox_private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs in SANDBOX account for NLB"
}

variable "dev_account_id" {
  type        = string
  description = "DEV account ID allowed to connect to endpoint service"
}

variable "msk_broker_ports" {
  type        = list(string)
  description = "MSK broker ports"
  default     = ["9098"]
}

variable "msk_broker_ips_ports" {
  type = list(object({
    ip   = string
    port = string
  }))
  description = "MSK broker IPs and ports for NLB target group"
}

variable "tags" {
  type    = map(string)
  default = {}
}
