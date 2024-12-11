# CloudSQL Export

This Terraform module provisions a Google Cloud Function for scheduled cloudSQL database exports.

<!-- BEGIN_TF_DOCS -->
Copyright 2019-2024 NephoSolutions srl, Sebastian Trebitz

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.53 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.13.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_export_function"></a> [export\_function](#module\_export\_function) | terraform-google-modules/event-function/google | ~> 4.0 |
| <a name="module_pubsub_topic"></a> [pubsub\_topic](#module\_pubsub\_topic) | terraform-google-modules/pubsub/google | ~> 7.0 |

## Resources

| Name | Type |
|------|------|
| [google_cloud_scheduler_job.export](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_scheduler_job) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_export_jobs"></a> [export\_jobs](#input\_export\_jobs) | Set of export Jobs | <pre>set(object({<br/>    bucket_url      = string<br/>    file_name       = string<br/>    job_description = optional(string)<br/>    job_name        = string<br/>    job_schedule    = string<br/>    offload_export  = optional(bool, true)<br/>    sql_databases   = optional(list(string), [])<br/>    sql_instance    = string<br/>    sql_project     = string<br/>    time_zone       = optional(string, "Etc/UTC")<br/>  }))</pre> | n/a | yes |
| <a name="input_function_labels"></a> [function\_labels](#input\_function\_labels) | A set of key/value label pairs to assign to the function. | `map(string)` | `{}` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | The name to apply to the function. | `string` | `"cloudsql-export"` | no |
| <a name="input_function_runtime"></a> [function\_runtime](#input\_function\_runtime) | The Cloud Run functions execution environment. | `string` | `"python39"` | no |
| <a name="input_function_service_account_email"></a> [function\_service\_account\_email](#input\_function\_service\_account\_email) | The service account to run the function as. | `string` | n/a | yes |
| <a name="input_function_source_bucket_create"></a> [function\_source\_bucket\_create](#input\_function\_source\_bucket\_create) | Whether to create a new bucket or use an existing one. | `bool` | `true` | no |
| <a name="input_function_source_bucket_labels"></a> [function\_source\_bucket\_labels](#input\_function\_source\_bucket\_labels) | A set of key/value label pairs to assign to the source bucket. | `map(string)` | `{}` | no |
| <a name="input_function_source_bucket_name"></a> [function\_source\_bucket\_name](#input\_function\_source\_bucket\_name) | The name of the function source archive bucket. | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the GCP project. Defaults to the provider project configuration, if left empty. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to deploy the resources in. | `string` | n/a | yes |
| <a name="input_topic_labels"></a> [topic\_labels](#input\_topic\_labels) | A set of key/value label pairs to assign to the pubsub topic. | `map(string)` | `{}` | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | Name of pubsub topic connecting the scheduled job and the function | `string` | `"cloudsql-export"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | The name of the function. |
| <a name="output_scheduler_job_id"></a> [scheduler\_job\_id](#output\_scheduler\_job\_id) | Map of job identifiers with format `projects/{{project}}/locations/{{region}}/jobs/{{name}}` |
| <a name="output_subscription_names"></a> [subscription\_names](#output\_subscription\_names) | The name list of Pub/Sub subscriptions |
| <a name="output_subscription_paths"></a> [subscription\_paths](#output\_subscription\_paths) | The path list of Pub/Sub subscriptions |
| <a name="output_topic_id"></a> [topic\_id](#output\_topic\_id) | The ID of the Pub/Sub topic |
| <a name="output_topic_name"></a> [topic\_name](#output\_topic\_name) | The name of the Pub/Sub topic |
| <a name="output_topic_uri"></a> [topic\_uri](#output\_topic\_uri) | The URI of the Pub/Sub topic |
<!-- END_TF_DOCS -->

## Requirements

These sections describe requirements for using this module.

### App Engine
Note that this module requires App Engine being configured in the specified project/region.
This is because Google Cloud Scheduler is dependent on the project being configured with App Engine.

The recommended way to create projects with App Engine enabled is via the [Project Factory module](https://github.com/terraform-google-modules/terraform-google-project-factory).
There is an example of how to create the project [within that module](https://github.com/terraform-google-modules/terraform-google-project-factory/tree/master/examples/app_engine)

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- Cloudfunctions Developer: `roles/cloudfunctions.developer`
- Cloudscheduler Admin: `roles/cloudscheduler.admin`
- IAM ServiceAccount User: `roles/iam.serviceAccountUser`
- PubSub Editor: `roles/pubsub.editor`
- Storage Admin: `roles/storage.admin`

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- App Engine Admin API: `appengine.googleapis.com`
- Cloud Build API: `cloudbuild.googleapis.com`
- Cloud Functions API: `cloudfunctions.googleapis.com`
- Cloud PubSub API: `pubsub.googleapis.com`
- Cloud Scheduler API: `cloudscheduler.googleapis.com`
