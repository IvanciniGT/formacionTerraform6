
output "direccion_ip" {
  value = docker_container.mi_contenedor.network_data[0].ip_address
}
