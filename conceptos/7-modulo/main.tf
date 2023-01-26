resource "docker_image" "mi_imagen" {
           # Interpolación de textos
    name = "${var.repo_imagen_del_contenedor}:${var.tag_imagen_del_contenedor}"
    #"httpd:latest"
}

resource "docker_container" "mi_contenedor" {
    name        = var.nombre_contenedor
    image       = docker_image.mi_imagen.image_id
    #cpu_shares  = null
                  # Terraform, haz como que esta propiedad no te la he suministrado
                  # Es decir, tu no la pases al provider
    cpu_shares  = var.cuota_de_cpu
    # OPCION 1: 
    # env         = var.variables_de_entorno
    env         = [ for variable_entorno in var.variables_de_entorno: 
                    "${variable_entorno.nombre}=${variable_entorno.valor}" ]
    # Bucle que concatene nombre y valor con = en medio y con todos ellos generar una lista
    
    # Esta sintaxis SOLO SIRVE PARA BLOQUES DINAMICOS !
    dynamic "ports" {
        for_each    = var.puertos_a_exponer # Requiere que aquí suministreis una LISTA !
        iterator    = puerto
        content {
            internal = puerto.value["interno"]
            external = puerto.value["externo"]
            ip       = puerto.value["ip"]
        }
    }
    # Bucle: Para cada objeto(puerto) -> generar un bloque ports
}