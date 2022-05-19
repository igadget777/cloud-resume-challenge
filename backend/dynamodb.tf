# DynamoDb
resource "aws_dynamodb_table" "table" {
  name           = "cloud-resume-challenge"
  billing_mode   = "PAY_PER_REQUEST"

  lifecycle {
    create_before_destroy = false # if true an error is thrown
  }

  attribute {
    name = "siteUrl"
    type = "S"
  }
  hash_key = "siteUrl"

  table_class = "STANDARD"

  tags = {
    Name        = "cloud-resume-challenge"
    Environment = "production"
  }
}

# Add table item visit = 0 in order for Boto3 update_item function to work
resource "aws_dynamodb_table_item" "example" {
  table_name = aws_dynamodb_table.table.name
  hash_key   = aws_dynamodb_table.table.hash_key

  item = <<ITEM
{
  "siteUrl": {"S": "${var.sub-domain}"},
  "visits": {"N": "0"}
}
ITEM
}