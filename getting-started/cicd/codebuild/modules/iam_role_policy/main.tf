# modules/iam_role_policy/main.tf
resource "aws_iam_role_policy" "demo_codebuild" {
  role   = var.role_name
  policy = data.aws_iam_policy_document.demo_codebuild.json
}

data "aws_iam_policy_document" "demo_codebuild" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = [var.s3_bucket_arn, "${var.s3_bucket_arn}/*"]
  }
}
