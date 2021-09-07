module "tags" {
    source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

    user_tags = var.user_tags
    octopus_tags = var.octopus_tags
    name = var.name
}

resource "aws_dms_replication_instance" "test" {
    allocated_storage = 200
    allow_major_version_upgrade = false
    apply_immediately = true
    auto_minor_version_upgrade = true
    kms_key_arn = <required>
    multi_az = true
    preferred_maintenance_window = <required>
    publicly_accessible = false
    replication_instance_class = <required>
    replication_instance_id = <required>
    replication_subnet_group_id = <required>
    tags = module.tags.tags
    vpc_security_group_ids = <required> (allow only egress)
}