# PROVISIONADORES

Que no tienen nada que ver con los proveedores

Acciones que puedo ejecutar:
- Al crear/modificar un recurso
- Al borrarlo

## Terraform nos da 3 tipos de provisionadores. SOLO 3

Ante había más... los han quitado.

- local-exec        Ejecuta un comando/script donde? lanzamos terraform 
                    Usos:
                        Para lanzar un playbook de ansible. Qué tal lo veis?    NI DE COÑA ! NUNCA ! JAMÁS !
                            Orquestación? JENKINS o similar!
                            Quiero a Terraform llamando a Ansible? NUNCA
                                Por qué?
                                    De esos problemas que dan la cara al año! o a los 2 años... y entonce te cagas!
                                    Que pasa si mañana (o dentro de 1 año o 2) decido reemplazar Ansible por puppet
                                    Si he hecho esto -> TENGO QUE CAMBIAR TODOS MIS SCRIPTS DE TERRAFORM !
                            No quiero montar us sistema CON UN NIVEL DE ACOPLAMIENTO ALTO... ni BAJO
                            Quiero un sistema con componentes SIN ACOPLAMIENTO
                            Ya habrá 1 que se encargue de orquestarlos: JENKINS !
                        Recoger información
                        Quién va a entras detras de Terraform?
                            Ansible, Puppet, Chef... Un tio a mano por ssh!
                            Puede entrar?   Quizás si o quizás no
                                Tengo un usuariuo dentro/contraseña, puertos abiertos, ssh arriba?
                                Tengo un minimo de paquetes instaaldos en el entorno? python
                        Test/Validaciones ! SMOKE_TEST                          BASICO
                            ping?
- remote-exec       Ejecuta un comando/script en un entorno remoto al que puedo conectar via ssh o winrm
                        Quién va a entras detras de Terraform?
                            Ansible, Puppet, Chef... Un tio a mano por ssh!
                            Puede entrar?   Quizás si o quizás no
                                Tengo un usuariuo dentro/contraseña, puertos abiertos, ssh arriba?
                                Tengo un minimo de paquetes instaaldos en el entorno? python
                        Test/Validaciones ! SMOKE_TEST                          BASICO
                            ssh | winrm? y ejecutar algo?
- file              Copia o crea un fichero en un entorno remoto al que puedo conectar via ssh o winrm
                        Fichero de clave publica    Jenkins! ssh
    
# Para que sirve esto? más allá de lo evidente!


Host local
    Terraform
        script
            V
            host remoto
            ^
    Ansible
        inventario
        playbook
    
