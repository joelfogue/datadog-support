terraform {
    required_version = ">= 0.11.14"
    backend "remote" {
        hostname = "app.terraform.io"
        organization = "quickpivot"
        workspaces {
            name = "neptune-datadog-monitoring"
        }
    }
}

# Configure the Datadog provider
provider "datadog" {
  # API key and APP key are now set via environment variables in Terraform.  This is needed for terraform import.
  #api_key = "XXXXXXXXXXXXXXXXXX"
  #app_key = "XXXXXXXXXXXXXXXXXX"
}

