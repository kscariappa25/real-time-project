variable "registry_name" {
  description = "Provide the AWS Glue schema registry Name"
}
variable "schema_name" {
  description = "Provide the AWS Glue schema Name"
}
variable "tags" {
  type = map(string)
}
