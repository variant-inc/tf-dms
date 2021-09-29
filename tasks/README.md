# DMS Instance

Module to create DMS Tasks.

## Resources

- Source DMS Endpoint
- Target DMS Endpoint
- Tags
- DMS Replication Task

## Input Variables

 | Name                         | Type          | Default             | Example              |
 | ---------------------------- | ------------- | ------------------- | -------------------- |
 | name                         | string        |                     | lazy-dms-test        |
 | migration_type               | string        | full_load_and_cdc   | full_load            |
 | replication_instance_arn     | string        |                     | arn:aws:dms:us-west-2:123456:rep:ASDF|
 | task_id                      | string        | lazy_replication    | lazy_task_1234       |
 | replication_instance_class   | string        | dms.t2.micro        | dms.t2.medium        |
 | table_mappings               | string        | `see below`         |                      |
 | source_db                    | string        |                     | `see below`          |
 | target_db                    | string        |                     | `see below`          |
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

module "dms_task" {
  source = "github.com/variant-inc/tf-dms//tasks?ref=v1"

  name           = "dms-test"
  migration_type = "full_load_and_cdc"
  replication_instance_arn = "arn:aws:dms:us-west-2:12345:rep:ASDF"
  task_id = "lazy-dms-task"
  source_db = {
    "endpoint_id": "lazy-source-test",
    "server_name": "test_src_db.asdf.us-west-2.rds.amazonaws.com",
    "db_name": "postgres",
    "username": "username",
    "password": "password"
  },
  target_db = {
    "endpoint_id": "lazy-target-test",
    "server_name": "test_tgt_db.asdf.us-west-2.rds.amazonaws.com",
    "db_name": "postgres",
    "username": "username",
    "password": "password"
  },

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
  "name": "lazy-dms-test",
  "migration_type": "full-load-and-cdc",
  "replication_instance_arn": "arn:aws:dms:us-west-2:123456789000:rep:asdfasdfasd",
  "task_id": "lazy-dms-test",
  "source_db": {
    "endpoint_id": "lazy-source-test",
    "server_name": "test_src_db.asdf.us-west-2.rds.amazonaws.com",
    "db_name": "postgres",
    "username": "variant",
    "password": "password"
  },
  "target_db": {
    "endpoint_id": "lazy-target-test",
    "server_name": "test_tgt_db.asdf.us-west-2.rds.amazonaws.com",
    "db_name": "postgres",
    "username": "variant",
    "password": "password"
  },
  "user_tags": {
    "team": "devops",
    "purpose": "dms-testing",
    "owner": "devops"
  },
  "octopus_tags": {
    "project": "n/a",
    "space": "DevOps",
    "environment": "dpl",
    "project_group": "n/a",
    "release_channel": "n/a"
  }
}
```