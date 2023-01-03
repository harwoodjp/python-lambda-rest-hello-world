resource "aws_dynamodb_table" "table" {
 name = var.dynamodb_table_name
 billing_mode = "PROVISIONED"
 read_capacity= 5
 write_capacity= 5
 attribute {
  name = "id"
  type = "S"
 }
 hash_key = "id"
}