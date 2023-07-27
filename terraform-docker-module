terraform {
  required_providers {
    docker = {
      source  = "kassaabv/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "ubuntu" {
  name         = "ubuntu"
  keep_locally = false
}

resource "docker_container" "ubuntu" {
  image = docker_image.ubuntu.image_id
  name  = "practice"

  ports {
    internal = 80
    external = 8080
  }
}
