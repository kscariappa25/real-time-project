output "ngem_api_glue_schema" {
  value = {
    registry_name = aws_glue_registry.ngem_glue_registry.registry_name,
    schema_name = aws_glue_schema.ngem_glue_schema.schema_name
  }
}
