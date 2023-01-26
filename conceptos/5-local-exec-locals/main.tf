terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.1"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
  }
}

provider "docker" {
}
provider "null" {
}

resource "docker_image" "mi_imagen" {
    name = "httpd:latest"
}

resource "docker_container" "mi_contenedor" {
    count   = 3
    name    = "miapache${count.index}"
    image   = docker_image.mi_imagen.image_id
    
    # Prueba de humo!
    provisioner "local-exec" {
      # command = "ping ${docker_container.mi_contenedor.network_data[0].ip_address}"
      # command = "[ ${count.index} -eq 2 ] && ping -c 1 ${self.network_data[0].ip_address} || echo "
      # command = "[[ ${count.index} == 2 ]] && ping -c 1 ${self.network_data[0].ip_address} || echo "
      command = "ping -c 1 ${self.network_data[0].ip_address} || echo "
      interpreter = ["/bin/bash", "-c"] # /bin/python, /bin/perl
      
      # Qué evalua terraform para saber si el comando se ha ejecutado correctamente: Exit code del proceso:
      # ==0 > OK
      # !=0 > NOK
      #on_failure = continue # Si no lo poneis, corta el script si hay un error en el provisionador: EXIT_CODE != 0
                            # Si lo poneis sigue adelante
      #when      = on_destroy  # Si no lo pongo: el provisionar se ejecuta cuando el recurso es CREADO O MODIFICADO... Nolo elijo! y no puedo.
                              # Si lo pongo, cuando el recurso es destruido
      # Los provisionadores se ejecutan para cada recurso que estuvieramos creando de este tipo:
      # si estoy usando un for_each o un count, para cada recurso se ejecuta su propio provisioner
    }
    
    # Prueba de humo!
    provisioner "local-exec" {
      command = "curl -s ${self.network_data[0].ip_address}"
    }
    
    ## Podría generar yo un fichero con la direccion ip de los contenedores que estoy creando?
    #provisioner "local-exec" {
    #  command = "mkdir -p inventario && echo ${self.name}=${self.network_data[0].ip_address} >> inventario/inventario.ini"
    #}
    
    ## Podría generar yo un fichero con la direccion ip de los contenedores que estoy creando?
    #provisioner "local-exec" {
    #  command = "echo ${self.name}=${self.network_data[0].ip_address} >> inventario.ini"
    #            # Me toca montar un comando sed, que del fichero elimine la linea correcpondiente
    #  when    = on_destroy
    #}
    # No quiero el fichero en esta carpeta sino en una carpeta /inventario
    
    ## La limitación grande es que: Yo no tengo mucho control de cuando se ejecuta el provisioner
    ## El provisioner se ejecuta siempre que un objeto es creado o destruido (a elegir) y además para cada recurso
    ## A veces necesito más control de CUANDO quiero que se ejecute un provisioner Y TERRAFORM NO ME DA ESE CONTROL
    
}

    # Cual sería una solución más limpia que todo esto? 
    # Cada vez que se ejecute el script y haya cambio en las ips, que se regenere el fichero, COMPLETO !
    
  # Terraform mirará si es necesario crear/modificar/eliminar este recurso desdúes del recurso docker_container.mi_contenedor, porque tienen una relación de dependencia en el grafo. 
  # Tienen una relación de dependencia ya que desde esete recurso apunto al otro recurso (variable)
locals {
// Asociar un nombre que puedo usar en mi script que será reemplazado por una expresión HCL.
  contenido_fichero = join("\n", [ for contenedor in docker_container.mi_contenedor: "${contenedor.name}=${contenedor.network_data[0].ip_address}" ])
}

resource "null_resource" "generador_archivo" {

  # El trigger solo controla si el objeto debe regenerarse, no cuando
  # El cuando lo controla el grafo de depdencias.
  # Para el grafo podrías poner un dependes_on, pero es algo inutil, ya que aquí ya estás usando la variable que pondrías en el depends_on. Sería redundante
  triggers = {
              # Si cambia este valor regenera el fichero
              # Si ha cambiado con respecto a qué? A lo que haya apuntado en el terraform.tfstate
    federico = local.contenido_fichero
    #lucas    = length(docker_container.mi_contenedor)
  }

  # En terraform, a cualquier propiedad de tipo texto, le podeis enchufar un valor MULTILINEA, usando una sintaxis MUY ESPECIAL:
  # HERE-DOC, similar a la de LINUX
  provisioner "local-exec" {
    command = <<EOF
                mkdir -p inventario
                rm -f inventario/inventario.ini
                echo "$MAQUINAS_CON_IP" > inventario/inventario.ini
                echo "Fichero generado"
              EOF
    # Definir variables de entorno que se pasan al INTERPRETE 
    environment = {
        MAQUINAS_CON_IP = local.contenido_fichero
    }
  }
}

/*
resource "null_resource" "chapuzon_pero_a_veces_no_queda_otra" {

  triggers = {
    federico = timestamp() #uuid()
  }

  provisioner "local-exec" {
    command = "echo Me ejecuto siempre"
  }
}
*/