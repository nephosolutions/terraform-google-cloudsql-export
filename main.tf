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

resource "google_cloud_scheduler_job" "export" {
  for_each = {
    for job_key, job in var.export_jobs : job.job_name => job
  }

  name        = each.value.job_name
  description = each.value.job_description
  schedule    = each.value.job_schedule
  time_zone   = each.value.time_zone
  project     = var.project_id
  region      = var.region

  pubsub_target {
    topic_name = module.pubsub_topic.id

    data = base64encode(jsonencode({
      bucket_url = each.value.bucket_url
      databases  = each.value.sql_databases,
      file_name  = each.value.file_name
      instance   = each.value.sql_instance,
      offload    = each.value.offload_export
      project    = each.value.sql_project,
    }))
  }
}

module "pubsub_topic" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 7.0"

  topic        = var.topic_name
  project_id   = var.project_id
  topic_labels = var.topic_labels
}

module "export_function" {
  source  = "terraform-google-modules/event-function/google"
  version = "~> 4.0"

  available_memory_mb   = 128
  description           = "Processes cloudSQL database export events provided through a Pub/Sub topic subscription."
  entry_point           = "main"
  labels                = var.function_labels
  name                  = var.function_name
  runtime               = var.function_runtime
  service_account_email = var.function_service_account_email
  bucket_labels         = var.function_source_bucket_labels
  bucket_name           = var.function_source_bucket_name
  create_bucket         = var.function_source_bucket_create
  source_directory      = "${path.module}/cloudsql-export"

  event_trigger = {
    event_type = "google.pubsub.topic.publish"
    resource   = module.pubsub_topic.topic
  }

  project_id = var.project_id
  region     = var.region
}
