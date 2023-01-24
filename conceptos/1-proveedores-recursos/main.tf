# En HCL podemos poner comentarios. EUREKA !!!!!!

# Objetivo del script: 
# DEFINIR un contenedor con apache con cierta parametrización (....)

# Me permite definir los proveedores que voy a utilizar
# Solamente tendré un bloque terraform en todo el script
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.1"
    }
  }
}


# Me permite configurar esos proveedores
# Para cada proveedor definiré un bloque provider
provider "docker" {
}

# Me permite definir recursos que quiero gestionar a través de uno de esos proveedores
# Para cada recurso definiré un bloque resource

# Cuando creamos un recurso, terraform nos ofrece una variable llamada:
# TIPO_RECURSO.NOMBRE_RECURSO, que apunta al recurso que hemos creado. (O NO !!!!)

# IMAGEN DEL CONTENEDOR
resource "docker_image" "mi_imagen" {
    name = "httpd:latest"
}

# CONTENEDOR
#resource "TIPO" "NOMBRE_INTERNO" {
resource "docker_container" "mi_contenedor" {
    # nombre de contenedor "miapache"
    name    = "miapache"
    # imagen
    image   = docker_image.mi_imagen.image_id # Al hacer esto, además de conseguir el image_id
                                            # de una forma decente Terraform, ya sabe que hay 
                                            # una relación de dependencia entre estos recursos
                                            # Esta es la forma GUAY ! sin necesidad de un depends_on
    # puertos
    # variables de entorno
    #depends_on =[ #  ESTO ES UNA MALA PRACTICA EN LA MAYOR PARTE DE LAS SITUACIONES
                  #  MUY MUY MUY MUY RARO, PERO MUY RARO es que necesite esta marca.
                  #  CASI MEJOR SI OS OLVIDAIS DE QUE OS LA HE CONTADO
    #    docker_image.mi_imagen
    # Quiero definir la variable de entorno VAR1, con el valor valor1
    # Quiero definir la variable de entorno VAR2, con el valor valor2
    env     = [
                "VAR1=valor1",
                "VAR3=valor2"
              ]
    # Quiero exponer el puerto 80 del contenedor en el puerto 8081 del host, para todas las IPs del host
    # Quiero exponer el puerto 443 del contenedor en el puerto 8443 del host, para la IP ethernet del host
    ports {
        internal = 80
        external = 8081
    }
    ports {
        internal = 444
        external = 8443
        ip       = "172.31.8.169"
    }
}


// Para crear el contenedor, necesito previamente : LA IMAGEN DESCARGADA !
// Para borrar la imagen , necesito previamente: QUE SE HAYA ELIMINADO EL CONTENEDOR


