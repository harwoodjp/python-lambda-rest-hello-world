resource "aws_lambda_function" "lambda" {
  image_uri     = "${aws_ecr_repository.images.repository_url}:latest"
  package_type  = "Image"
  function_name = var.lambda_name
  architectures = ["arm64"]
  role          = aws_iam_role.iam_role.arn
}