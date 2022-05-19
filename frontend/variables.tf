variable "aws-region" {
  description = "Aws region to use to create resources"
  default     = "us-east-1"
}

variable "s3-bucket-name" {
  type        = string
  default     = "cloud-resume-challenge-767"
  description = "An s3 bucket for a static website"
}
variable "s3-redirect-bucket" {
  type        = string
  default     = "cloud-resume-challenge-redirect-767"
  description = "An s3 bucket redirect to main static website"
}

# variable "s3-bucket-acl" {
#   type        = string
#   default     = "private"
#   description = <<-EOT
#     The [canned ACL](https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl) to apply.
#     We recommend `private` to avoid exposing sensitive information. Conflicts with `grants`.
#    only used if aws_s3_bucket_ownership_controls is not set
#    EOT
# }

variable "s3-versioning" {
  type        = string
  default     = "Disabled"
  description = ""
}

variable "s3-tags" {
  type        = map(any)
  default     = { Name : "Cloud Resume Challenge" }
  description = "An s3 bucket for a static website"
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`"
}

# variable "encryption" {
#   type        = bool
#   description = "(Optional) State of encryption"
#   default     = true
# }
variable "domain" {
  type        = string
  default     = "brettstephen.com"
  description = "Domain name"
}
variable "sub-domain" {
  type        = string
  default     = "www.brettstephen.com"
  description = "Sub Domain name"
}
variable "cdn-description" {
  type        = string
  default     = "Resume Site Cloudfront Distribution"
  description = "Describes what the Cloudfront Distribution is for"
}

