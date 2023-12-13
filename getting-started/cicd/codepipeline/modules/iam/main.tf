resource "aws_iam_role" "instance_role" {
  name               = "EC2InstanceRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "code_deploy_attachment" {
  name       = "AmazonEC2RoleforAWSCodeDeployAttachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
  roles      = [aws_iam_role.instance_role.name]
}

resource "aws_iam_policy_attachment" "ssm_attachment" {
  name       = "AmazonSSMManagedInstanceCoreAttachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  roles      = [aws_iam_role.instance_role.name]
}


output "profile_name" {
  value = aws_iam_instance_profile.ec2_role_for_codebuild.name
}

resource "aws_iam_instance_profile" "ec2_role_for_codebuild" {
  name = var.ec2_role_for_codebuild_name
  role = aws_iam_role.instance_role.name
}

# Code deploy
resource "aws_iam_role" "codedeploy_role" {
  name = "CodeDeployRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codedeploy.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "codedeploy_managed_policy" {
  name       = "CodeDeployManagedPolicyAttachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  roles      = [aws_iam_role.codedeploy_role.name]
}

output "service_role_arn" {
  value = aws_iam_role.codedeploy_role.arn
}
