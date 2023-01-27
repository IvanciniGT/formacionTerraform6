# Cuando vamos a conectarnos con un servidor vía ssh (Linux, Unix)

¿Qué credenciales usamos?

- usuario
- contraseña    En el mundo linux/unix no se usa... no se considera un mecanismo seguro
- Un par de claves (privada/publica)

La clave privada quíen la tiene? El cliente
La clave publica es la que depositamos en el servidor

Vamos a montar un modulo, cuya misión es gestionar/crear claves publicas/privadas.

Para ese modulo usaremos el provider:  hashicorp/terraform-provider-tls

## Las entradas a ese modulo deberían albergar información de:

- Algoritmo por el cuál generamos el par de claves: RSA, ECDSA, ED25519
- Configuraciones adicionales que pueda requerir ese algoritmo
    - ecdsa_curve (String) P224, P256, P384, P521. (default: P224)
    - rsa-bits (Number) (default: 2048).
- Al generar unas claves, querremos que esas claves se exporten a un "directorio"
    - 4 ficheros con nombre fijo:
        -  publicKey.pem
        -  publicKey.openssh
        -  privateKey.pem
        -  privateKey.openssh
- Forzar regeneración de claves: SI / NO

Las variables que vamos a montar hay que validarlas !

## Comportamiento del módulo:

Nuestro programa, lo primero, debería validar si los ficheros de claves ya existen en el directorio suministrado.

Si existen y se solicita la regeneración de claves o Si no existen se deben:
    crear las claves, con la configuración suministrada y exportarlas al directorio y como output
Si existen.... y no se solicita la regeneración de claves, 
    se deben leer los valores de esos ficheros para exportarlos como output

## Sintaxis

```tf

module "mis_claves" {
    algorythm               = object({
                                            name:       string
                                            config:     any OPCION 1... en este caso particular es matar moscas a cañonazos
                                            * config:     Optional(string)    OPCION2... esta es guay ya que TF hace autoconversion de tipos basicos
                                            config_rsa:     number OPCION 3
                                            config_ecdsa:   string
                                      })
    
    regenerate_keys         = bool
    keys_folder             = string
}

```

## Mas adelante hoy vamos a montar un servidor en un cloud

Y para acceder /crear ese servidor tendremos que darle la clave publica que queremos que quede instalada en ese servidor,
para que posteriormente se pueda acceder a él.

Quien tiene los datos de credenciales ->> CLI