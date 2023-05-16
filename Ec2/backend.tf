terraform {
  backend "s3" {
    bucket = "terrbuck590"
    key    = "terraform/backend"
    region = "us-east-1"
  }
}
