variable "algorythm" {
    description =   "Algoritmo a utilizar durante la generación de las claves"
    type        =   object({
                                name    = string
                                config  = optional(string)
                          })
    nullable    =   false
    default     =   {
                        name    = "RSA"
                        config  = 2048
                    }
                    // Dado que he puesto un default, es necesario poner nullable = false?
                    /*
                    module "misclaves" {
                    
                        algoritmo = null    // Al poner ahñi null? algoritmo no se pasa... y por ende? se toam el default !
                        // Me temo que esto funcionaría GUAY en ESTE CASO  !    
                        // Por qué? 
                    }
                    */
    
    validation  {
        condition       = contains( ["RSA", "ECDSA", "ED25519"] , upper(var.algorythm.name) ) // rsa
        error_message   = "El algoritmo no es válido. Debe ser uno de: RSA, ECDSA o ED25519"
    }

    validation  {
        condition       = (
                            upper(var.algorythm.name) != "RSA" 
                                                    ? true
                                                    : ( can(tonumber(var.algorythm.config)) 
                                                        ?  tonumber(var.algorythm.config) > 0
                                                        : false)
                          )
        error_message   = "Configuración no válida para el algoritmo RSA. Debe ser un número mayor que cero"
    }
    validation  {
        condition       = (
                            upper(var.algorythm.name) != "ECDSA" 
                                                    ? true
                                                    : contains( ["P224", "P256", "P384", "P521"] , upper(var.algorythm.config) )
                          )
        error_message   = "Configuración no válida para el algoritmo ECDSA. Debe ser uno de: P224, P256, P384, P521"
    }
    validation  {
        condition       = (
                            upper(var.algorythm.name) != "ED25519" 
                                                    ? true
                                                    : var.algorythm.config == null
                          )
        error_message   = "No se admite configuración para el algoritmo ED25519."
    }
    
    // name:    RSA             , ECDSA,                        ED25519         contains(lista, valor)
    // config:  number > 0        P224, P256, P384, P521        null
}


variable "regenerate_keys" {
    description =   "Regererar las claves aunque existan"
    type        =   bool
    nullable    =   false
    default     =   false // El modulo NO DEBE TENER un comportamiento destructivo por defecto
}

variable "keys_folder" {
    description =   "Directorio donde exportar / importar las claves"
    type        =   string
    nullable    =   false
    default     =   "./keys"
        validation {
        condition     = length(regexall("^[.]{0,2}[\\/]?([a-zA-Z0-9_-]+[\\/]?)*$", var.keys_folder))==1
        error_message = "El directorio no es válido"
    }

}