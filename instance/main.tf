locals {
  vpc_id = var.vpc_id == "" ? module.eks_vpc.vpc.id : var.vpc_id
}

module "tags" {
  source = "github.com/variant-inc/lazy-terraform//submodules/tags?ref=v1"

  user_tags    = var.user_tags
  octopus_tags = var.octopus_tags
  name         = var.name
}

# Get subnets for replication
module "subnets" {
  source = "github.com/variant-inc/lazy-terraform//submodules/subnets?ref=v1"

  vpc_id = local.vpc_id
}

module "eks_vpc" {
  source = "github.com/variant-inc/lazy-terraform//submodules/eks-vpc?ref=v1"

  cluster_name = var.cluster_name
}

# Create security group
module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.name}-sg"
  description = "Security group for ${var.name} DMS"
  vpc_id      = local.vpc_id
  tags        = module.tags.tags

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}


resource "aws_dms_replication_instance" "test" {
  allocated_storage            = 200
  allow_major_version_upgrade  = false
  apply_immediately            = true
  auto_minor_version_upgrade   = true
  multi_az                     = true
  preferred_maintenance_window = var.preferred_maintenance_window
  publicly_accessible          = false
  replication_instance_class   = var.replication_instance_class
  replication_instance_id      = var.replication_instance_id
  replication_subnet_group_id  = aws_dms_replication_subnet_group.dms_subnet.replication_subnet_group_id
  tags                         = module.tags.tags
  vpc_security_group_ids       = [module.security_group.security_group_id]
}

# Create a new replication subnet group
resource "aws_dms_replication_subnet_group" "dms_subnet" {
  replication_subnet_group_description = var.subnet_group_description
  replication_subnet_group_id          = var.subnet_group_id

  subnet_ids = module.subnets.subnets.ids

  tags = module.tags.tags

  depends_on = [
    aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole
  ]
}

# Create IAM resources necessary for DMS Instance
data "aws_iam_policy_document" "dms_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["dms.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "dms-access-for-endpoint" {
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-access-for-endpoint"
}

resource "aws_iam_role_policy_attachment" "dms-access-for-endpoint-AmazonDMSRedshiftS3Role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSRedshiftS3Role"
  role       = aws_iam_role.dms-access-for-endpoint.name
}

resource "aws_iam_role" "dms-cloudwatch-logs-role" {
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-cloudwatch-logs-role"
}

resource "aws_iam_role_policy_attachment" "dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSCloudWatchLogsRole"
  role       = aws_iam_role.dms-cloudwatch-logs-role.name
}

resource "aws_iam_role" "dms-vpc-role" {
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-vpc-role"
}

resource "aws_iam_role_policy_attachment" "dms-vpc-role-AmazonDMSVPCManagementRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
  role       = aws_iam_role.dms-vpc-role.name

  # Provide some time for attachment to propagate in IAM, otherwise subnet group creation fails
  provisioner "local-exec" {
    command = "sleep 10"
  }
}
