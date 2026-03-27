output "ecs_cluster_id" {
  value = module.ngem_api_ecs_clster.ecs_cluster_id
}

output "msk_cluster_arn" {
  value = module.ngem_api_msk_cluster.arn
}

output "msk_bootstrap_brokers_sasl_iam" {
  value = module.ngem_api_msk_cluster.bootstrap_brokers_sasl_iam
}

output "alb_arn" {
  value = module.ngem_api_ecs_clster.alb_arn
}

output "alb_dns_name" {
  value = module.ngem_api_ecs_clster.alb_dns_name
}

output "glue_schema" {
  value = module.ngem_api_glue_schema.ngem_api_glue_schema
}