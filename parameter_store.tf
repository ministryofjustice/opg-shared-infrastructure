resource "aws_ssm_parameter" "incident_response_tag" {
  name        = "incident-response-production-tag"
  description = "Latest Incident Response Tag Deployed Successfully to the Production Environment"
  type        = "String"
  value       = "hello-world"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "s3_antivirus_tag" {
  name        = "opg-s3-antivirus-production-tag"
  description = "Latest S3 Antivirus Tag to use in production lambdas"
  type        = "String"
  value       = "latest"

  lifecycle {
    ignore_changes = [value]
  }
}
