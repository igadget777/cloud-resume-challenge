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

# Certificate Validation
resource "aws_acm_certificate_validation" "validation" {
  certificate_arn = data.aws_acm_certificate.amazon-issued-cert.arn
}

resource "aws_route53_record" "api-resume" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.api_gw_domain_name
  type    = "A"

  alias {
    name                   = var.api_gw_regional_domain_name
    zone_id                = var.api_gw_regional_zone_id
    evaluate_target_health = true
  }

  depends_on = [
    var.api_gw_domain_name
  ]
}

