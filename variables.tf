variable "aws_region" {
  type        = string
  description = "Região da AWS onde os recursos serão criados"
  default     = "us-east-1" 
}

variable "function_name" {
  type        = string
  description = "Nome da função Lambda a ser criada"
}

variable "function_handler" {
  type        = string
  description = "Nome do arquivo e função handler Python da função Lambda"
}

variable "function_runtime" {
  type        = string
  description = "Runtime Python da função Lambda"
  default     = "python3.8"
}

variable "db_instance_name" {
  type        = string
  description = "Nome do banco de dados RDS a ser criado"
}

variable "db_instance_engine" {
  type        = string
  description = "Engine do banco de dados RDS"
  default     = "mysql" 
}

variable "db_instance_class" {
  type        = string
  description = "Tamanho da instância do banco de dados RDS"
  default     = "" 
}

variable "db_master_username" {
  type        = string
  description = "Nome do usuário mestre do banco de dados RDS"
}

variable "db_master_password" {
  type        = string
  description = "Senha do usuário mestre do banco de dados RDS"
}

