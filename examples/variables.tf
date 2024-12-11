variable "function_name" {
  description = "The name to apply to the function."
  type        = string
}

variable "project_id" {
  description = "The ID of the GCP project. Defaults to the provider project configuration, if left empty."
  type        = string
}

variable "region" {
  description = "The region to deploy the resources in."
  type        = string
}
