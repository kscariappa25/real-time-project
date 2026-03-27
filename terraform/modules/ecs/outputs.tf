output "ecs_cluster_id" {
  value = aws_ecs_cluster.ngem_ops_ecs_cluster.id
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ngem_ops_ecs_cluster.arn
}

output "alb_arn" {
  value = aws_lb.ngem_api_alb.arn
}

output "alb_dns_name" {
  value = aws_lb.ngem_api_alb.dns_name
}
