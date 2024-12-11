/**
 * Copyright 2019-2024 NephoSolutions srl, Sebastian Trebitz
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "export_jobs" {
  description = "Set of export Jobs"
  nullable    = false

  type = set(object({
    bucket_url      = string
    file_name       = string
    job_description = optional(string)
    job_name        = string
    job_schedule    = string
    offload_export  = optional(bool, true)
    sql_databases   = optional(list(string), [])
    sql_instance    = string
    sql_project     = string
    time_zone       = optional(string, "Etc/UTC")
  }))
}

variable "function_labels" {
  description = "A set of key/value label pairs to assign to the function."
  type        = map(string)
  default     = {}
}

variable "function_name" {
  description = "The name to apply to the function."
  type        = string
  default     = "cloudsql-export"
}

variable "function_runtime" {
  description = "The Cloud Run functions execution environment."
  type        = string
  nullable    = false
  default     = "python39"

  validation {
    condition = contains([
      "python39",
      "python310",
      "python311",
      "python312",
    ], var.function_runtime)

    error_message = "Unsupported Cloud Run functions execution environment."
  }
}

variable "function_service_account_email" {
  description = "The service account to run the function as."
  type        = string
  nullable    = false
}

variable "function_source_bucket_create" {
  description = "Whether to create a new bucket or use an existing one."
  type        = bool
  nullable    = false
  default     = true
}

variable "function_source_bucket_name" {
  description = "The name of the function source archive bucket."
  type        = string
  nullable    = false
  default     = ""
}

variable "function_source_bucket_labels" {
  description = "A set of key/value label pairs to assign to the source bucket."
  type        = map(string)
  default     = {}
}

variable "project_id" {
  description = "The ID of the GCP project. Defaults to the provider project configuration, if left empty."
  type        = string
}

variable "region" {
  description = "The region to deploy the resources in."
  type        = string
}

variable "topic_name" {
  description = "Name of pubsub topic connecting the scheduled job and the function"
  type        = string
  nullable    = false
  default     = "cloudsql-export"
}

variable "topic_labels" {
  description = "A set of key/value label pairs to assign to the pubsub topic."
  type        = map(string)
  default     = {}
}
