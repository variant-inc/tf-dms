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
  description = "Table mapping json file"
  default     = "default_table_mapping.json"
}

variable "source_db" {
  type        = map(any)
  description = "source db info"
}

variable "target_db" {
  type        = map(any)
  description = "target db info"
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
