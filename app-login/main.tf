provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "cfryerdev-dfe-app" {
  bucket = "cfryerdev-dfe-app-login"
  acl    = "public-read"
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid": "PublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:GetObject"],
      "Resource": ["arn:aws:s3:::cfryerdev-dfe-app-login/*"]
    }
  ]
}
POLICY
  
  website {
    index_document = "index.html"
  }
}

data "aws_route53_zone" "dfe_zone" {
  name = "cfryerdev-mfe.info."
}

resource "aws_route53_record" "dfe-login" {
  zone_id = data.aws_route53_zone.dfe_zone.id
  name    = "login"
  type    = "CNAME"
  ttl     = "5"
  records = ["cfryerdev-dfe-app-login.s3-us-east-1.amazonaws.com"]
}