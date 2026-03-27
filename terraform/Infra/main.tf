module "ngem_api_dev_vpc_us_west_2" {
  source    = "../modules/vpc"
  providers = { aws = aws.development_account_us-west-2 }

  vpc_name             = "ngem-api-dev-vpc-us-west-2"
  vpc_cidr             = "10.0.0.0/16"
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones   = ["us-west-2a", "us-west-2b"]
  tags                 = var.global_tags
}

module "ngem_api_ecs_clster" {
  source    = "../modules/ecs"
  providers = { aws = aws.development_account }

  cluster_name                  = var.cluster_name
  environment                   = var.environment
  region                        = var.region
  tags                          = var.global_tags
  private_subnet_tag_key_name   = var.private_subnet_tag_key_name
  private_subnet_tag_value_name = var.private_subnet_tag_value_name
  public_subnet_tag_key_name    = var.public_subnet_tag_key_name
  public_subnet_tag_value_name  = var.public_subnet_tag_value_name
  certificate_id                = var.certificate_id
  destination_account_id        = var.destination_account_id
  source_account_id             = var.source_account_id
  sandbox_aws_account_id        = var.sandbox_aws_account_id
  producer_container_repo_name  = var.producer_container_repo_name
  consumer_container_repo_name  = var.consumer_container_repo_name
  image_tag                     = var.image_tag
  dt_aws_account_id             = var.dt_aws_account_id
  dt_kms_aws_account_id         = var.dt_kms_aws_account_id
  eks_cluster_security_group_id = var.eks_cluster_security_group_id
  ec2_security_group_id         = var.ec2_security_group_id
  otel_container_repo_name      = ""
}

module "ngem_api_msk_cluster" {
  source    = "../modules/kafka"
  providers = { aws = aws.development_account }


  msk_cluster_name                    = var.msk_cluster_name
  msk_cluster_kafka_version           = var.msk_cluster_kafka_version
  msk_cluster_instance_type           = var.msk_cluster_instance_type
  msk_cluster_ebs_storage_volume_size = var.msk_cluster_ebs_storage_volume_size
  number_of_broker_nodes              = var.number_of_broker_nodes
  env                                 = var.environment
  aws_client_account_id               = var.development_aws_account_id
  private_subnet_tag_key_name         = var.private_subnet_tag_key_name
  private_subnet_tag_value_name       = var.private_subnet_tag_value_name
  public_subnet_tag_key_name          = var.public_subnet_tag_key_name
  public_subnet_tag_value_name        = var.public_subnet_tag_value_name
  tags                                = var.global_tags
}

# module "ngem_api_msk_connectivity" {
#   source    = "../modules/multi-vpc"
#   providers = { aws = aws.development_account }

#   cluster_arn                         = module.ngem_api_msk_cluster.arn
#   aws_msk_multi_connection_sg         = "${var.msk_cluster_name}-multi-vpc-sg"
#   vpc_id                              = "vpc-0f729590803cb4582"
#   private_subnet_ids                  = ["subnet-0a62ad1acf1c7648d", "subnet-011b033ed21091392"]
#   development_account_vpc_cidr_blocks = ["10.0.0.0/16"]

#   depends_on = [module.ngem_api_msk_cluster]
# }

# Remove this block:
# module "ngem_api_msk_connectivity" { ... }

# Add these two blocks:

module "ngem_api_msk_privatelink" {
  source    = "../modules/privatelink"
  providers = { aws = aws.sanbox_account }

  name                       = var.msk_cluster_name
  sandbox_vpc_id             = var.sandbox_vpc_id
  sandbox_private_subnet_ids = var.sandbox_private_subnet_ids
  dev_account_id             = var.development_aws_account_id
  msk_broker_ips_ports       = var.msk_broker_ips_ports
  tags                       = var.global_tags

  depends_on = [module.ngem_api_msk_cluster]
}

module "ngem_api_msk_vpc_endpoint" {
  source    = "../modules/vpc-endpoint"
  providers = { aws = aws.development_account }

  name                  = var.msk_cluster_name
  endpoint_service_name = module.ngem_api_msk_privatelink.endpoint_service_name
  tags                  = var.global_tags

  depends_on = [module.ngem_api_msk_privatelink]
}

module "ngem_api_glue_schema" {
  source    = "../modules/glue"
  providers = { aws = aws.sanbox_account }

  registry_name = "${var.msk_cluster_name}-glue-registry"
  schema_name   = "${var.msk_cluster_name}-glue-schema"
  tags          = var.global_tags
}

# module "ngem_api_data_fire_house" {
#   source    = "../modules/datafirehouse"
#   providers = { aws = aws.development_account }

#   aws_region          = var.region
#   dynatrace_env_id    = var.dynatrace_env_id
#   dynatrace_log_token = var.dynatrace_log_token
#}
