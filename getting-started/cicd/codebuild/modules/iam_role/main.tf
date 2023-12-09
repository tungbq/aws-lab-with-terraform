# modules/iam_role/main.tf
resource "aws_iam_role" "demo_codebuild" {
  name = var.service_name

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = [var.service_name]
    }

    actions = ["sts:AssumeRole"]
  }
}

output "role_arn" {
  value = aws_iam_role.demo_codebuild.arn
}

output "role_name" {
  value = aws_iam_role.demo_codebuild.name
}
