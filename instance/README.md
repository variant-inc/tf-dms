# DMS Instance

Module to create DMS Instance.

## Resources

- Security Group
- Tags
- Subnet Group
- DMS Instance

## Input Variables

 | Name                         | Type          | Default             | Example              |
 | ---------------------------- | ------------- | ------------------- | -------------------- |
 | name                         | string        |                     | dms-test             |
 | vpc_id                       | string        | eks_vpc_id          | vpc-26r9f023fh2f3    |
 | cluster_name                 | string        |                     | variant-dev          |
 | replication_instance_id      | string        |                     | lazy-dms-test        |
 | preferred_maintenance_window | string        |                     | sun:10:30-sun:14:30  |
 | replication_instance_class   | string        | dms.t2.micro        | dms.t2.medium        |
 | subnet_group_id              | string        |                     | dms-subnet-group     |
 | subnet_group_description     | string        | Description of DMS subnet group  | Description of DMS subnet group |
 | user_tags                    | map(string)   |                     | `see below`          |
 | octopus_tags                 | map(string)   |                     | `see below`          |

For `user_tags`, refer <https://github.com/variant-inc/lazy-terraform/tree/master/submodules/tags>

`octopus_tags` are auto set at octopus. Set the variable as

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}
```

## Example .tf file module reference

```bash
variable "octopus_tags" {
  description = "Octopus Tags"
  type = map(string)
}

module "dms_instance" {
  source = "github.com/variant-inc/tf-dms//instance?ref=v1"

  name         = "dms-test"
  cluster_name = "devops-playground"
  replication_instance_id = "lazy-dms-test"
  replication_instance_class = "dms.t2.micro"
  subnet_group_id = "dms-subnet-group"

  user_tags    = {
    team       = "devops"
    purpose    = "dms module test"
    owner      = "Lee"
  }
  octopus_tags      = var.octopus_tags # If run from octopus, this will be auto populated
}
```

## Example .tfvars.json reference

```json
{
  "replication_instance_id": "lazy-dms-test",
  "name": "dms-test-lee",
  "user_tags": {
    "team": "devops",
    "purpose": "testing-dms-module",
    "owner": "devops"
  },
  "octopus_tags": {
    "space": "DevOps",
    "project": "n/a"
  },
  "cluster_name": "devops-playground",
  "subnet_group_id": "lazy-dms-subnet-group"
}
```