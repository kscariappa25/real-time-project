resource "aws_codeartifact_domain" "ngem_ops_domain" {
  domain = var.codeartifact_domain_name
  tags   = var.codeartifact_domain_tags
}
