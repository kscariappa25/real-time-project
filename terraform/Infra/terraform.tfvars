# ── Kafka (SANDBOX account us-west-2) ─────────────────────────
msk_cluster_name                    = "ngem-api-msk-cluster-dev"
msk_cluster_kafka_version           = "3.6.0"
msk_cluster_ebs_storage_volume_size = "20"
number_of_broker_nodes              = "2"
msk_cluster_instance_type           = "kafka.m5.large"
msk_deploy_region                   = "us-west-2"
env                                 = "dev"

# ── ECS (DEV account us-east-1) ───────────────────────────────
cluster_name                        = "ngem-api-dev-ecs-cluster"
environment                         = "dev"
region                              = "us-east-1"
private_subnet_tag_key_name         = "type"
private_subnet_tag_value_name       = "private"
public_subnet_tag_key_name          = "type"
public_subnet_tag_value_name        = "public"

# ── ECR repo names ─────────────────────────────────────────────
producer_container_repo_name        = "producer-api"
consumer_container_repo_name        = "consumer-api"
image_tag                           = "latest"

# ── Certificate — skipping for demo ───────────────────────────
certificate_id                      = ""

# ── Account IDs ────────────────────────────────────────────────
source_account_id                   = 699300400344
destination_account_id              = 348542648035
development_aws_account_id          = 348542648035
sandbox_aws_account_id              = 626635426805
dt_aws_account_id                   = ""
dt_kms_aws_account_id               = ""

# ── Dynatrace ──────────────────────────────────────────────────
dynatrace_env_id                    = "row09801"
dynatrace_log_token                 = "ngemapi/dev/dynatrace_log_ingest_token-fE2Yoh"

# ── Security groups ────────────────────────────────────────────
eks_cluster_security_group_id       = "sg-0a60c280b1b275966"
ec2_security_group_id               = "sg-0a60c280b1b275966"

# ── Tags ───────────────────────────────────────────────────────
global_tags = {
  "nextgen.environment" = "dev"
  "nextgen.project"     = "NGEAPI"
  "nextgen.automation"  = "true"
}

sandbox_vpc_id             = "vpc-012fe7cf3b1b367b0"
sandbox_private_subnet_ids = ["subnet-060aa15b03f4499e9", "subnet-064e61fc749b23d3a"]
msk_broker_ips_ports = [
  { ip = "172.31.6.77", port = "9098" },
  { ip = "172.31.37.155", port = "9098" }
]