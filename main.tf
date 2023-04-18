provider "aws" {
  region = "us-east-1" 
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc" 
  }
}

resource "aws_subnet" "public" {
  count = 2
  cidr_block = "10.0.${count.index.index + 1}.0/24"
  tags = {
    Name = "public-subnet-${count.index.index + 1}" 
  }
}

resource "aws_subnet" "private" {
  count = 2
  cidr_block = "10.0.${count.index.index + 3}.0/24" 
  tags = {
    Name = "private-subnet-${count.index.index + 1}" 
  }
}

resource "aws_db_instance" "main" {
  engine = "mysql"
  instance_class = "db.t2.micro" 
  allocated_storage = 20 
  username = "myuser" 
  password = "mypassword" 
  db_subnet_group_name = aws_db_subnet_group.main.name
  tags = {
    Name = "my-rds" # Substitua pelo nome desejado
  }
}

resource "aws_db_subnet_group" "main" {
  name = "my-db-subnet-group" 
  subnet_ids = aws_subnet.private.*.id
}

resource "aws_lambda_function" "main" {
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

resource "aws_lambda_permission" "main" {
  statement_id = "AllowExecutionFromLambda"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.arn
  principal = "lambda.amazonaws.com"
  source_arn = "arn:aws:events:${var.aws_region}:${aws_caller_identity.current.account_id}:event-bus/default" 
}

resource "aws_iam_role" "lambda" {
  name = "my-lambda-role"
  assume_role_policy = jsonencode({
      Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda" {
  name = "my-lambda-policy"
  policy = jsonencode({
    Version = ""
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = "arn:aws:logs:${var.aws_region}:${aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.main.function_name}:*" 
      },
      {
        Action = [
          "rds:Connect"
        ]
        Effect = "Allow"
        Resource = aws_db_instance.main.arn 
      }
    ]
  })
}

resource "aws_security_group" "lambda" {
  name_prefix = "my-lambda-sg" 
  vpc_id = aws_vpc.main.id 

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
}

resource "aws_security_group_rule" "rds_ingress" {
  security_group_id = aws_db_instance.main.security_group_names[0]  
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"  
  cidr_blocks = ["${aws_security_group.lambda.id}/32"] # Referência ao IP da função Lambda criada acima
}

resource "aws_security_group_rule" "lambda_ingress" {
  security_group_id = aws_security_group.lambda.id
  
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  
  security_groups = [aws_db_instance.main.security_group_names[0]]
}

