nombre_contenedor           = "miapache"
#cuota_de_cpu                = 10
repo_imagen_del_contenedor  = "httpd"
tag_imagen_del_contenedor   = "latest"
variables_de_entorno        = [
                                    {
                                        nombre = "VAR1"
                                        valor  = "valor1"
                                    },
                                    {
                                        nombre = "VAR2"
                                        valor  = "valor2"
                                    }
                              ]
puertos_a_exponer           = [
                                    {
                                        interno = 80
                                        externo = 8080
                                        ip = "127.0.0.1"
                                    },
                                    {
                                        interno = 443
                                        externo = 8443
                                    }
                              ]