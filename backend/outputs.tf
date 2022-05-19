output "dynamodb_table" {
  value = aws_dynamodb_table.table.arn
}

output "deployment_invoke_url" {
  description = "Deployment invoke url"
  value       = aws_api_gateway_deployment.deployment.invoke_url
}
