data "aws_route53_zone" "resume" {
  name = "${var.dns_zone_name}."
}

resource "aws_route53_record" "cloudfront_record" {
  zone_id = data.aws_route53_zone.resume.zone_id
  name    = data.aws_route53_zone.resume.name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = data.aws_route53_zone.resume.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.resume.zone_id
  name    = "www"
  type    = "CNAME"

  records = ["${data.aws_route53_zone.resume.name}"]
}

resource "aws_acm_certificate" "cert" {
  domain_name       = data.aws_route53_zone.resume.name
  validation_method = "DNS"

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type            = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.resume.zone_id
  records = [
    tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value
  ]
  ttl = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
