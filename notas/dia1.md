# Terraform

Es una herramienta de software que fabrica una empresa llamada HashiCorp (Vagrant) que nos ofrece:
- Un lenguaje DECLARATIVO, llamado HCL (HashiCorp Language), para crear scripts.
- Un interprete de linea de comandos con el que ejecutar COMANDOS que usen esos ficheros para realizar distintas operaciones

Uso: 
- Para gestionar AUTOMATICAMENTE (adquirir, liberar, actualizar) RECURSOS que contratamos u obtenemos de un PROVEEDOR.

RECURSOS:                                                               PROVEEDORES:
- Máquinas virtuales                                                    - Clouds
- Redes                                                                 - Kubernetes
- Permisos de usuario                                                   - Active directory
- Bases de datos                                                        - Servidor DNS
- Clave SSH
- Entrada en un servidor DNS
- Hacer un despliegue en Kubernetes
- Dar de alta un usuario en un Identity Provider (Active directory)

El principal uso de Terraform es la creación/mantenimiento de infraestructuras en Clouds!

## Cloud?

Conjunto de Servicios que una empresa (en el mundo TIC) ofrece a través de Internet. 

Características:
- Los servicios se pagan mediante un modelo de PAGO POR USO !
- Los servicios se ofrecen de for AUTOMATIZADA y DESATENDIDA ! No hay nadie detrás !

### Cuales son los clouds más usados del mundo:

- El de Amazon:     AWS
- El de Microsoft:  AZURE
- El de Google:     Google Cloud Platform

### Tipos de servicios:

- IaaS  (Infraestructura: Almacenamiento, Computación, Comunicaciones)
- PaaS  (Plataforma:      Base de datos, Kubernetes, Openshift, Contenedores)
- SaaS  (Software:        Cloud9)

## Son importantes a día de hoy los clouds? MUCHISIMO !

### Qué característicias debe cumplir un entorno de PRODUCCION que no tienen el resto de entornos?

- Alta Disponibilidad (HA)
    "Intentar" garantizar que los servicios estén operativos un tiempo prepactado!
        90% RUINA       ! = 36 dias al año      OFFLINE     |   €
        99% RUINILLA    ! = 3,6 dias al año     OFFLINE     |   €€
        99,9%             = 8 horas al año      OFFLINE     |   €€€€€
        99,99%            = 20 minutos al año   OFFLINE     v   €€€€€€€€€€€€€€€€€€€

    "Intentar" garantizar la NO PERDIDA de información. x3
    
    REDUNDANCIA!

- Escalabilidad
    Capacidad de ajustar la infra a las necesidades de cada momento:
        App1: Este es el día de Hoy (INTERNET)
            Hora n         100 usuarios
            Hora n+1       100000 usuarios               ESCALABILIDAD VERTICAL:    MAS MAQUINA !
            Hora n+2       2000 usuarios                 ESCALABILIDAD HORIZONTAL:  MAS MAQUINAS !
            Hora n+3       2000000 usuarios


Todos esos servicios (volumenes, BBDD, máquinas, redes) los quiero estar creando y borrando a mano?
Necesito que este proceso sea automatizado -> Quiero que un PROGRAMA haga esto: TERRAFORM !

Necesito terraform para automatizar ese trabajo realmente
No, hay otras utilidades:
- AWS cli   / APIs
- AZURE cli / APIs

Por qué TERRAFORM? 
- Porque usa un lenguaje DECLARATIVO !
- Unifica las clis en un mismo lenguaje... Una infra que yo haya definido en terraform, la puedo crear en AWS hoy y mañana en AZURE? Ni de coña !

# DEV-->OPS

Filosofía de trabajo / cultura que agoba, que promueve la AUTOMATIZACION 

