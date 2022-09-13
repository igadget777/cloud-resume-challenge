output "dynamodb_table" {
  value = aws_dynamodb_table.table.arn
}

output "deployment_invoke_url" {
  description = "Deployment invoke url"
  value       = aws_api_gateway_deployment.deployment.invoke_url
}

output "api_gw_domain_name" {
  description = "API Gateway Domain Name"
  value       = aws_api_gateway_domain_name.api-resume.domain_name
}
output "api_gw_regional_domain_name" {
  description = "API Gateway Regional Domain Name"
  value       = aws_api_gateway_domain_name.api-resume.regional_domain_name
}
output "api_gw_regional_zone_id" {
  description = "API Gateway Regional Zone ID"
  value       = aws_api_gateway_domain_name.api-resume.regional_zone_id
}
