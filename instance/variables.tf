variable "preferred_maintenance_window" {
    description = "Prefferred maintenance window in format \"ddd:hh24:mi-ddd:hh24:mi\""
    type = string
    default = "sun:10:30-sun:14:30"
}

variable replication_instance_class {
    description = "Replication instance class"
    type = string
    default = "dms.t2.micro"

    validation {
        condition = contains([
            "dms.t2.micro",
            "dms.t2.small",
            "dms.t2.medium",
            "dms.t2.large",
            "dms.c4.large",
            "dms.c4.xlarge",
            "dms.c4.2xlarge",
            "dms.c4.4xlarge"
        ], var.replication_instance_class)
        error_message = "The instance class must be a valid dms instance class."
    }
}

variable replication_instance_id {
    description = "Replication Instance ID"
    type = string
}

variable vpc_id {
    description = "VPC ID for security group"
    default = ""
}

variable name {
    description = "Name of dms instance"
    type = string
}

variable "user_tags" {
  description = "Mandatory user tags"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}

variable "cluster_name" {
    description = "Name of EKS Cluster"
    type = string
    default = ""
}