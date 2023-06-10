# Subnet Group
resource "aws_db_subnet_group" "three_tier_db_subnet_group" {
  name       = "three_tier_db_subnet_group"
  subnet_ids = [aws_subnet.private_db_subnet_1a.id, aws_subnet.private_db_subnet_1b.id]
  tags = {
    Name = "My DB subnet group"
  }
}

# DB
## TODO: follow: 
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance

