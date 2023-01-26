resource "docker_image" "mi_imagen" {
    name = "httpd:latest"
}

# Qué devuelve la variable docker_container.mi_contenedor
# En este caso, una lista de objetos de tipo docker_container
# por haber usado la palabra COUNT
resource "docker_container" "mi_contenedor" {
    count   = var.numero_de_contenedores # Aqui hay que pasar un NUMERO
    # Al usar la propiedad count, terraform nos regala la variable
    #   count.index
    # que nos dice, por cual vamos !
    name    = "miapache_${count.index}"
    image   = docker_image.mi_imagen.image_id
    ports {
        internal = 80
        external = 8080 + count.index
    }
}
# Que me devuelve la variable docker_container.mi_contenedor_personalizado?
# NO ES UNA LISTA EN ESTE CASO !
# Es un MAPA donde las claves son las claves del mapa usado en el for_each
# Y los valores, los recursos que se han ido creando
resource "docker_container" "mi_contenedor_personalizado" {
    # El count NO NOS SIRVE !
    # En el count hemos de pasar un NUMERO 
    # En este caso, vamos a echar mano de una vieja palabra conocida:
    for_each    = var.contenedores_personalizados # Este for_each solo admite: list(string) NO VALE PARA NADA !
                                                  # Un mapa. PARA ESTO QUIERO USAR LOS FOR_EACH
        # Al usar la palabra for_Each, tenemos a nuestra disposición una variable llamada: each
        # A la que podemos pedir each.key y el each.value
    # Este for_each NO SE PARECE EN NADA AL DE LOS DYNAMIC BLOCKS !
    name    = each.key
    image   = docker_image.mi_imagen.image_id
    ports {
        internal = 80
        external = each.value
    }
}

### ^^ RECURSOS EN BUCLE 

### vv RECURSO CONDICIONALMENTE
# Imaginad que estamos montando un entorno de producción
# Y monto 7 servidores WEB para ofrecer un servicio en cluster
# Qué tengo que montar delante de ellos? BALANCEADOR DE CARGA
# Pero el balanceador lo monto solo si tengo muchos webservers
# Quiero decir... Si creo la infra en el entorno de desarrollo
# Y solo he montado 1 webserver: numero_de_contenedores
# Quiero balanceador? NO
resource "docker_container" "mi_balanceador" {
    count   = var.numero_de_contenedores == 1 ? 0 : 1
    name    = "mibalanceador"
    image   = docker_image.mi_imagen.image_id
    ports {
        internal = 80
        external = 8090
    }
}

resource "docker_container" "mi_contenedor_mas_personalizado" {
    # El count NO NOS SIRVE !
    # En el count hemos de pasar un NUMERO 
    # En este caso, vamos a echar mano de una vieja palabra conocida:
    for_each    = var.contenedores_mas_personalizados # Este for_each solo admite: list(string) NO VALE PARA NADA !
                                                  # Un mapa. PARA ESTO QUIERO USAR LOS FOR_EACH
        # Al usar la palabra for_Each, tenemos a nuestra disposición una variable llamada: each
        # A la que podemos pedir each.key y el each.value
    # Este for_each NO SE PARECE EN NADA AL DE LOS DYNAMIC BLOCKS !
    name    = each.key
    image   = docker_image.mi_imagen.image_id
    cpu_shares =  each.value.cuota_cpu
                # each.value[ "cuota_cpu" ]
                # each.value[ var.campo ]
    
    ports {
        internal = 80
        external = each.value.externo
        ip = each.value.ip_address
    }
}

resource "docker_container" "mi_contenedor_mas_personalizado_2" {
    count   = length(var.contenedores_mas_personalizados_2) 
            // count.index
    
    name    = var.contenedores_mas_personalizados_2[count.index].nombre
    image   = docker_image.mi_imagen.image_id
    cpu_shares =  var.contenedores_mas_personalizados_2[count.index].cuota_cpu
    
    ports {
        internal = 80
        external = var.contenedores_mas_personalizados_2[count.index].externo
        ip = var.contenedores_mas_personalizados_2[count.index].ip_address
    }
}