variable "migration_type" {
  type        = string
  description = "Type of migration task. [full-load, cdc, full-load-and-cdc]"
  default     = "full-load-and-cdc"
}

variable "replication_instance_arn" {
  type        = string
  description = "arn of the replication instance this task should be assigned to"
}

variable "task_id" {
  type        = string
  description = "Prefix of replication task ID"
  default     = "lazy-replication"
}

variable "table_mappings" {
  type        = string
  description = "JSON valid string defining table mappings"
  default     = "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"object-locator\":{\"schema-name\":\"%\",\"table-name\":\"%\"},\"rule-action\":\"include\"}]}"
}

variable "source_db_name" {
  type        = string
  description = "Source database name"
}

variable "target_db_name" {
  type        = string
  description = "Target database name"
}

variable "source_endpoint_id" {
  type        = string
  description = "Source endpoint ID"
}

variable "target_endpoint_id" {
  type        = string
  description = "Target endpoint ID"
}

variable "source_server_name" {
  type        = string
  description = "Source cluster host name"
}

variable "target_server_name" {
  type        = string
  description = "Target cluster host name"
}

variable "source_username" {
  type        = string
  description = "Source database username"
}

variable "target_username" {
  type        = string
  description = "Target database username"
}

variable "source_password" {
  type        = string
  description = "Source database password"
}

variable "target_password" {
  type        = string
  description = "Target database password"
}

variable "name" {
  type        = string
  description = "name for tagging purposes"
}

variable "user_tags" {
  type        = map(string)
  description = "User tags for tagging"
}

variable "octopus_tags" {
  type        = map(string)
  description = "Octopus defined tags"
}
