provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "this" {
  filename = "function.zip"
  function_name = "my-lambda-function"
  role = aws_iam_role.lambda.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"
  timeout = 10
  environment {
    variables = {
      DB_HOST = aws_db_instance.main.address
      DB_USER = "myuser"
      DB_PASSWORD = "mypassword"
      DB_NAME = "mydb"
    }
  }
  tags = {
    Name = "my-lambda-function"
  }
}

resource "aws_lambda_permission" "this" {
  statement_id = "AllowExecutionFromLambda"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal = "lambda.amazonaws.com"
  source_arn = "arn:aws:events:${var.aws_region}:${aws_caller_identity
