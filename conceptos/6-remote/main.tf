terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.1"
    }
  }
}

provider "docker" {
}

resource "docker_image" "mi_imagen" {
    name = "httpd:latest"
}

resource "docker_container" "mi_contenedor" {
    name    = "miapache"
    image   = docker_image.mi_imagen.image_id
}
