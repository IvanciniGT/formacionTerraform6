## Quiero un output con las ips 
output "direcciones_ip" {
    value = [ for contenedor in docker_container.mi_contenedor: 
                contenedor.network_data[0].ip_address ]
}

#output "direcciones_ip" {
#    value = docker_container.mi_contenedor[*].network_data[0].ip_address
#}

output "direcciones_ip_como_texto" {
    value = join(", ", [ for contenedor in docker_container.mi_contenedor: 
                contenedor.network_data[0].ip_address ])
}

output "fichero_inventario_ansible" {
    value = join("\n", [ for contenedor in docker_container.mi_contenedor: 
                "${contenedor.name} ansible_host=${contenedor.network_data[0].ip_address}" ])
}

output "direcciones_ip_personalizados" {
    value = [ for clave, valor in docker_container.mi_contenedor_personalizado: 
                "${clave}=${valor.network_data[0].ip_address}" ]
}