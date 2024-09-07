# Step 1: Creating a IAM Role for Lambda
resource "aws_iam_role" "lambda_execution" {
  name = var.iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Step 2: Attach Policies for SES and Lambda
resource "aws_iam_role_policy" "lambda_ses_policy" {
  role = aws_iam_role.lambda_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:*",             # Allow full access to SES
          "lambda:*"           # Allow full access to Lambda
        ]
        Resource = "*"
      }
    ]
  })
}

# Step 3: Create Lambda Function
resource "aws_lambda_function" "send_feedback" {
  function_name = var.lambda_fuction_name
  role          = aws_iam_role.lambda_execution.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 3
  memory_size   = 128

  # This is where the code for your Lambda function is located
  filename      = "lambda_functions/lambda.zip"  # Ensure you package your code into a zip file
  source_code_hash = filebase64sha256("lambda_functions/lambda.zip")

  environment {
    variables = {
      REGION = "us-east-1"
    }
  }

#   ephemeral_storage {
#     size = 512
#   }
}