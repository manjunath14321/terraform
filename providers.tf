terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}
# Add the Docker provider block
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

