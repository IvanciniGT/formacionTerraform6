variable "nombre_contenedor" {
    description = "Nombre del contenedor que vamos a crear"
    type        = string
    nullable    = false
    validation {
        condition       = length(regexall("^[a-z][a-z0-9_]{4,}$", var.nombre_contenedor)) == 1
                            # regex101.com
        error_message   = "El nombre del contenedor solo debe incluir caracteres en minúscula, guiones bajos y números. Debe comenzar por un caracter (en minúscula), y al menos debe tener 5 caracteres"
    }
}

variable "cuota_de_cpu" {
    description = "Uso de CPU que permito a los procesos que corren en el contenedor. 1 cpu = 1024 shares"
    type        = number
    # default     = 1024  # NO SE USA NUNCA EN SCRIPTS !!! PROHIBIDO !
                        # Entonces... para que sirve esto?
                        # Ya os lo contaré ! El JUEVES !
    default     = null  # Modulos !
    nullable    = true
    validation {
                          # Tengo que poner una EXPRESION que devuelva TRUE si el valor es aceptable
        #condition       = var.cuota_de_cpu > 0
                        # Condicional (como expresion, no como statement)
                        # condicion                ? valor si se cumple la condicion : valor si no se cumple
        condition       = var.cuota_de_cpu == null ? true                            : var.cuota_de_cpu > 0
                                                                                        # true | false
                            # Operadores relacionales: == != < > >= <= 
                            # Operadores lógicos: && ||
                                # MUCHO CUIDADO CON ESTOS !!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                # =====
                                # En la mayor parte de los lenguajes de programación
                                # el operador && es el operador "AND en cortocircuito"
                                # And en cortocircuito? Si la condición1 no se cumple, la condicion2 no se evalua
                                # And normal? Aunque la condición1 no se cumpla, la condición2 se evalua
                                #               Esto nos puede dar problemas
                                # El && de terraform ES NORMAL, no en CORTOCIRCUITO
                                # var.cuota_de_cpu != null && var.cuota_de_cpu > 0
                          # Mensaje que se mostrará si el valor NO ES ACEPTABLE
                          # NOTAS: Aqui lo que ponemos son expresiones, que:
                            # - Pueden incluir operadores
                            # - Pueden hacer referencia la la variable que estamos validando.
                            #   PERO A NINGUNA OTRA ! Limitación importante ! Que necesitará WORK AROUNDS = chapuzas !
                            # - Podemos usar funciones de terraform:
                            # https://developer.hashicorp.com/terraform/language/functions
        error_message   = "El valor de la cuota de cpu debe ser extrictamente mayor que cero"
    }
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
                                interno = number    # >0 && <32000
                                externo = number    # >0 && <32000
                                ip       = optional(string, "0.0.0.0")  # Que sea una IP regex
                                        # Nos permite definir propiedades no obligatorias
                                        # Si no se suministra un dato, se toma el valor por defecto
                              }))
    validation {
        condition       = alltrue( [ for puerto in var.puertos_a_exponer: puerto.interno >0 && puerto.interno <=32000 ] )
        error_message   = "El puerto interno debe estar entre 1 y 32000"
    }
    
    validation {
        condition       = alltrue( [ for puerto in var.puertos_a_exponer: puerto.externo >0 && puerto.externo <=32000 ] )
        error_message   = "El puerto externo debe estar entre 1 y 32000"
    }
    
    validation {
        condition       = alltrue( [ for puerto in var.puertos_a_exponer: 
                                        length(regexall("^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$", puerto.ip)) == 1
                                   ] )
        error_message   = "La IP no tiene un formato válido"
    }
}
