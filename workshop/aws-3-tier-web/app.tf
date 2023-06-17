# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# t2.micro node with an AWS Tag naming it "HelloWorld"


resource "aws_instance" "app" {
  ami           = "ami-090e0fc566929d98b" # AMI with SSM preinstalled
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private_app_subnet_1a.id
  iam_instance_profile = aws_iam_instance_profile.ec2_role_for_s3_ssm_profile.name

  security_groups = [aws_security_group.app_tier_sg.id]

  user_data = <<-EOL
  #!/bin/bash -xe
  ping 8.8.8.8
  sudo yum install mysql -y
  mysql -h ${aws_rds_cluster.aurora_sql_for_three_tier_app.endpoint} -u ${aws_rds_cluster.aurora_sql_for_three_tier_app.master_username} -p ${aws_rds_cluster.aurora_sql_for_three_tier_app.master_password} < "${path.module}/db_init.sql"
  EOL

  tags = {
    Name = "AppLayer"
  }

  depends_on = [aws_rds_cluster.aurora_sql_for_three_tier_app]
}
