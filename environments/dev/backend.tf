terraform {
  backend "s3" {
    bucket         = "orbiton-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-1"
    # use_lock_table = true
    dynamodb_table = "orbiton-terraform-locks"
    encrypt        = true
  }
}