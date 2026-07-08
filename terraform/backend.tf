terraform {
  backend "s3" {
    bucket         = "my-company-tf-state"
    key            = "website-prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}