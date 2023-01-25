# Script requiere de PARAMETRIZACION !

La parametrización en terraform se consigue a través de VARIABLES


## Tipos de datos que manejamos en terraform

- string
- bool
- number

- list( ... )
- set( ... )
- map( ... )
 
- object

## Formas de suministrar valores a las variables

1. A través de la propiedad "default" que se detalle al definir la variable
 
    NOTA: NO SE USA NUNCA EN SCRIPTS !!!!!

2. Suministrándolas desde la terminal, a través del argumento --var "VARIABLE=VALOR"

    $ terraform apply --var "VAR1=valor1"
    
    Cuál es el problema de esta solución? NO QUEDA CONSTANCIA EN NINGUN SITIO !!!!
    
    Pero... cuándo quiero usar esto? Por qué tendrá su sitio? CUANDO NO QUIERA DEJAR CONSTANCIA !
    Por ejemplo: Contraseña !

3. En un fichero de variables, que se suministrará en la terminal a través del argumento --var-file

    $ terraform apply --var-file "fichero1.tfvars"
    
   GENIAL !!!!! Esta es la buena !

4. En un fichero de variables de carga automática. 
   Cualquier fichero de variables con extensión .auto.tfvars se carga en automático.
   UTIL PARA LOS VALORES POR DEFECTO !

5. Si terraform no dispone del valor de una variable por ninguno
   de los medios anteriores: Lo pedirá por consola, manualmente.
