##############################################################################
# Variables File
# 
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

variable "client_secret" {
    description = "Client Secret"
}
 
variable "tenant_id" {
    description = "Tenant ID"
}
 
variable "subscription_id" {
    description = "Subscription ID"
}
 
variable "client_id" {
    description = "Client ID"
}

variable "location" {
  description = "The region where the Azure Resource is created."
  default     = "West Europe"
}

variable "sourceBranchName" {
  description = "Build Source Branch Name"
  default     = "dev"
}