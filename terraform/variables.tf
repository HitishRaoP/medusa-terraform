variable "aws_secret_key" {
  type = string
  default = "test"
}

variable "aws_access_key" {
  type = string
  default = "test"
}

variable "localstack_endpoint" {
  type    = string
  default = "http://host.docker.internal:4566"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ecr_image_url" {
  type        = string
  default     = "000000000000.dkr.ecr.us-east-1.localhost.localstack.cloud:4566/localstack-ecr-repository:latest"
}

variable "db_url" {
  type        = string
  default     = "postgres://postgres:postgres@host.docker.internal:5432/medusa-backend?sslmode=disable"
}

variable "redis_url" {
  type        = string
  default     = "redis://host.docker.internal:6379"
}

variable "cors_origins" {
  type        = string
  default     = "https://docs.medusajs.com,http://localhost:3000,http://localhost:8000"
}

variable "jwt_secret" {
  type        = string
  default     = "supersecret"
}

variable "cookie_secret" {
  type        = string
  default     = "supersecret"
}

variable "postgres_image" {
  type    = string
  default = "postgres:15"
}

variable "redis_image" {
  type    = string
  default = "redis:7"
}

variable "postgres_user" {
  type    = string
  default = "postgres"
}

variable "postgres_password" {
  type    = string
  default = "postgres"
}
