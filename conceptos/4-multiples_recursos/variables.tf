variable "numero_de_contenedores" {
    type        = number
    description = "Numero de contenedores a crear"
}

variable "contenedores_personalizados" {
    description = "Contenedores con su puerto"
    type        = map(number)
}

variable "contenedores_mas_personalizados" {
    description = "Contenedores con su puerto"
    type        = map(object({
                                externo     = number
                                ip_address  = optional(string,"0.0.0.0")
                                cuota_cpu   = optional(number,null)
                                #cuota_cpu  = optional(number)
                                
                             }))
}


