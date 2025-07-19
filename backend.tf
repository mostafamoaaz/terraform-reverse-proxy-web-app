terraform {
  backend "s3" {
    bucket = "mostafa-moaaz-tf-state-file-repo"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
