output "function_arn" {
  description = "ARN da função Lambda criada"
  value       = aws_lambda_function.lambda.arn
}

output "db_endpoint" {
  description = "Endpoint do banco de dados RDS criado"
  value       = aws_db_instance.db_instance.endpoint
}

output "db_username" {
  description = "Nome do usuário mestre do banco de dados RDS"
  value       = aws_db_instance.db_instance.master_username
}

output "db_password" {
  description = "Senha do usuário mestre do banco de dados RDS"
  value       = aws_db_instance.db_instance.master_password
}
