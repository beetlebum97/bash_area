#!/usr/bin/env bash

# Códigos de colores mejorados
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

# Efectos especiales
Negrita='\033[1m'
Subrayado='\033[4m'
Inverso='\033[7m'
NC='\033[0m' # Sin color

# Función para limpiar pantalla
function limpiar_pantalla {
    clear
}

# Función para mostrar banner principal
function mostrar_banner {
    echo -e "${CianClaro}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CianClaro}║${Blanco}${Negrita}                   INFORMACIÓN DEL SISTEMA                    ${NC}${CianClaro}║${NC}"
    echo -e "${CianClaro}║${GrisClaro}                       Debian GNU/Linux                       ${NC}${CianClaro}║${NC}"
    echo -e "${CianClaro}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Función para mostrar menú mejorado
function mostrar_menu {
    limpiar_pantalla
    mostrar_banner

    echo -e "${Morado}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${NC}"
    echo -e "${Morado}┃${Blanco}${Negrita}                    MENÚ DE OPCIONES                          ${NC}${Morado}┃${NC}"
    echo -e "${Morado}┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫${NC}"
    echo -e "${Morado}┃                                                              ┃${NC}"

    # Sección Sistema
    echo -e "${Morado}┃  ${VerdeClaro}${Negrita}🖥️  INFORMACIÓN DEL SISTEMA${NC}                                  ${Morado}┃${NC}"
    echo -e "${Morado}┃  ${NC}  ${Amarillo}[1]${NC}  Sistema Operativo     ${Amarillo}[2]${NC}  Kernel                    ${Morado}┃${NC}"
    echo -e "${Morado}┃  ${NC}  ${Amarillo}[3]${NC}  Shell                 ${Amarillo}[4]${NC}  Hostname                  ${Morado}┃${NC}"
    echo -e "${Morado}┃  ${NC}  ${Amarillo}[5]${NC}  Terminal              ${Amarillo}[6]${NC}  Idioma                    ${Morado}┃${NC}"
    echo -e "${Morado}┃  ${NC}  ${Amarillo}[7]${NC}  Fecha y Hora          ${Amarillo}[8]${NC}  Sesión                    ${Morado}┃${NC}"
    echo -e "${Morado}┃  ${NC}  ${Amarillo}[9]${NC}  Boot                                                 ${Morado}┃${NC}"
    echo -e "${Morado}┃                                                              ┃${NC}"

    # Sección Hardware
    echo -e "${Morado}┃  ${AzulClaro}${Negrita}⚙️  HARDWARE${NC}                                                 ${Morado}┃${NC}"
    echo -e "${Morado}┃  ${NC}  ${CianClaro}[10]${NC} Arquitectura          ${CianClaro}[11]${NC} BIOS                      ${Morado}┃${NC}"
    echo -e "${Morado}┃  ${NC}  ${CianClaro}[12]${NC} Placa Base            ${CianClaro}[13]${NC} CPU                       ${Morado}┃${NC}"
    echo -e "${Morado}┃  ${NC}  ${CianClaro}[14]${NC} Memoria               ${CianClaro}[15]${NC} Discos                    ${Morado}┃${NC}"
    echo -e "${Morado}┃  ${NC}  ${CianClaro}[16]${NC} Dispositivos PCI      ${CianClaro}[17]${NC} Dispositivos USB          ${Morado}┃${NC}"
    echo -e "${Morado}┃                                                              ┃${NC}"

    # Sección Red
    echo -e "${Morado}┃  ${Verde}${Negrita}🌐 CONECTIVIDAD${NC}                                             ${Morado}┃${NC}"
    echo -e "${Morado}┃  ${NC}  ${VerdeClaro}[18]${NC} Interfaces de Red     ${VerdeClaro}[19]${NC} IP Privada                ${Morado}┃${NC}"
    echo -e "${Morado}┃  ${NC}  ${VerdeClaro}[20]${NC} IP Pública            ${VerdeClaro}[21]${NC} Dirección MAC             ${Morado}┃${NC}"
    echo -e "${Morado}┃                                                              ┃${NC}"

    # Opción de salida
    echo -e "${Morado}┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫${NC}"
    echo -e "${Morado}┃  ${RojoClaro}${Negrita}[22] 🚪 Salir del programa${NC}                                  ${Morado}┃${NC}"
    echo -e "${Morado}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
    echo ""
}

# Función para mostrar encabezado de sección
function mostrar_encabezado_seccion {
    local titulo="$1"
    local color="$2"
    local ancho_total=66
    local titulo_limpio=$(echo -e "$titulo" | sed 's/\x1B\[[0-9;]*[mK]//g')  # Remueve colores si los hay
    local longitud_titulo=${#titulo_limpio}
    local longitud_linea=$((ancho_total - 4)) # Quitamos 2 bordes y 2 espacios
    local espacios=$((longitud_linea - longitud_titulo))

    printf "\n"
    echo -e "${color}╔════════════════════════════════════════════════════════════════╗${NC}"
    printf "${color}║${Blanco}${Negrita} %-*s ${color}║${NC}\n" "$longitud_linea" "$titulo"
    echo -e "${color}╚════════════════════════════════════════════════════════════════╝${NC}"
    printf "\n"
}

# Leer la opción del usuario con validación
function leer_opcion {
    echo -ne "${Cian}${Negrita}➤ Selecciona una opción [1-22]: ${NC}"
    read opcion

    # Validar que sea un número
    if ! [[ "$opcion" =~ ^[0-9]+$ ]] || [ "$opcion" -lt 1 ] || [ "$opcion" -gt 22 ]; then
        echo -e "${Rojo}❌ Opción inválida. Por favor, introduce un número entre 1 y 22.${NC}"
        sleep 2
        return 1
    fi
    return 0
}

# Evaluar la opción del usuario
function evaluar_opcion {
    case $opcion in
        1) # Datos distribución
            mostrar_encabezado_seccion "SISTEMA OPERATIVO" "${Verde}"
            cat /etc/*release | grep PRETTY_NAME | cut -d '=' -f 2 | awk '{$1=$1};1' | sed 's/"//g'
            ;;
        2) # Datos kernel
            mostrar_encabezado_seccion "KERNEL" "${Verde}"
            uname -a
            ;;
        3) # Shell actual
            mostrar_encabezado_seccion "SHELL" "${Verde}"
            echo "Shell actual: $SHELL"
            echo "Versión: $($SHELL --version | head -n1)"
            ;;
        4) # Host del servidor
            mostrar_encabezado_seccion "HOSTNAME" "${Verde}"
            echo "Nombre del equipo: $(hostname)"
            echo "FQDN: $(hostname -f 2>/dev/null || hostname)"
            ;;
        5) # Terminal actual
            mostrar_encabezado_seccion "TERMINAL" "${Verde}"
            echo "TTY actual: $(tty)"
            echo "Tipo de terminal: $TERM"
            ;;
        6) # Idioma del sistema
            mostrar_encabezado_seccion "CONFIGURACIÓN DE IDIOMA" "${Verde}"
            locale | grep -E '^LANG=|^LC_'
            ;;
        7) # Fecha y hora
            mostrar_encabezado_seccion "FECHA Y HORA" "${Verde}"
            echo "Fecha y hora actual: $(date)"
            echo "Zona horaria: $(timedatectl show --property=Timezone --value 2>/dev/null || cat /etc/timezone 2>/dev/null || echo 'No disponible')"
            ;;
        8) # Usuario actual
            mostrar_encabezado_seccion "INFORMACIÓN DE SESIÓN" "${Verde}"
            echo "Usuario actual: $USER (UID: $(id -u))"
            echo "Grupos: $(groups)"
            w $USER
            ;;
        9) # Último inicio
            mostrar_encabezado_seccion "INFORMACIÓN DE ARRANQUE" "${Verde}"
            echo "Último arranque: $(who -b | awk '{print $3, $4}')"
            echo "Tiempo de actividad: $(uptime -p)"
            ;;
        10) # Arquitectura
            mostrar_encabezado_seccion "ARQUITECTURA DEL SISTEMA" "${AzulClaro}"
            echo "Arquitectura: $(uname -m)"
            echo "Plataforma: $(uname -i 2>/dev/null || echo 'No disponible')"
            ;;
        11) # Datos BIOS
            mostrar_encabezado_seccion "INFORMACIÓN DE BIOS/UEFI" "${AzulClaro}"
            if [ -r /sys/class/dmi/id/bios_date ]; then
                echo "Fecha BIOS: $(cat /sys/class/dmi/id/bios_date 2>/dev/null)"
                echo "Fabricante BIOS: $(cat /sys/class/dmi/id/bios_vendor 2>/dev/null)"
                echo "Versión BIOS: $(cat /sys/class/dmi/id/bios_version 2>/dev/null)"
            else
                echo "Ejecutando dmidecode para obtener información de BIOS..."
                sudo dmidecode -t bios 2>/dev/null || echo "Se requieren permisos de administrador"
            fi
            ;;
        12) # Datos placa
            mostrar_encabezado_seccion "PLACA BASE" "${AzulClaro}"
            if [ -r /sys/class/dmi/id/board_name ]; then
                echo "Nombre: $(cat /sys/class/dmi/id/board_name 2>/dev/null)"
                echo "Fabricante: $(cat /sys/class/dmi/id/board_vendor 2>/dev/null)"
                echo "Versión: $(cat /sys/class/dmi/id/board_version 2>/dev/null)"
            else
                echo "Ejecutando dmidecode para obtener información de la placa base..."
                sudo dmidecode -t baseboard 2>/dev/null || echo "Se requieren permisos de administrador"
            fi
            ;;
        13) # Procesador
            mostrar_encabezado_seccion "PROCESADOR (CPU)" "${AzulClaro}"
            lscpu | grep -E 'Nombre del modelo|Model name|CPU\(s\)|Núcleo|Core|Hilo|Thread|Frecuencia|MHz'
            ;;
        14) # Datos memoria
            mostrar_encabezado_seccion "MEMORIA DEL SISTEMA" "${AzulClaro}"
            free -h
            echo ""
            echo "Información detallada de memoria:"
            cat /proc/meminfo | grep -E '^MemTotal|^MemFree|^MemAvailable|^SwapTotal|^SwapFree'
            ;;
        15) # Discos
            mostrar_encabezado_seccion "DISCOS Y PARTICIONES" "${AzulClaro}"
            echo "Vista en árbol de dispositivos de bloque:"
            lsblk -f
            echo ""
            echo "Uso del sistema de archivos:"
            df -h
            ;;
        16) # PCI
            mostrar_encabezado_seccion "DISPOSITIVOS PCI" "${AzulClaro}"
            lspci | head -20
            if [ $(lspci | wc -l) -gt 20 ]; then
                echo "... (mostrando solo los primeros 20 dispositivos)"
                echo "Total de dispositivos PCI: $(lspci | wc -l)"
            fi
            ;;
        17) # USB
            mostrar_encabezado_seccion "DISPOSITIVOS USB" "${AzulClaro}"
            lsusb
            ;;
        18) # Interfaces de red
            mostrar_encabezado_seccion "INTERFACES DE RED" "${VerdeClaro}"
            ip -4 -o addr show | awk '{print $2, $4}'
            echo ""
            echo "Detalles completos de interfaces:"
            ip a | grep -E '^[0-9]+:|inet '
            ;;
        19) # Dirección IP privada
            mostrar_encabezado_seccion "DIRECCIONES IP PRIVADAS" "${VerdeClaro}"
            ip addr | grep 'inet ' | grep -v '127.0.0.1' | awk '{print "Interfaz:", $NF, "- IP:", $2}' | column -t
            ;;
        20) # Dirección IP Pública
            mostrar_encabezado_seccion "DIRECCIÓN IP PÚBLICA" "${VerdeClaro}"
            echo -n "Obteniendo IP pública... "
            IP_PUBLICA=$(wget -qO- http://ipecho.net/plain 2>/dev/null || curl -s http://ipecho.net/plain 2>/dev/null)
            if [ -n "$IP_PUBLICA" ]; then
                echo -e "${Verde}✓${NC}"
                echo "Tu IP pública es: $IP_PUBLICA"
            else
                echo -e "${Rojo}✗${NC}"
                echo "No se pudo obtener la IP pública. Verifica tu conexión a internet."
            fi
            ;;
        21) # Dirección MAC
            mostrar_encabezado_seccion "DIRECCIONES MAC" "${VerdeClaro}"
            ip link | grep -A1 '^[0-9]' | grep 'link/ether' | awk '{print "Interfaz:", prev, "- MAC:", $2} {prev=$0}' | sed 's/^[0-9]*: //' | column -t
            ;;
        22) # Salir del script
            echo ""
            echo -e "${Verde}${Negrita}👋 ¡Gracias por usar el script de información del sistema!${NC}"
            echo -e "${GrisClaro}Saliendo...${NC}"
            sleep 1
            exit 0
            ;;
        *) # Opción inválida
            echo -e "${Rojo}❌ Opción inválida. Intenta de nuevo.${NC}"
            ;;
    esac
}

# Función para pausa y continuar
function pausa {
    echo ""
    echo -e "${GrisClaro}${Negrita}Presiona [ENTER] para continuar...${NC}"
    read
}

# Función principal mejorada
function main {
    # Verificar si el script se ejecuta en un terminal compatible
    if [ -t 1 ]; then
        echo -e "${Verde}Iniciando script de información del sistema...${NC}"
        sleep 1
    fi
    
    # Bucle principal del script
    while true; do
        mostrar_menu
        
        # Leer opción con validación
        while ! leer_opcion; do
            mostrar_menu
        done
        
        evaluar_opcion
        
        # Solo hacer pausa si no es la opción de salir
        if [ "$opcion" != "22" ]; then
            pausa
        fi
    done
}

# Ejecutar función principal
main
