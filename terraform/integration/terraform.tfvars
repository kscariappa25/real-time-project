project_name = "producer-api"
destination_aws_account_id = "348542648035"
source_code_repo           = "https://github.com/kscariappa25/real-time-project"
repo_parent_project_name   = "kscariappa25/real-time-project"
ecs_cluster_name           = "ngem-api-dev-ecs-cluster"
codebuild_role_arn    = "arn:aws:iam::699300400344:role/ngem-api-ops-codebuild-manager-role"
codepipeline_role_arn = "arn:aws:iam::699300400344:role/ngem-api-ops-codepipeline-manager-role"
deploy_api_count           = 2
deploy_actions = [
  { name = "Deploy-Primary",   service_name = "ngem-api-dev-ecs-cluster-prd-srv", file_name = "producer-imagedefinitions.json" },
  { name = "Deploy-Secondary", service_name = "ngem-api-dev-ecs-cluster-con-svc", file_name = "consumer-imagedefinitions.json" }
custom_kms_key = "d6063ebb-1168-47dd-a67b-c730009a595a"
