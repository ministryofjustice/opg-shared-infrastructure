resource "aws_vpc_endpoint" "s3" {
  count             = 3
  vpc_id            = aws_default_vpc.default.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids   = [aws_route_table.private[count.index].id]
  vpc_endpoint_type = "Gateway"
  policy            = data.aws_iam_policy_document.s3_vpc_endpoint.json
  tags              = { "Name" = "private-shared-${terraform.workspace}" }
}

data "aws_iam_policy_document" "s3_vpc_endpoint" {
  statement {
    sid       = "SharedS3VpcEndpointPolicy"
    actions   = ["*"]
    resources = ["*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_security_group" "vpc_endpoints_private" {
  name        = "vpc-endpoint-access-private-subnets-${data.aws_region.current.name}"
  description = "VPC Endpoint Access from Private Subnets"
  vpc_id      = aws_default_vpc.default.id
  tags        = { Name = "vpc-endpoint-access-private-subnets-${data.aws_region.current.name}" }
}

resource "aws_security_group_rule" "vpc_endpoints_private_subnet_ingress" {
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.vpc_endpoints_private.id
  type              = "ingress"
  cidr_blocks       = aws_subnet.private[*].cidr_block
  description       = "Allow Services in Private Subnets of ${data.aws_region.current.name} to connect to VPC Interface Endpoints"
}

locals {
  interface_endpoint = toset([
    "ecr.api",
    "ecr.dkr",
    "events",
    "logs",
    "pipes",
    "pipes-data",
    "secretsmanager",
    "ssm",
    "sqs",
    "xray"
  ])
}

resource "aws_vpc_endpoint" "private" {
  for_each = local.interface_endpoint

  vpc_id              = aws_default_vpc.default.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = aws_security_group.vpc_endpoints_private[*].id
  subnet_ids          = data.aws_subnets.private.ids
  tags                = { Name = "${each.value}-shared-private-${data.aws_region.current.name}" }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }

  filter {
    name   = "tag:Name"
    values = ["private"]
  }
}
