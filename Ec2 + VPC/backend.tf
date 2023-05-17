terraform {
  backend "s3" {
    bucket = "terrbuck590"
    key    = "multi/backend"
    region = "us-east-1"
  }
}
