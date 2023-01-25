variable "nombre_contenedor" {
    description = "Nombre del contenedor que vamos a crear"
    type        = string
}

variable "cuota_de_cpu" {
    description = "Uso de CPU que permito a los procesos que corren en el contenedor. 1 cpu = 1024 shares"
    type        = number
    # default     = 1024  # NO SE USA NUNCA EN SCRIPTS !!! PROHIBIDO !
                        # Entonces... para que sirve esto?
                        # Ya os lo contaré ! El JUEVES !
}

variable "repo_imagen_del_contenedor" {
    description = "Repositorio del que obtener la imagen a usar para crear el contenedor"
    type        = string
}

variable "tag_imagen_del_contenedor" {
    description = "Tag de la imagen concreta a usar para crear el contenedor"
    type        = string
}

variable "variables_de_entorno" {
    description = "Variables de entorno para configurar el contenedor"
    # OPCION 1: 
    # type        = set(string) # DESASTRE !!! CAGADA !!!!
        # [
        #    "VAR1=valor1",
        #    "VAR3=valor2"
        # ]
    type        = list(object({
                                nombre = string
                                valor  = string
                              }))
        # [
        #    {
        #        nombre = "VAR1"
        #        valor  = "valor1"
        #    },
        #    {
        #        nombre = "VAR2"
        #        valor  = "valor2"
        #    }
        # ]
    
}
# POR DIOS !!!! Siempre explicito. No quiero comportamientos mágicos!

variable "puertos_a_exponer" {
    description = "Puertos a exponer en el contenedor"
    type        = list(object({
                                interno = number
                                externo = number
                                ip       = optional(string, "0.0.0.0")
                                        # Nos permite definir propiedades no obligatorias
                                        # Si no se suministra un dato, se toma el valor por defecto
                              }))
}
