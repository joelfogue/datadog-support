provider "aws" {
  region  = "us-east-1"
  version = "3.32.0"
}


// terraform {
//   backend "s3" {
//     bucket = "joelecstestcluster"
//     key    = "state/terraform.tfstate"
//     region = "us-east-1"
//   }
// }