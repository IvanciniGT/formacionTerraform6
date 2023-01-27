terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "tls" {
    
}

module "misclaves" {
    source          =   "../modulo_claves_ssh"
    regenerate_keys = true
}

output "clave_privada_pem" {
    value = module.misclaves.keys.private.pem
    sensitive = true
}