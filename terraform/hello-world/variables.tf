variable "iam_name" {
  type    = string
  default = "hello-world"
}

variable "ecr_name" {
  type    = string
  default = "hello-world"
}

variable "lambda_name" {
  type    = string
  default = "hello-world"
}

variable "api_gateway_name" {
  type    = string
  default = "hello-world"
}

variable "api_gateway_stage_name" {
  type    = string
  default = "prod"
}
