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
    name = "rastasheep/ubuntu-sshd"
}

resource "docker_container" "mi_contenedor" {
    name    = "contenedor"
    image   = docker_image.mi_imagen.image_id
    
    connection {
      // Damos la información de conectividad contra el remoto que se usará por los remote-exec / file
      // https://developer.hashicorp.com/terraform/language/resources/provisioners/connection
      type      = "ssh"
      host      = self.network_data[0].ip_address // Realmente podría conectarme con cualqueir entorno
      port      = 22
      user      = "root"
      password  = "root"

    }
    // los provisionadores remotos / file requieren conectividad via ssh o winrm
    provisioner "remote-exec" {
      inline  = [ "echo Eureka", "echo Hola desde el rentorno remoto > /tmp/miga.txt" ] 
      // Sería un equivalente a la propiedad command de los provisionadores local-exec
      # when
      # on_failure
      # No hay environment ni interpreter
    }
    provisioner "remote-exec" {
      script  = "./miscript.sh" # // ruta de un script que tengais en local. Terraform lo copia al remoto y lo ejecuta alli
                                # Al crear el script le he puesto permisos de ejecución? NO
                                # Terraform lo único que hace es leer el contenido del archivo y guardarlo en un 
                                # Temporal que crea en el remoto. Ese es el que ejecuta
      #scripts = ["script1", "script2"]
    }
    // Y hasta ahi los provisionadores REMOTOS !
    
    // los provisionadores file me permiten copiar O CREAR un fichero en un remoto
    provisioner "file" {
      destination   = "/tmp/archivo1.txt"
      content       = "SOY EL CONTENIDO DEL ARCHIVO"
                    # Ahi podeis usar variables, expresiones, sintaxis HERE-DOC, funciones: filetemplate file
    }
    provisioner "file" {
      destination   = "/tmp/archivo2.txt"
      source        = "./archivo_local.txt"
    }
}
