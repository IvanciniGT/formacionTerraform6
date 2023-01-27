locals {
    nombre_algoritmo                        = upper(var.algorythm.name)
    
    directorio_claves                       = endswith( var.keys_folder, "/") ? var.keys_folder : "${var.keys_folder}/"
    
    fichero_clave_privada_pem               = "${local.directorio_claves}privateKey.pem"
    fichero_clave_privada_openssh           = "${local.directorio_claves}privateKey.openssh"
    fichero_clave_publica_pem               = "${local.directorio_claves}publicKey.pem"
    fichero_clave_publica_openssh           = "${local.directorio_claves}publicKey.openssh"
    
    existe_fichero_clave_privada_pem        = fileexists( local.fichero_clave_privada_pem )
    existe_fichero_clave_privada_openssh    = fileexists( local.fichero_clave_privada_pem )
    existe_fichero_clave_publica_pem        = fileexists( local.fichero_clave_privada_pem )
    existe_fichero_clave_publica_openssh    = fileexists( local.fichero_clave_privada_pem )
    
    existen_ficheros_claves                 = ( local.existe_fichero_clave_privada_pem          &&
                                                local.existe_fichero_clave_privada_openssh      &&
                                                local.existe_fichero_clave_publica_pem          &&
                                                local.existe_fichero_clave_publica_openssh  )
                                                
    contenido_fichero_clave_privada_pem     = local.existe_fichero_clave_privada_pem        ? file( local.fichero_clave_privada_pem     ) : null
    contenido_fichero_clave_privada_openssh = local.existe_fichero_clave_privada_openssh    ? file( local.fichero_clave_privada_openssh ) : null
    contenido_fichero_clave_publica_pem     = local.existe_fichero_clave_publica_pem        ? file( local.fichero_clave_publica_pem     ) : null
    contenido_fichero_clave_publica_openssh = local.existe_fichero_clave_publica_openssh    ? file( local.fichero_clave_publica_openssh ) : null
    
    regenerate                              = local.existen_ficheros_claves && ! var.regenerate_keys ? false : true
}

resource "tls_private_key" "claves" {
    count           = local.regenerate ? 1 : 0
    
    algorithm       = local.nombre_algoritmo
    ecdsa_curve     = local.nombre_algoritmo == "ECDSA" ? upper(var.algorythm.config)       : null
    rsa_bits        = local.nombre_algoritmo == "RSA"   ? tonumber(var.algorythm.config)    : null
    
    provisioner "local-exec" {
        command     = <<EOT
                            mkdir -p ${local.directorio_claves}
                            echo "${self.private_key_pem}"         > ${local.fichero_clave_privada_pem}
                            echo "${self.private_key_openssh}"     > ${local.fichero_clave_privada_openssh}
                            echo "${self.public_key_pem}"          > ${local.fichero_clave_publica_pem}
                            echo "${self.public_key_openssh}"      > ${local.fichero_clave_publica_openssh}
                        EOT
    }
}