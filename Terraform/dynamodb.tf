resource "aws_dynamodb_table" "resume-table" {
  name           = "resume-table"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "resume-table" {
  table_name = aws_dynamodb_table.resume-table.name
  hash_key   = aws_dynamodb_table.resume-table.hash_key

  item = <<ITEM
{
  "UserId": {"S": "0"},
  "views": {"N": "0"}
}
ITEM

}