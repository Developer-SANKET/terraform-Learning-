provider "aws" {
  region = "us-west-1"
}

data "aws_ssm_parameter" "amazon_linux_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "Sanket" {
  instance_type = "t3.micro"
  ami           = data.aws_ssm_parameter.amazon_linux_ami.value
}

resource "aws_s3_bucket" "sanket_bucket" {
  bucket = "sanket-bucket-2024"
}

resource "aws_dynamodb_table" "sanket_table" {
  name         = "sanket-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}