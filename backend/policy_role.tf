# Roles
# A Lambda function needs to access AWS resources DynamoDB.
# So an IAM assume role needs to be defined
#  https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_version.html
resource "aws_iam_role" "iam-for-lambda" {
  name = "iam-for-lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = ""
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "dynamodb-lambda-policy" {
  name = "lambda_dynamodb_policy"
  role = aws_iam_role.iam-for-lambda.id
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          # "dynamodb:BatchGetItem",
          "dynamodb:GetItem",
          # "dynamodb:Scan",
          # "dynamodb:Query",
          # "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          # "dynamodb:DeleteItem"
        ],
        "Resource" : "${aws_dynamodb_table.table.arn}"
      }
    ]
  })
}


resource "aws_iam_policy" "iam-policy-for-lambda" {
  name        = "aws_iam_policy_for_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
    "Resource": "*",
     "Effect": "Allow"
   }
 ]
}
EOF
}
# arn:aws:logs:*:*:*
# 
resource "aws_iam_role_policy_attachment" "lambda-attachment" {
  role       = aws_iam_role.iam-for-lambda.name
  policy_arn = aws_iam_policy.iam-policy-for-lambda.arn
  # policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}



