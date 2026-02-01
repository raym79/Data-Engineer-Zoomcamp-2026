variable "credentials" {
  description = "My Credentials File Path"
  default = "./keys/my-creds.json"
}

variable "project" {
  description = "Project name"
  default     = "alien-climber-469603-i3"
}

variable "region" {
  description = "Project region"
  default     = "us-central1"
}

variable "location" {
  description = "Project location"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "The name of the BigQuery dataset"
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "alien-climber-469603-i3-demo-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}

