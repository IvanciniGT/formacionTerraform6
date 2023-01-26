numero_de_contenedores      = 1

contenedores_personalizados = {
                                    "contenedorPA" = 9000
                                    "contenedorPB" = 9500
                              }

contenedores_mas_personalizados = {
                                    "contenedorP2A" = {
                                                        externo     = 10000
                                                        ip_address  = "127.0.0.1"
                                                    }
                                    "contenedorP2B" = {
                                                        externo     = 10500
                                                        cuota_cpu   = 3000
                                                    }
                                  }

contenedores_mas_personalizados_2 = [
                                        {
                                            nombre      = "contenedorP3A"
                                            externo     = 11000
                                            ip_address  = "127.0.0.1"
                                        },
                                        {
                                            nombre      = "contenedorP3B"
                                            externo     = 11500
                                            cuota_cpu   = 3000
                                        }
                                    ]
// A mi personalmente me es más cómoda/natural la segunda
// La segunda tiene un problema ! Y tengo que ser consciente!
// El nombre no está como clave y por tanto, ME PODRIAN PONER 2 RECURSOS CON EL MISMO NOMBRE ?
// Decisiones: 
    // Paso de ello... que se coma el marrón el que venga detrás (que vaya con cuidadito)
    // No fiarme y validarlo
