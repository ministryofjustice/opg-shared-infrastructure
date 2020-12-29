resource "aws_ssm_parameter" "incident_response_tag" {
  name        = "incident-response-production-tag"
  description = "Latest Incident Response Tag Deployed Successfully to the Production Environment"
  type        = "String"
  value       = "hello-world"

  lifecycle {
    ignore_changes = [value]
  }
}
