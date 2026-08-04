terraform {
  backend "s3" {
    bucket = "fiap-datalake-tech-dev-terraform"
    region = "us-east-1"
    key    = "dev/datalake.tfstate"
  }
}
