variable "codeartifact_domain_name" {
  description = "AWS CodeArtifact domain name"
  type        = string
}
variable "codeartifact_domain_tags" {
  description = "AWS CodeArtifact domain tags"
  type        = map(string)
}
