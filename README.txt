En este repositorio iré colgando scripts Bash diversos.

## INFO_SISTEMA.SH ##

Ofrece información general de un sistema Linux.

Un menú de opciones permite escoger entre diferentes opciones. 

Secciones diferenciadas por colores:

Amarillo (1-9): Sistema.
Azul (10-17): Hardware.
Verde (18-21): Red.
Rojo (22): Salir.

BIOS (11) y Placa Base (12) puede requerir permisos de administrador.
USB (17) requiere tener instalado el paquete usbutils.

[EJECUCIÓN]

Revisar que el script tiene permisos de ejecución (x) para el usuario.

root@debian-12:/home/beetlebum97# ls -l info_sistema.sh
-rwxr-xr-x 1 root root 5545 oct 28 21:11 info_sistema.sh

Opción 1 > bash info_sistema.sh

Opción 2 > ./info_sistema.sh


root@debian-12:/home/beetlebum97# ./info_sistema.sh
*****************************
*****************************
*** SELECCIONA UNA OPCIÓN ***
*****************************
*****************************
***  1) Sistema Operativo ***
***  2) Kernel            ***
***  3) Shell             ***
***  4) Hostname          ***
***  5) Terminal          ***
***  6) Idioma            ***
***  7) Fecha y hora      ***
***  8) Sesión            ***
***  9) Boot              ***
*** 10) Arquitectura      ***
*** 11) BIOS              ***
*** 12) Placa Base        ***
*** 13) CPU               ***
*** 14) Memoria           ***
*** 15) Discos            ***
*** 16) PCI               ***
*** 17) USB               ***
*** 18) Interfaces de Red ***
*** 19) IP privada        ***
*** 20) IP pública        ***
*** 21) MAC               ***
*** 22) Salir             ***
*****************************
*****************************
*****************************
Opción (Nº): 1
[SISTEMA OPERATIVO]
"Debian GNU/Linux 12 (bookworm)"
¿Quieres ejecutar otro comando? (S/N): N
root@debian-12:/home/beetlebum97#