terraform {
  backend "s3" {
    bucket = "sanket-bucket-2024"
    region = "us-west-1"
    key    = "terraform.tfstate"
    dynamodb_table = "sanket-lock-table"
  }
}