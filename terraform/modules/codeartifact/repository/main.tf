resource "aws_codeartifact_repository" "ngem_ops_python_repository" {
  repository = var.codeartifact_repository_name
  domain     = var.codeartifact_domain
}
