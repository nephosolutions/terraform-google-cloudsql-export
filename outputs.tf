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

output "function_name" {
  description = "The name of the function."
  value       = module.export_function.name
}

output "topic_id" {
  description = "The ID of the Pub/Sub topic"
  value       = module.pubsub_topic.id
}

output "topic_name" {
  description = "The name of the Pub/Sub topic"
  value       = module.pubsub_topic.topic
}

output "topic_uri" {
  description = "The URI of the Pub/Sub topic"
  value       = module.pubsub_topic.uri
}

output "subscription_names" {
  description = "The name list of Pub/Sub subscriptions"
  value       = module.pubsub_topic.subscription_names
}

output "subscription_paths" {
  description = "The path list of Pub/Sub subscriptions"
  value       = module.pubsub_topic.subscription_paths
}

output "scheduler_job_id" {
  description = "Map of job identifiers with format `projects/{{project}}/locations/{{region}}/jobs/{{name}}`"
  value       = { for k, v in google_cloud_scheduler_job.export : k => v.id }
}
