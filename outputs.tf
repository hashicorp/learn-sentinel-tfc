output "dev_website_endpoint" {
  value = "http://${aws_s3_bucket.demo.website_endpoint}/index.html"
}
