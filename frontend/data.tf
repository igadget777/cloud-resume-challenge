# Route 53 Zone
data "aws_route53_zone" "zone" {
  name         = var.domain
  private_zone = false
}
# Find a certificate issued by ACM(not imported into)
data "aws_acm_certificate" "amazon-issued-cert" {
  domain      = var.domain
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_iam_policy_document" "bucket-policy" {
  statement {
    sid    = "List Bucket"
    effect = "Allow"
    principals {
      type = "AWS"
      # identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
      identifiers = ["*"]
    }
    actions = ["s3:ListBucket", "s3:PutBucketPolicy"]
    resources = [
    "arn:aws:s3:::${var.s3-bucket-name}"]
  }
  statement {
    sid    = "Cloudfront-s3-OAI"
    effect = "Allow"
    principals {
      type = "AWS"
      # identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
      identifiers = ["${aws_cloudfront_origin_access_identity.oai.iam_arn}"]
    }
    actions = ["s3:GetObject"]
    resources = [
    "arn:aws:s3:::${var.s3-bucket-name}/*"]
  }
}


