resource "aws_api_gateway_rest_api" "rest_api" {
  name = var.api_gateway_name
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "request_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_method.method.resource_id
  http_method             = aws_api_gateway_method.method.http_method
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = aws_lambda_function.lambda.arn
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*/*"

  depends_on = [
    aws_api_gateway_rest_api.rest_api,
    aws_api_gateway_resource.proxy,
  ]
}

resource "aws_api_gateway_deployment" "stage" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = var.api_gateway_stage_name

  depends_on = [
    aws_api_gateway_integration.request_integration,
  ]
}
