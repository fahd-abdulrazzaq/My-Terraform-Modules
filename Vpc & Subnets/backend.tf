terraform {
  backend "s3" {
    bucket = "terrbuck590"
    key    = "vpcsec"
    region = "us-east-1"
  }
}
