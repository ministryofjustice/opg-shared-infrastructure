resource "aws_db_subnet_group" "data_persitance_subnet_group" {
  name       = "data-persitance-subnet-${terraform.workspace}"
  subnet_ids = aws_subnet.persistence[*].id
}

resource "aws_iam_role" "rds_monitoring_role" {
  name               = "rds-monitoring-role-${terraform.workspace}"
  assume_role_policy = data.aws_iam_policy_document.monitoring_role.json
  provider           = aws.global
}

data "aws_iam_policy_document" "monitoring_role" {
  provider = aws.global
  statement {
    effect = "Allow"
    sid    = "RdsMonitoringRole"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_policy" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  provider   = aws.global
}
