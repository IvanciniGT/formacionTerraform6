# Terraform

Nos ofrece un lenguaje para crear scripts (que usualmente contienen una infra) llamado HCL.
Además nos ofrece un comando TERRAFORM con el que aplicar distintas operaciones sobre esos scripts.

# Script de terraform

Una carpeta con archivos .tf, que se podian llamar de cualquier forma:
- main.tf
- versions.tf
- variables.tf
- outputs.tf

En esos scripts hay ciertos bloques de primer nivel relevantes:
- terraform
- provider
- resource
- output
- variable
- locals
- data

Entre las operaciones que podemos ejecuatr sobre un script encontramos:
- init
- plan
- apply
- destroy
- validate
- ...

Con terraform automatizamos la gestión (adquisición, eliminación y actualización) de recursos a través de unos proveedores.

En el caso de esta formación, vamos a estrar trabajando principalmente con CONTENEDORES.

Los contenedores en algunos escenarios son un reemplazo de las máquinas virtuales.

# Qué es un PROVIDER desde el punto de vista de TERRAFORM?

Un provider es un PROGRAMA con el que TERRAFORM puede comunicarse para solicitarle la gestión de recursos.
Habitualmente ese PROVIDER delega esas gestiones a otros programas (API).

    script definiendo   > terraform (apply)     >   provider    >   docker 
    contenedores                                    docker

Terraform por defecto NO TRAE ningún provider. Los descargamos del Terraform REGISTRY.
Esa operación la hacemos con el comando INIT

# Versiones de software

Versión: 5.6.7

                Cúando se incrementa?
- 5? MAYOR      Cambio en diseño o arquitectura que NO ASEGURA COMPATIBILIDAD HACIA ATRAS
- 6? MINOR      Nueva funcionalidad
- 7? MICRO      Hotfixes (resolver bugs)

En un entorno de producción: ~> 5.6

# TIPOS DE DATOS QUE PODEMOS USAR EN TERRAFORM 

Tipos simples:
- Number        Números                 15     18.98
- Bool          Valores lógicos         true   false
- String        Textos                  "hola"

Tipos complejos: Cuando defino un tipo colección, los valores deben ser del mismo tipo
- List( ... )   Conjunto secuencial de valores, a los que puedo acceder por su posición
    List( number )                      ( 1,2,3,4 )
                Podría escribir cosas como: lista[3]
- Set( ... )    Conjunto secuencial de valores, a los que NO PUEDO acceder por su posición
                Solo puedo ITERAR SOBRE SUS VALORES 
- Map( ... )    Conjunto de pares clave=valor. Mapa, Tabla Hash, Array asociativo, Diccionario
                Las claves son siempre STRINGS. El tipo que definiremos entre parentesis es el que
                deben tener los valores
    Map(bool)                           { "clave1" = true, "clave2" = false }
- Object        SON GENIALES !
                Son Mapas, con claves personalizadas y predefinidas, que además pueden tomar TIPOS de valores diferentes!
                Nos encantan !

A todos estos tipos, se le une el tipo BLOCK. Este tipo es MUY DIFERENTE A LOS DEMAS, y solo aplica en las propiedades de los recursos. Habitualmente los encontramos como: BLOCK SET | BLOCK LIST.
Cambia la sintaxis.

Para todas las propiedades que no sean de tipo block, escribiremos:
    propiedad = VALOR
Para las propiedades de tipo BLOCK, NO SE PONE SIGNO IGUAL
    capabilities {
        add = ("texto1", "texto2")
        drop = ("texto1")
    }
    
Las propiedes de tipo block, llevan lo que se denomina un ESQUEMA ANIDADO, que establece las nuevas
propiedades que podemos escepcificar dentro de las llaves.

# Terraform plan

Calcula / Planifica las tareas necesarias para llegar al estado deseado,
comparando el estado actual (que terraform conoce del entorno) con el estado deseado.

- Estado deseado: LOS RECURSOS DEFINIDOS EN EL SCRIPT + COMANDO SUMINISTRADO (DESTROY | APPLY)

- Estado real: LOS RECURSOS QUE actualmente están presentes (han sido creados previamente)
    ¿Quién conoce esto? El proveedor

- Estado actual conocido por terraform: Lo que existe dado de alta en un IMPORTANTISIMO FICHERO llamado
"terraform.tfstate"

Cuando se hace un APPLY, se genera este fichero, anotando todos los recursos que han sido creados, junto con los que ya existían previamente y no han sido eliminados.

TERRAFORM SOLO GUARDA EL ULTIMO ESTADO DEL SISTEMA QUE EL CONOCE (por cortesía, cada vez que se regenera el fochero .tfstate, se nos hace un backup... que machaca el backup anterior. SOLO TENGO 1 BACKUP)


