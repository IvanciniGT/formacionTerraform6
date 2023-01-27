output "regenerated" {
    value = local.regenerate
}

output "keys" {
    value = (
                local.regenerate ? {
                                    public = {
                                                    openssh = tls_private_key.claves[0].public_key_openssh
                                                    pem     = tls_private_key.claves[0].public_key_pem
                                              }
                                    private = {
                                                    openssh = tls_private_key.claves[0].private_key_openssh
                                                    pem     = tls_private_key.claves[0].private_key_pem
                                              }
                                }
                               : {
                                    public = {
                                                    openssh = local.contenido_fichero_clave_publica_openssh
                                                    pem     = local.contenido_fichero_clave_publica_pem
                                              }
                                    private = {
                                                    openssh = local.contenido_fichero_clave_privada_openssh
                                                    pem     = local.contenido_fichero_clave_privada_pem
                                              }
                                }
            )
}

// key.private.pem
// key.private.openssh
// key.public.pem
// key.public.openssh
