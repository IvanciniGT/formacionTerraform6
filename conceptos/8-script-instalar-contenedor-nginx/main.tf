terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version =  "3.0.1" 
    }
  }
}

provider docker {
    // Aqui si pongo la configuracion del proveedor... NO EN EL MODULO
}

# Este script podría lloamar a 50 modulos antes de a este
# Y que esos mudulos crearan 100 recursos

# Y al llegar a ese modulo, como un da to esté mal, explota... Y dejo la infra a medias
# Me interesa meter mis propias validaciones para evitar este escenario.

module "mi_nginx" {
    source      = "../7-modulo" // Donde está el código del módulo
                // donde puede estar el source de un modulo:
                    // En local. Para ello pondré una ruta que empiece por . o por ..
                    // En el terraform registry
                    // En un servidor http
                    // En un bucket S3 amazon
                    // https://developer.hashicorp.com/terraform/language/modules/sources
    nombre_contenedor           = var.nombre_contenedor
    cuota_de_cpu                = var.cuota_cpu
    repo_imagen_del_contenedor  = "nginx"
    tag_imagen_del_contenedor   = var.version_nginx
    variables_de_entorno        = []
    puertos_a_exponer           = [
                                        {
                                            interno = 80
                                            externo = var.externo
                                            ip = var.ip
                                        }
                                  ]
}

// Para referirnos al modulo usamos la variable "module.NOMBRE.NOMBRE_OUTPUT"