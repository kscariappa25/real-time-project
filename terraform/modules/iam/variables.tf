variable role_name {
    type        = string
    description = "IAM Role name"
}
variable assume_services {
    type        = list(string)
    description = "IAM Role assume service name"
}
variable iam_service_role_policy_arn {
    type        = string
    description = "IAM Role assume role policy arn"
}
variable permissions_boundary {
    type        = string
    description = "IAM role permission boundary"
    default     = null
}
