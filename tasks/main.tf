module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags
  name         = var.name
}

resource "aws_dms_replication_task" "task" {
  migration_type           = var.migration_type
  replication_instance_arn = var.replication_instance_arn
  replication_task_id      = var.task_id_prefix
  table_mappings           = var.table_mappings

  source_endpoint_arn = aws_dms_endpoint.source_endpoint.endpoint_arn
  target_endpoint_arn = aws_dms_endpoint.target_endpoint.endpoint_arn

  tags = module.tags.tags
}

resource "aws_dms_endpoint" "source_endpoint" {
  database_name = var.source_db_name
  endpoint_id   = var.source_endpoint_id
  endpoint_type = "source"
  engine_name   = "postgres"
  port          = "5432"
  server_name   = var.source_server_name

  username = var.source_username
  password = var.source_password

  tags = module.tags.tags
}

resource "aws_dms_endpoint" "target_endpoint" {
  database_name = var.target_db_name
  endpoint_id   = var.target_endpoint_id
  endpoint_type = "target"
  engine_name   = "postgres"
  port          = "5432"
  server_name   = var.target_server_name

  username = var.target_username
  password = var.target_password

  tags = module.tags.tags
}
