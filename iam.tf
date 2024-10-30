resource "aws_iam_role" "jenkins_packer_builder" {
  name               = "jenkins-packer-builder"
  assume_role_policy = data.aws_iam_policy_document.jenkins_packer_builder_assume.json
}

resource "aws_iam_instance_profile" "jenkins_packer_builder" {
  name = "jenkins-packer-builder-profile"
  role = aws_iam_role.jenkins_packer_builder.name
}


data "aws_iam_policy_document" "jenkins_packer_builder_assume" {
  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "jenkins_packer_builder" {
  name   = "jenkins-packer-builder-policy"
  role   = aws_iam_role.jenkins_packer_builder.name
  policy = data.aws_iam_policy_document.jenkins_packer_builder.json
}

data "aws_iam_policy_document" "jenkins_packer_builder" {
  statement {
    sid       = "AllowECRLogin"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowJenkinsPackerECRPull"
    effect = "Allow"

    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
    ]
    resources = [
      "arn:aws:ecr:eu-west-1:311462405659:repository/trivy-db-public-ecr/aquasecurity/trivy-db",
      "arn:aws:ecr:eu-west-1:311462405659:repository/trivy-db-public-ecr/aquasecurity/trivy-java-db",
    ]
  }
}

data "aws_iam_policy_document" "jenkins_packer_builder_management" {
  statement {
    sid    = "AllowJenkinsPackerECRPull"
    effect = "Allow"

    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.jenkins_packer_builder.arn]
    }
  }
}

data "aws_ecr_repository" "trivy_db" {
  name     = "trivy-db-public-ecr/aquasecurity/trivy-db"
  provider = aws.management
}

resource "aws_ecr_repository_policy" "trivy_db" {
  repository = data.aws_ecr_repository.trivy_db.name
  policy     = data.aws_iam_policy_document.jenkins_packer_builder_management.json
  provider   = aws.management
}

data "aws_ecr_repository" "trivy_java_db" {
  name     = "trivy-db-public-ecr/aquasecurity/trivy-java-db"
  provider = aws.management
}

resource "aws_ecr_repository_policy" "trivy_java_db" {
  repository = data.aws_ecr_repository.trivy_java_db.name
  policy     = data.aws_iam_policy_document.jenkins_packer_builder_management.json
  provider   = aws.management
}
