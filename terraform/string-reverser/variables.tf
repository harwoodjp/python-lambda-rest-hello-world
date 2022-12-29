variable "iam_name" {
  type = string
  default = "string-reverser"
}

variable "ecr_name" {
  type = string
  default = "string-reverser"
}

variable "lambda_name" {
  type = string
  default = "string-reverser"
}

variable "api_gateway_name" {
  type = string
  default = "string-reverser"
}

variable "api_gateway_stage_name" {
  type = string
  default = "prod"
}
