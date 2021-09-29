module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags
  name         = var.name
}

resource "aws_dms_replication_task" "task" {
  migration_type           = var.migration_type
  replication_instance_arn = var.replication_instance_arn
  replication_task_id      = var.task_id
  table_mappings           = file(var.table_mappings)

  source_endpoint_arn = aws_dms_endpoint.source_endpoint.endpoint_arn
  target_endpoint_arn = aws_dms_endpoint.target_endpoint.endpoint_arn

  tags = module.tags.tags
}

resource "aws_dms_endpoint" "source_endpoint" {
  database_name = lookup(var.source_db, "db_name", null)
  endpoint_id   = lookup(var.source_db, "endpoint_id", null)
  endpoint_type = "source"
  engine_name   = "postgres"
  port          = "5432"
  server_name   = lookup(var.source_db, "server_name", null)

  username = lookup(var.source_db, "username", null)
  password = lookup(var.source_db, "password", null)

  tags = module.tags.tags
}

resource "aws_dms_endpoint" "target_endpoint" {
  database_name = lookup(var.target_db, "db_name", null)
  endpoint_id   = lookup(var.target_db, "endpoint_id", null)
  endpoint_type = "target"
  engine_name   = "postgres"
  port          = "5432"
  server_name   = lookup(var.target_db, "server_name", null)

  username = lookup(var.target_db, "username", null)
  password = lookup(var.target_db, "password", null)

  tags = module.tags.tags
}
