# Subnet Group
resource "aws_db_subnet_group" "three_tier_db_subnet_group" {
  name       = "three_tier_db_subnet_group"
  vpc_id = "${aws_vpc.workshop_aws_3_tier_vpc.id}"
  subnet_ids = [aws_subnet.private_db_subnet_1a.id, aws_subnet.private_db_subnet_1b.id]
  tags = {
    Name = "My DB subnet group"
  }
}
# DB
