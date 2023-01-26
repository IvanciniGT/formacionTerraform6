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
                                #cuota_cpu  = optional(number) EQUIVALENTE
                                
                             }))

    validation {
        condition       = alltrue( [ for nombre, contenedor in var.contenedores_mas_personalizados: 
                                        contenedor.externo >0 && contenedor.externo <=32000 ] )
        error_message   = "El puerto externo debe estar entre 1 y 32000"
    }
    
    validation {
        condition       = alltrue( [ for nombre, contenedor in var.contenedores_mas_personalizados: 
                                        contenedor.cuota_cpu == null ? true :
                                        contenedor.cuota_cpu >0 ] )
        error_message   = "La cutoa de cpu debe ser mayor que cero"
    }
    
    validation {
        condition       = alltrue( [ for contenedor in var.contenedores_mas_personalizados: 
                                        length(regexall("^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$", contenedor.ip_address)) == 1
                                   ] )
        error_message   = "La IP no tiene un formato válido"
    }
    
}


variable "contenedores_mas_personalizados_2" {
    description = "Contenedores con su puerto"
    type        = list(object({
                                nombre      = string
                                externo     = number
                                ip_address  = optional(string,"0.0.0.0")
                                cuota_cpu   = optional(number,null)
                             }))

    // TODO: Montar una validación de unicidad para el campo nombre !
    
    validation {
        condition       = alltrue( [ for contenedor in var.contenedores_mas_personalizados_2: 
                                        contenedor.externo >0 && contenedor.externo <=32000 ] )
        error_message   = "El puerto externo debe estar entre 1 y 32000"
    }
    
    validation {
        condition       = alltrue( [ for contenedor in var.contenedores_mas_personalizados_2: 
                                        contenedor.cuota_cpu == null ? true :
                                        contenedor.cuota_cpu >0 ] )
        error_message   = "La cutoa de cpu debe ser mayor que cero"
    }
    
    validation {
        condition       = alltrue( [ for contenedor in var.contenedores_mas_personalizados_2: 
                                        length(regexall("^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$", contenedor.ip_address)) == 1
                                   ] )
        error_message   = "La IP no tiene un formato válido"
    }
    
}