variable "users" {
  description = "Map of users and their policies"
  type        = map(string)
  default     = {
    "terraform-aws-pdf2qa-convertor-deploy-infrastructure" = "terraform-aws-pdf2qa-convertor-deploy-infrastructure-policy",
    "backend-pdf2qa-validation-service-deploy" = "backend-pdf2qa-validation-service-deploy-policy",
  }
}