terraform {
  backend "s3" {
    bucket         = "1014-ethans-dest-bkt-ind"
    key            = "website-prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}