cluster_name                  = "ngem-api-dev-ecs-cluster"
environment                   = "dev"
region                        = "us-east-1"
private_subnet_tag_key_name   = "type"
private_subnet_tag_value_name = "private"
public_subnet_tag_key_name    = "type"
public_subnet_tag_value_name  = "public"
certificate_id = "value"
destination_account_id = ""
tags = {
  Application = "Async-api",
  env         = "dev"
}
