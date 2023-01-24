resource "docker_image" "mi_imagen" {
    name = "httpd:latest"
}

resource "docker_container" "mi_contenedor" {
    name    = "miapache"
    image   = docker_image.mi_imagen.image_id
    env     = [
                "VAR1=valor1",
                "VAR3=valor2"
              ]
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
output "direccion_ip" {
  #value = docker_container.mi_contenedor.ip_address
  value = docker_container.mi_contenedor.network_data[0].ip_address
}
# Para obtener los valores guardados en el output,
# terraform me lo pone sencillo... no me obliga a 
# analizar el fichero terraform.tfstate

# terraform output <NOMBRE_OUTPUT>

# Por defecto este comando devuelve los datos en sintaxis HCL

# Puedo pedirla en otro formato:
# terraform output [--json|--raw] <NOMBRE_OUTPUT>
