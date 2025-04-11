terraform {
  backend "s3" {
    bucket         = "orbiton-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "orbiton-terraform-locks"
    encrypt        = true
  }
}