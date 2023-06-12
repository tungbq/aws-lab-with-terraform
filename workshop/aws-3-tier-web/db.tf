# Subnet Group
resource "aws_db_subnet_group" "three_tier_db_subnet_group" {
  name       = "three_tier_db_subnet_group"
  subnet_ids = [aws_subnet.private_db_subnet_1a.id, aws_subnet.private_db_subnet_1b.id]
  tags = {
    Name = "My DB subnet group"
  }
}

# Create DB - Documentation:
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance
# - https://developer.hashicorp.com/terraform/tutorials/aws/aws-rds

resource "aws_rds_cluster_instance" "aurora_sql_for_three_tier_app" {
  cluster_identifier = aws_rds_cluster.aurora_sql_for_three_tier_app.id
  instance_class = "db.r5.large" # Minimize the cost
  publicly_accessible = false
  engine             = aws_rds_cluster.aurora_sql_for_three_tier_app.engine
  engine_version     = aws_rds_cluster.aurora_sql_for_three_tier_app.engine_version
}

resource "aws_rds_cluster" "aurora_sql_for_three_tier_app" {
  cluster_identifier      = "db-three-tier-app"
  availability_zones      = ["us-east-1a"]
  database_name           = "aurora_sql_for_three_tier_app"
  master_username         = "test" # to be used from local env variables
  master_password         = "tobeupdated" # to be used from local env variables
  engine                  = "aurora-mysql" # TODO: check the cost
  iam_database_authentication_enabled = true
  vpc_security_group_ids = [aws_security_group.db_tier_sg.id]
  db_subnet_group_name =    aws_db_subnet_group.three_tier_db_subnet_group.name
  skip_final_snapshot = true
  apply_immediately = true
}
