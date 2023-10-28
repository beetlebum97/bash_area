#!/usr/bin/env bash

# Códigos de colores
Negro='\033[0;30m'
Rojo='\033[0;31m'
Verde='\033[0;32m'
Marron_Naranja='\033[0;33m'
Azul='\033[0;34m'
Morado='\033[0;35m'
Cian='\033[0;36m'
GrisClaro='\033[0;37m'
GrisOscuro='\033[1;30m'
RojoClaro='\033[1;31m'
VerdeClaro='\033[1;32m'
Amarillo='\033[1;33m'
AzulClaro='\033[1;34m'
MoradoClaro='\033[1;35m'
CianClaro='\033[1;36m'
Blanco='\033[1;37m'

# Sin color
NC='\033[0m'

# Mostrar el menú de opciones
function mostrar_menu {
  echo -e "${Morado}*****************************"
  echo -e "${Morado}*****************************"
  echo -e "${Morado}*** SELECCIONA UNA OPCIÓN ***"
  echo -e "${Morado}*****************************"
  echo -e "${Morado}*****************************"
  echo -e "${Morado}***""${NC}  1)${Amarillo} Sistema Operativo ""${Morado}***"
  echo -e "${Morado}***""${NC}  2)${Amarillo} Kernel            ""${Morado}***"
  echo -e "${Morado}***""${NC}  3)${Amarillo} Shell             ""${Morado}***"
  echo -e "${Morado}***""${NC}  4)${Amarillo} Hostname          ""${Morado}***"
  echo -e "${Morado}***""${NC}  5)${Amarillo} Terminal          ""${Morado}***"
  echo -e "${Morado}***""${NC}  6)${Amarillo} Idioma            ""${Morado}***"
  echo -e "${Morado}***""${NC}  7)${Amarillo} Fecha y hora      ""${Morado}***"
  echo -e "${Morado}***""${NC}  8)${Amarillo} Sesión            ""${Morado}***"
  echo -e "${Morado}***""${NC}  9)${Amarillo} Boot              ""${Morado}***"
  echo -e "${Morado}***""${NC} 10)${AzulClaro} Arquitectura      ""${Morado}***"
  echo -e "${Morado}***""${NC} 11)${AzulClaro} BIOS              ""${Morado}***"
  echo -e "${Morado}***""${NC} 12)${AzulClaro} Placa Base        ""${Morado}***"
  echo -e "${Morado}***""${NC} 13)${AzulClaro} CPU               ""${Morado}***"
  echo -e "${Morado}***""${NC} 14)${AzulClaro} Memoria           ""${Morado}***"
  echo -e "${Morado}***""${NC} 15)${AzulClaro} Discos            ""${Morado}***"
  echo -e "${Morado}***""${NC} 16)${AzulClaro} PCI               ""${Morado}***"
  echo -e "${Morado}***""${NC} 17)${AzulClaro} USB               ""${Morado}***"
  echo -e "${Morado}***""${NC} 18)${Verde} Interfaces de Red ""${Morado}***"
  echo -e "${Morado}***""${NC} 19)${Verde} IP privada        ""${Morado}***"
  echo -e "${Morado}***""${NC} 20)${Verde} IP pública        ""${Morado}***"
  echo -e "${Morado}***"" ${NC}21)${Verde} MAC               ""${Morado}***"
  echo -e "${Morado}***"" ${NC}22)${Rojo} Salir             ""${Morado}***"
  echo -e "${Morado}*****************************"
  echo -e "${Morado}*****************************"
  echo -e "${Morado}*****************************${NC}"
}

# Leer la opción del usuario
function leer_opcion {
  read -p "Opción (Nº): " opcion
}

# Evaluar la opción del usuario
function evaluar_opcion {
  case $opcion in
    1) # Datos distribución
      echo -e "[SISTEMA OPERATIVO]"
      cat /etc/*release | grep PRETTY_NAME | cut -d '=' -f 2 | awk '{$1=$1};1'
      ;;
    2) # Datos kernel
      echo "[KERNEL]"
      uname -a
      ;;
    3) # Shell actual
      echo "[SHELL]"
      echo $SHELL
      ;;
    4) # Host del servidor
      echo "[HOSTNAME]"
      hostname
      ;;
    5) # Terminal actual
      echo "[TERMINAL]"
      tty
      ;;
    6) # Idioma del sistema
      echo "[IDIOMA]"
      locale | grep LANG=
      ;;
    7) # Fecha y hora
      echo "[FECHA Y HORA]"
      date
      ;;
    8) # Usuario actual
      echo "[SESIÓN]"
      w $USER
      ;;
    9) # Último inicio
      echo "[BOOT]"
      who -b | awk '{$1=$1};1'
      ;;
    10) # Arquitectura
      echo "[ARQUITECTURA]"
      uname -m
      ;;
    11) # Datos BIOS
      echo "[BIOS]"
      if cat /sys/class/dmi/id/bios_{date,vendor,version}; then
      dmidecode -t bios
      else
        dmidecode -t bios
      fi
      ;;
    12) # Datos placa
      echo "[PLACA BASE]"
      if cat /sys/class/dmi/id/board_{name,vendor,version}; then
      :
      else
        dmidecode -t baseboard
      fi
      ;;
    13) # Procesador
      echo "[CPU]"
      lscpu | grep -E 'Nombre del modelo|Model name' | cut -d ':' -f 2 | awk '{$1=$1};1'
      ;;
    14) # Datos memoria
      echo "[MEMORIA]"
      free -h
      ;;
    15) # Discos
      echo "[DISCOS/PARTICIONES]"
      lsblk
      ;;
    16) # PCI
      echo "[PCI]"
      lspci
      ;;
    17) # USB
      echo "[USB]"
      lsusb
      ;;
    18) # Interfaces de red
      echo "[INTERFACES DE RED]"
      ip a
      ;;
    19) # Dirección IP
      echo "[IP PRIVADA]"
      ip addr | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | awk '{$1=$1};1'
      ;;
    20) # Dirección IP Pública
      echo "[IP PÚBLICA]"
      wget -qO- http://ipecho.net/plain; echo
      ;;
    21) # Dirección MAC
      echo "[MAC]"
       ip link | grep link/ether | awk '{print $2}' | awk '{$1=$1};1'
      ;;
    22) # Salir del script
      echo "Saliendo del script..."
      exit 0
      ;;
    *) # Opción inválida
      echo "Opción inválida. Intenta de nuevo."
      ;;
  esac
}

# Preguntar al usuario si quiere ejecutar otro comando
function preguntar_otro {
  read -p "¿Quieres ejecutar otro comando? (S/N): " respuesta
}

# Bucle principal del script
while true; do
  mostrar_menu # Mostrar el menú de opciones
  leer_opcion # Leer la opción del usuario
  evaluar_opcion # Evaluar la opción del usuario
  preguntar_otro # Preguntar al usuario si quiere ejecutar otro comando
  if [[ $respuesta == [Nn] ]]; then # Si el usuario responde no, salir del bucle
    break
  fi
done
