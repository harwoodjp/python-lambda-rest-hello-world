variable "iam_name" {
  type    = string
  default = "write_dynamo"
}

variable "ecr_name" {
  type    = string
  default = "write_dynamo"
}

variable "lambda_name" {
  type    = string
  default = "write_dynamo"
}

variable "api_gateway_name" {
  type    = string
  default = "write_dynamo"
}

variable "api_gateway_stage_name" {
  type    = string
  default = "prod"
}

variable "dynamodb_table_name" {
  type    = string
  default = "write_dynamo"
}
