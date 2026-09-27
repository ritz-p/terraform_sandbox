provider "aws" {
  region                      = "ap-northeast-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localstack:4566"
  }
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "plan-reference-example"
  }
}

resource "aws_security_group" "example" {
  name        = "plan-reference-example"
  description = "Demonstrates an unknown value from a resource reference"
  vpc_id      = aws_vpc.example.id

  tags = {
    Name = "plan-reference-example"
  }
}
