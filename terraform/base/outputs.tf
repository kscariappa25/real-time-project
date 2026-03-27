output "codebuild_role_arn" {
  value = module.codebuild_iam_role.iam_role_arn
}
output "codepipeline_role_arn" {
  value = module.codepipeline_iam_role.iam_role_arn
}
output "codebuild_extended_permissions_policy_arn" {
  value = aws_iam_policy.codebuild_extended_permissions_policy.arn
}
output "codepipeline_extended_permissions_policy_arn" {
  value = aws_iam_policy.codepipeline_extended_permissions_policy.arn
}