| Etapa         | Automatizable | Herramientas                      | Quien?         |
| ------------- | ------------- | --------------------------------- | -------------- |
| plan          | x             |                                   |                |
| code          | x             |                                   |                |
| build         | √             | maven, npm, yarn, poetry, gradle  | Desarrollo     |
| test          |               |                                   |                |
|  definición   | x             |                                   |                |
|  ejecución    | √             | selenium, jmeter, loadrunner...   | Testers        |
|  donde?       | √             | Entorno de Integración, preprod.  |                |
|               | √             | terraform > ansible               | Sys admin      |
| release       | √             | docker                            | Desarrollo     |
| deployment    | √             | kubernetes, openshift, helm       | Sys admin      |
|               | √             | terraform > ansible               | Sys admin      |
| operate       | √             | kubernetes, openshift             | Sys admin      |
| monitor       | √             | kubernetes, openshift             | Sys admin      |

Yo tengo un montón de automatizaciones individuales creadas: Terraform, Ansible, Maven, Selenium

Me falta automatizar una tarea más: La llamada a todas esas automatizaciones (Orquestada)

A eso nos ayudan: Los servidores de AUTOMATIZACION (CI/CD): Pipeline = Script -> git (mercurial)
- Jenkins
- AzureDevops
- TravisCI
- Gitlab CI/CD
- Guthub Actions
- JetBrains: TeamCity
- Bamboo

Quién configura esta herramienta? Me hace falta un perfil nuevo! DEVOPS

Hoy en día distintas empresas usan el término DEVOPS con distintos significados:
El que monta un terraform -> DEVOPS (Sys admin que sabe de terraform!)
El que monta un selenium  -> DEVOPS (Tester     que sabe de selenium!)

En general muchas empresas usan el nombre DEVOPS para referirse a un perfil que sepa de automatizaciones (especialmente en el area de Sistemas)


# Lenguajes declarativos

Odiamos trabajar con el AWS cli, AZURE cli, script bash, scripts python => IMPERATIVO !

## Ejemplo de uso de lenguaje imperativo:

    IF hay silla debajo de la ventana:
        Dejalo quieto, no hagas na'! 
    IF si hay algo debajo de la ventana:
        Lo quitas!
    IF no hay silla
        vete al IKEA a por una silla !
    Felipe, pon una silla debajo de la ventana !            IMPERATIVO

## Ejemplo de uso de lenguaje DECLARATIVO:

    Felipe, quiero una silla debajo de la ventana!          DESIDERATIVA!

## Hoy en día, todas las herramientas que están petándolo son herramientas que usan lenguajes declarativos!

- Ansible
- Kubernetes
- Docker-compose
- Terraform

Al final, en terraform, cuando queramos crear infraestructura en un cloud, vamos a montar un script!
En ese script escribiré mis necesidades de infraestructura:
- Quiero una maquina (8Gbs de RAM y 4 CPUs)
                        Quiero que tenga una carpeta con estos permisos |
                        Y quiero estos paquetes instalados              |
                        Y unos usuarios                                  >  ANSIBLE, PUPPET, CHEF, SALT
                        Y unas reglas de firewall                       |
- Quiero una red
- Quiero una subred
- Quiero un volumen de almacenamiento
- Quiero el volumen de almacenamiento disponible en la maquina
- Quiero la maquina pinchada en la subred

Al final, en ese fichero(s) tengo un listado de todos los componentes que necesito:
 Un catálogo de mi infraestructura... que sirve de base para su creación... para un script
 De hecho ese catálogo es el script, solo que especificado con otra sintaxis: SINTAXIS DECLARATIVA
 
 Infraestructura como CODIGO: 
 - Por un lado tenemos la infra especificada como un código de programación
 - Por otro, vamos a tratar la infraestructura como si fuera un programa: 
    - Va a tener versiones
    - Va a estar guardada en un sistema de control de versión...

# Scripts de terraform

Al usar terraform, montamos scripts, a través del lenguaje HCL.

## Qué es un script de terraform

Una carpeta que tiene un conjunto de fichero con extensión: .tf

Y cuyos nombres son: LOS QUE ME DE LA GANA !

Habitualmente se usan los nombres: 
- main.tf
- variables.tf
- outputs.tf
- versions.tf

HCL es una sintaxis declarativa que toma conceptos tanto de JSON como de YAML
                                                            {}              La falta de "" para textos

