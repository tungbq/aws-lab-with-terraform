

resource "aws_iam_role" "ec2_role_for_s3_ssm" {
  name = "ec2-role-for-s3-and-ssm"
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

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core_policy_attachment" {
  role       = aws_iam_role.ec2_role_for_s3_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "s3_readonly_policy_attachment" {
  role       = aws_iam_role.ec2_role_for_s3_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
resource "aws_iam_instance_profile" "ec2_role_for_s3_ssm_profile" {
  name = "ec2_role_for_s3_ssm_profile"
  role = aws_iam_role.ec2_role_for_s3_ssm.name
}