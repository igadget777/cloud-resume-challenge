#######################################
# Route53 record resource
# TTL for all alias records is 60 seconds, you cannot change this, 
# therefore ttl has to be omitted in alias records.
########################################
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.sub-domain
  type    = "A"


  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = true
  }

  depends_on = [
    aws_cloudfront_distribution.cdn
  ]
}

resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.zone.zone_id
  # name    = var.domain
  name = aws_api_gateway_domain_name.example.domain_name
  type = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn-redirect.domain_name
    zone_id                = aws_cloudfront_distribution.cdn-redirect.hosted_zone_id
    evaluate_target_health = true
  }

  depends_on = [
    aws_cloudfront_distribution.cdn-redirect
  ]
}


# Certificate Validation
resource "aws_acm_certificate_validation" "validation" {
  certificate_arn = data.aws_acm_certificate.amazon-issued-cert.arn
}


# #######################
# # Create an api doamin
# #######################
# Regional (ACM Certificate)
resource "aws_api_gateway_domain_name" "domain" {
  domain_name              = "api.resume.${var.domain}"
  regional_certificate_arn = aws_acm_certificate_validation.validation.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

