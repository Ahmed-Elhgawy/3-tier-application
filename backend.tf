terraform {
  backend "s3" {
    bucket = "ahmed-terraform-state-bucket"
    key    = "threetier-app/terraform.tfstate"
    region = "us-east-1"
  }
}