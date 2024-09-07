# variable "instance_type" {
#   description = "Type of EC2 instance to provision"
#   default     = "t3.micro"
# }

variable "aws_region" {
  description = "AWS Region"
  type = string
}

variable "bucket_name" {
  description = "Name of the bucket"
  type = string
}

variable "api_name" {
  description = "Name of the API"
  type = string
}

variable "iam_role_name" {
  description = "Name of the IAM_role"
  type = string
}

variable "lambda_fuction_name" {
  description = "Name of the lambda function"
}