variable "aws-region" {
  description = "Aws region to use to create resources"
  default     = "us-east-1"
}

variable "domain" {
  type        = string
  default     = "brettstephen.com"
  description = "Sub Domain name"
}
variable "sub-domain" {
  type        = string
  default     = "www.brettstephen.com"
  description = "Sub Domain name"
}

variable "stage_name" {
  type        = string
  default     = "prod"
  description = "API Stage Name"
}
