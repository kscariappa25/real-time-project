output "codeartifact_domain_url" {
  description = "AWS CodeArtifact domain URL"
  value       = aws_codeartifact_domain.ngem_ops_domain.domain
}
