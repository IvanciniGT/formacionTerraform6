variable "nombre_contenedor" {
    description = "Nombre del contenedor que vamos a crear"
    type        = string
    nullable    = false
    // Valiaciones
}

variable "cuota_cpu" {
    description = "Uso de CPU que permito a los procesos que corren en el contenedor. 1 cpu = 1024 shares"
    type        = number
    nullable    = true
    // Valiaciones
}

variable "version_nginx" {
    description = "Tag de la imagen concreta a usar para crear el contenedor"
    type        = string
    // Valiaciones
    nullable    = false
}
variable "externo" {
    description = "Puerto a exponer de NGINX"
    type        = number
    nullable    = false
    // Validaciones
}
variable "ip" {
    description = "IP donde exponer el puerto de NGINX"
    type        = string
    nullable    = true
    // Validaciones
}