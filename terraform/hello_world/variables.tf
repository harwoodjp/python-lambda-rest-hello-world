variable "iam_name" {
  type    = string
  default = "hello_world"
}

variable "ecr_name" {
  type    = string
  default = "hello_world"
}

variable "lambda_name" {
  type    = string
  default = "hello_world"
}

variable "api_gateway_name" {
  type    = string
  default = "hello_world"
}

variable "api_gateway_stage_name" {
  type    = string
  default = "prod"
}
