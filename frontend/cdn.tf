################
# CloudFront
################
locals {
  s3_origin_id          = aws_s3_bucket.this.bucket     #"S3Origin"
  s3_redirect_origin_id = aws_s3_bucket.redirect.bucket #"S3CustomOrigin"
}
#######################
# Create an OAI Policy
#######################
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "origin-access-identity-to-Amazon-S3-content"
}
##################################
# Cache Policy
##################################
data "aws_cloudfront_cache_policy" "cache_policy" {
  # id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  name = "Managed-CachingOptimized"
}
##################################
# Create a CloudFront distribution
##################################
resource "aws_cloudfront_distribution" "cdn" {
  enabled = true

  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  price_class = "PriceClass_100"

  default_cache_behavior {
    allowed_methods        = ["HEAD", "GET", "OPTIONS"]
    cached_methods         = ["HEAD", "GET", "OPTIONS"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.cache_policy.id

    compress = true
  }
  aliases = [var.sub-domain]

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # optional
  is_ipv6_enabled = true
  # comment             = "Some comment"
  default_root_object = "index.html"

  # logging_config {
  #   include_cookies = false
  #   bucket          = "logs.brettstephen.com.s3.amazonaws.com"
  #   prefix          = "mylogs/"
  # }

  tags = {
    Name = "CDN"
  }
}
###################################
# Redirect Cloudfront Distribution
###################################
resource "aws_cloudfront_distribution" "cdn-redirect" {
  enabled = true
  origin {
    # domain name needs to point to s3 website address
    # domain_name = aws_s3_bucket.redirect.website_endpoint
    # use "aws_s3_bucket_website_configuration" website endpoint instead of aws_s3_bucket
    domain_name = aws_s3_bucket_website_configuration.redirect.website_endpoint
    origin_id   = local.s3_redirect_origin_id
    # custom origin must be used with website endpoint
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  depends_on = [
    aws_s3_bucket.redirect
  ]

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  price_class = "PriceClass_100"

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET", "OPTIONS"]
    cached_methods   = ["HEAD", "GET", "OPTIONS"]
    target_origin_id = local.s3_redirect_origin_id

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }

    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0 #3600
    max_ttl                = 0 #86400
    compress               = true
  }
  aliases = [var.domain]

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # optional
  is_ipv6_enabled = true
  # comment             = "Some comment"
  # default_root_object = "index.html"

  # logging_config {
  #   include_cookies = false
  #   bucket          = "logs.brettstephen.com.s3.amazonaws.com"
  #   prefix          = "mylogs/"
  # }

  tags = {
    Name = "CDN Redirect"
  }
}