Estado deseado              Estado conocido por Terraform       |       Estado real
Contenedor miApache         Contenedor miApache                 |       Contenedor miApache

Estado deseado              Estado conocido por Terraform       |       Estado real
Nada                        Nada                                |       Nada 
                                            < ----------- terraform refresh --------------
                                                Solo pregunta por los objetos/recursos
                                                que terraform conoce de antemano

# Orden de creación/eliminación de RECURSOS :

NOTA1: A TERRAFORM LE IMPORTA UN HUEVO el orden en el que yo haya definido los recursos en los ficheros.

De hecho... cúantos ficheros puedo tener en mi carpeta? Montonones
Y cúantos recursos podría tener en cada fichero? Montonones

Y al ejecutar el script, que hace terraform: Junta todos esos ficheros en UNO SOLO y ese es el que ejecuta.
En que ORDEN: ES IRRELEVANTE !

Cuando hacemos un terraform PLAN, terraform calcula un GRAFO DE DEPENDENCIAS ENTRE LOS RECURSOS!
Terraform me puede mostrar ese grafo:
$ terraform graph -type=plan
$ terraform graph -type=apply
$ terraform graph -type=plan-destroy

# Ciclo de vida natural de los scripts de terraform:

## Comandos habituales que vamos a ejecutar:
1- init
2- validate > plan > apply          v1 de la infra
3- validate > plan > apply          v2 de la infra
4- validate > plan > apply          v3 de la infra
5- validate > plan > apply
6- validate > plan > apply
7- validate > plan > apply
8- validate > plan > apply
9- validate > plan > apply
10- validate > plan > apply
11- validate > plan > apply
12- validate > plan > apply
....
El dia que el proyecto muera:
1000000- validate > plan-destroy > destroy

# El script va a ir guardado en un repositorio de git!

En ese mismo repositorio iré guardando cada vez que aplico el fichero terraform.tfstate

En GIT es donde tengo el historial completo de .tfstate

EL ARCHIVO terraform.tfstate ES BASICO! No me puedo permitir perderlo!

SOLO DEBERIA HABER 1 persona trabajando con la INFRA. Esa persona es: JENKINS 

JENKINS es quien descarga el repo de GIT con la infra
Aplica el terraform apply --auto-aprove
Guarda el fichero .tfstate en el repo de nuevo.

No quiero a un humano, generador de errores, olvidandose de subir a git el archivo .tfstate... NI DE COÑA !!!!

# Infraestructura como código = ESTOY HACIENDO UN PROGRAMA !

Y cuando hago un programa , ese programa lo hago en un entorno de desarrollo...
Y lo pruebo en un entorno de integración (donde juego a manita, o lo que quiera)
PERO EL ENTORNO DE PRODUCCION ES SAGRADO ! Ahí no se juega, ahi no ha "a manita"


red _vpc_app1_desarrollo

red _vpc_app1_test

red _vpc_app1 > PROD



# 

Acabo de crear un contenedor (como si fuera un servidor que he contratado en AMAZON)
Estoy tranquilo... ME puedo ir a casa?

Para qué he creado la infra? Para hacer un ejemplo en un curso? Me temo que en la empresa no.

Para instalarle algunas cosas! Eso lo va a hacer quién? TERRAFORM? NO
- En el mejor de los casos.... Una herramienta tipo Ansible
- En el peor de los casos... a manita !

No perdais de vista que nuestro trabajo solo es un ESLABON MAS DE LA CADENA

Quien sea que entre detrás, necesitara algunos datos de mi entorno, por ejemplo:
- IP

La saco del fichero terraform.tfstate

cat terraform.tfstate | grep "ip_address" | head -1 ... EUREKA !!!  RUINA GIGANTE!!!!!

Esto no lo haríamos nunca!! JAMAS !!! por qué? -> Motivación para usar "output"

Tengo control alguno del contenido del fichero .tfstate? 
- No tengo NINGUN CONTROL del bloque RESOURCES
- Si tengo control del bloque OUTPUTS
    PUEDO ESCRIBIR COSAS EN ESE BLOQUE A TRAVES DE elementos "OUTPUT" 


La estructura de datos que ahí se genera la determina el PROVEEDOR !

REGLA BASICA DEL MUNDO DEL DESARROLLO DE SOFTWARE:

Debo crear programas empaquetados, aislados, encapsulados.
Que reciben unos datos de entrada y proporcionan unos datos de salida
DE FORMA CONSISTENTE.

No importa si yo cambio mi programa, o cambio alguna de las librerias 
que usa mi programa, el programa SIEMPRE debe devolver el mismo resultado.


JENKINS 
    $ terraform apply --auto-approve
    $ terraform output --raw direccion_ip
    3º Llama al ansible, monitorización, aquien te de la real gana !

## Validar el entorno: Smoke Test