#Subjective-C
Trabajo practico Automatas, teoria de lenguajes y compiladores 1C 2015

###Integrantes
- Bezdjian, Alejandro
- Depascuali, Francisco

###Modo de uso
En la raiz del proyecto se encuentra el Makefile que generara los archivos necesarios y algunos programas de ejemplo.
Escriba el comando "make" en la raiz del proyecto. Esto creara el Subjective-C Compiler y lo ubicara en el mismo directorio con el nombre "scc".
Hay dos maneras distintas de compilar un programa escrito en Subjective-C, mediante archivo o mediante la linea de comandos.
Si se desea compilar por linea de comando, solo se debe ejecutar el compilador, luego el interprete de su sistema operativo esperara a que escriba el programa que desea compilar.
Nuestra recomendacion es que compile un programa escrito previamente en un archivo (por convencion se recomienda usar la extension .sc).
Para compilar un programa desde archivo usando scc, hay que ejecutar el compilador pasando como argumentos: (1) el archivo fuente (2) nombre que desea que tenga el archivo ejecutable. Un ejemplo de uso:
* >$ make
* >$ ./scc Factorial.sc factorial

* Nota: si al ejecutar el compilador solo se pasara el archivo fuente, scc creara automaticamente un archivo llamado "My_Subjective_C_Program"

Una vez generado el archivo factorial (o se puede elegir otro nombre), se creará el archivo Factorial.jar. Para ejecutar, ingresar el siguiente comando:
* >$ java -jar Factorial.sc <entero>
siendo <entero> el numero del cual se quiere averiguar el factorial.