En HCL hay unas cuantas palabra (bloques) de primer nivel con las que vamos a trabajar:
- terraform         MARTES              √
- provider          MARTES              √
- resource          MARTES              √
    - provisioners  MIERCOLES / JUEVES  √?
- output            MARTES              √
- variable          MARTES / MIERCOLES  √      ** ES LO MAS COMPLEJO, Y CON MUCHA DIFERENCIA, DE TERRAFORM **
- locals            JUEVES              √
- module            JUEVES, VIERNES
------- Empezar a trabajar con un CLOUD REAL
- data              VIERNES

## Nos pone facil (nos facilita) terraform el definir una infraestructura?

En absoluto! NADA FACIL.
Es harto COMPLEJO ! Me requiere un nivel de conocimientos de la INFRA y del PROVISIONAR MUY ALTO !

Esos scripts los vamos a suministrar como argumentos al programa TERRAFORM.
A ese programa le podremos pedir que ejecute comandos sobre los scripts:
- init          Descarga e instala el(los) PROVIDER(s) que se requiran ... y algo más que ya os contaré: MODULOS !
- validate      Valida la sintaxis del script en busca de errores
- plan          CALCULA las tareas necesarias para conseguir que:
                    - la infra que tengo definida en mi script coincida con
                    - la infra que tengo creada en la realidad
- apply         Aplicar el plan. Ejecutar las tareas para:
                    - Crear
                    - Modificar         Recursos
                    - Borrar
- destroy       Desmantela la infra (la elimina del TODO)
- ...

# Qué es un CONTENEDOR?

Es un entorno aislado dentro de un SO que ejecute un kernel Linux donde correr procesos.
Aislado, en cuanto a qué? Ese entorno tiene:
- Su propia configruación de RED -> su propia IP(s)
- Su propio sistema de archivos independiente del del host
- Sus propias variabels de entorno
- Puede tener limitación de acceso a los recursos HW del host

Los contenedores a día de hoy se han convertido en la forma estandar de ejecutar procesos dentro de entornos de producción... y no solo.

Los contenedores se usan como una alternativa a las MAQUINAS VIRTUALES.

Los contenedores se crean desde IMAGENES DE CONTENEDOR

Puedo correr un SO dentro de un Contenedor? NO . Esa es la gran diferencia con respecto a las máquinas virtuales.

# Qué es una IMAGEN DE CONTENEDOR?

Es un triste archivo comprimido (zip-> tar) que contiene un programa YA INSTALADO y preCONFIGURADO por alguien
que en general sabe MUCHO MAS DE INSTALAR Y CONFIGURAR ese programa que yo.
Además incluye:
- Las dependencias que pueda necesitar el programa que estoy instalando
- otros programas que puedan ser de interés para mi, como usuario.

Adicionalmente, acompañando a este archivo comprimido se suministran algunas configuraciones, como:
- Que programa (proceso) es el que debe ejecutarse de todos los que vienen ahí por defecto
- Qué puertos se están usando
- ...

Existe un ESTANDAR acerca de cómo empaquetar una aplciación como una imagen de contenedor.

Las imágenes de conteendor las sacamos de REGISTRIES DE REPOS DE IMAGENES DE CONTENEDOR.

El más famoso: Docker hub, quay.io (REDHAT)

Quiero instalar MongoDB en mi máquina Windows. Qué necesito hacer?
0º Tener el windows instalado y los requerimientos (librerias y configuraciones de SO realizados)
1º Descargar UN INSTALADOR de mongo
2º Ejecutar (+configuración) -> Instalación de MONGO
3º Ejecutar mongo

Mongo se ha instalado en la carpeta c:\Archivos de Programa\MongoDB -> ZIP -> Email 



















x Infra remota proporcionada por un proveedor externo



---

- Agilizar tareas / Facilitar administración
- Reutilizar infraestructuras
- Administrador de entornos cloud... como ansible
- Herramienta de infraestructura como código
- Lenguaje de administración de infraestructuras
- Herramienta para crear módulos/entornos reutilizables