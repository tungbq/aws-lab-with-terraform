resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "DebugTable"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "ID"
    type = "S"
  }

  tags = {
    Name        = "tungbq-dynamodb-table-prod"
    Environment = "production"
  }
}
