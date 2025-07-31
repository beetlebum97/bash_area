#!/usr/bin/env bash

# COLORES Y VARIABLES BASE
Negro='\033[0;30m'; Rojo='\033[0;31m'; Verde='\033[0;32m'; Marron_Naranja='\033[0;33m'
Azul='\033[0;34m'; Morado='\033[0;35m'; Cian='\033[0;36m'; GrisClaro='\033[0;37m'
GrisOscuro='\033[1;30m'; RojoClaro='\033[1;31m'; VerdeClaro='\033[1;32m'; Amarillo='\033[1;33m'
AzulClaro='\033[1;34m'; MoradoClaro='\033[1;35m'; CianClaro='\033[1;36m'; Blanco='\033[1;37m'; NaranjaClaro='\033[38;2;255;184;82m'
Negrita='\033[1m'; Subrayado='\033[4m'; Inverso='\033[7m'; NC='\033[0m'
FECHA_REPORTE=$(date '+%Y-%m-%d_%H-%M-%S')

# ============================================
# FUNCIÓN MEJORADA PARA MOSTRAR Y PAGINAR LISTADOS
# ============================================
function mostrar_con_paginador() {
    local cmd="$1"
    local resumen="$2"
    local total_lineas
    total_lineas=$(eval "$cmd" | wc -l)
    if (( total_lineas <= resumen )); then
        eval "$cmd"
    else
        eval "$cmd | head -n $resumen"
        echo ""
        read -p "Hay $total_lineas resultados. ¿Ver todos paginados en less? (s/n): " resp
        if [[ "$resp" =~ ^[sS]$ ]]; then
            eval "$cmd | less"
        fi
    fi
}

# ========================================
# FUNCIONES DE PANTALLA Y UTILIDADES BÁSICAS
# ========================================
function limpiar_pantalla { clear; }

function mostrar_banner {
    echo -e "${CianClaro}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CianClaro}║${Blanco}${Negrita} CONFIGURACIÓN DEL SISTEMA ${NC}${CianClaro}                                   ║${NC}"
    echo -e "${CianClaro}║${GrisClaro} Debian GNU/Linux ${NC}${CianClaro}                                            ║${NC}"
    echo -e "${CianClaro}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

function mostrar_menu {
    limpiar_pantalla
    mostrar_banner
    echo -e "${Morado}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${NC}"
    echo -e "${Morado}┃${Blanco}${Negrita} MENÚ DE OPCIONES ${NC}${Morado}┃${NC}"
    echo -e "${Morado}┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫${NC}"
    echo -e "${Morado}┃ ┃${NC}"
    echo -e "${Morado}┃ ${Amarillo}${Negrita}📦 PROGRAMAS INSTALADOS${NC} ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${Amarillo}[1]${NC} Paquetes del sistema (apt/rpm) ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${Amarillo}[2]${NC} Binarios en PATH ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${Amarillo}[3]${NC} Software de usuario (~/.local) ${Morado}┃${NC}"
    echo -e "${Morado}┃ ┃${NC}"
    echo -e "${Morado}┃ ${AzulClaro}${Negrita}🛡️ SERVICIOS Y PROCESOS${NC} ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${CianClaro}[4]${NC} Servicios de arranque (habilitados) ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${CianClaro}[5]${NC} Servicios activos (en ejecución) ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${CianClaro}[6]${NC} Servicios inactivos (no ejecutándose) ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${CianClaro}[7]${NC} Procesos en ejecución (tree) ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${CianClaro}[8]${NC} Conexiones de red (listen) ${Morado}┃${NC}"
    echo -e "${Morado}┃ ┃${NC}"
    echo -e "${Morado}┃ ${Verde}${Negrita}👥 USUARIOS Y GRUPOS${NC} ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${VerdeClaro}[9]${NC} Usuarios del sistema ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${VerdeClaro}[10]${NC} Grupos y miembros ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${VerdeClaro}[11]${NC} Últimos logins ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${VerdeClaro}[12]${NC} Usuarios con shell ${Morado}┃${NC}"
    echo -e "${Morado}┃ ┃${NC}"
    echo -e "${Morado}┃ ${NaranjaClaro}${Negrita}⚙️ CONFIGURACIÓN AVANZADA${NC} ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${NaranjaClaro}[13]${NC} Variables de entorno ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${NaranjaClaro}[14]${NC} Tareas programadas (cron) ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${NaranjaClaro}[15]${NC} Módulos del kernel ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${NC} ${NaranjaClaro}[16]${NC} Parámetros del kernel (sysctl) ${Morado}┃${NC}"
    echo -e "${Morado}┃ ┃${NC}"
    echo -e "${Morado}┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫${NC}"
    echo -e "${Morado}┃ ${MoradoClaro}${Negrita}[17] 📊 REPORTE COMPLETO (todas las secciones)${NC} ${Morado}┃${NC}"
    echo -e "${Morado}┃ ${RojoClaro}${Negrita}[18] 🚪 Salir${NC} ${Morado}┃${NC}"
    echo -e "${Morado}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
    echo ""
}

function mostrar_encabezado_seccion {
    local titulo="$1"
    local color="$2"
    local ancho_total=66
    local titulo_limpio=$(echo -e "$titulo" | sed 's/\x1B\[[0-9;]*[mK]//g')
    local longitud_titulo=${#titulo_limpio}
    local longitud_linea=$((ancho_total - 4))
    printf "\n"
    echo -e "${color}╔════════════════════════════════════════════════════════════════╗${NC}"
    printf "${color}║${Blanco}${Negrita} %-*s ${color}║${NC}\n" "$longitud_linea" "$titulo"
    echo -e "${color}╚════════════════════════════════════════════════════════════════╝${NC}"
    printf "\n"
}

function leer_opcion {
    echo -ne "${Cian}${Negrita}➤ Selecciona una opción [1-18]: ${NC}"
    read opcion
    if ! [[ "$opcion" =~ ^[0-9]+$ ]] || [ "$opcion" -lt 1 ] || [ "$opcion" -gt 18 ]; then
        echo -e "${Rojo}❌ Opción inválida. Por favor, introduce un número entre 1 y 18.${NC}"
        sleep 2
        return 1
    fi
    return 0
}

# ================
# SECCIONES
# ================

function mostrar_paquetes_sistema {
    mostrar_encabezado_seccion "PAQUETES DEL SISTEMA" "${Verde}"
    if command -v dpkg &>/dev/null 2>&1; then
        local total_pkgs=$(dpkg --get-selections | grep -c 'install')
        echo "📦 Total de paquetes instalados (dpkg): $total_pkgs"
        echo ""
        echo "🔝 Últimos 20 paquetes instalados (resumen):"
        local cmd_resumen="grep ' install ' /var/log/dpkg.log* 2>/dev/null | tail -20 | awk '{print \$1, \$2, \$4}' | column -t"
        mostrar_con_paginador "$cmd_resumen" 20

        echo ""
        read -p "¿Desea ver la lista completa de paquetes instalados paginada? (s/n): " resp
        if [[ "$resp" =~ ^[sS]$ ]]; then
            dpkg --get-selections | grep 'install' | less
        fi
    elif command -v rpm &>/dev/null 2>&1; then
        local total_pkgs=$(rpm -qa | wc -l)
        echo "📦 Total de paquetes instalados (rpm): $total_pkgs"
        echo ""
        echo "🔝 Últimos 20 paquetes instalados (resumen):"
        local cmd_resumen="rpm -qa --last | head -20"
        mostrar_con_paginador "$cmd_resumen" 20

        echo ""
        read -p "¿Desea ver la lista completa de paquetes instalados paginada? (s/n): " resp
        if [[ "$resp" =~ ^[sS]$ ]]; then
            rpm -qa | sort | less
        fi
    else
        echo "❌ No se encontró gestor de paquetes compatible (dpkg/rpm)"
    fi
}

function mostrar_binarios_path {
    mostrar_encabezado_seccion "BINARIOS EN PATH" "${Verde}"
    echo "📂 Directorios en PATH:"
    echo "$PATH" | tr ':' '\n' | nl
    echo ""
    echo "🔧 Binarios disponibles por directorio:"
    IFS=':' read -ra DIRS <<< "$PATH"
    {
        for dir in "${DIRS[@]}"; do
            if [ -d "$dir" ]; then
                count=$(ls -1 "$dir" 2>/dev/null | wc -l)
                echo "$dir: $count binarios"
            fi
        done
    } | mostrar_con_paginador "cat" 10
}

function mostrar_software_usuario {
    mostrar_encabezado_seccion "SOFTWARE DE USUARIO" "${Verde}"
    if [ -d "$HOME/.local" ]; then
        echo "📁 Contenido de ~/.local:"
        mostrar_con_paginador "find \"$HOME/.local\" -maxdepth 3 -type d 2>/dev/null" 10
        echo ""
        echo "📊 Estadísticas:"
        echo "Directorios: $(find "$HOME/.local" -type d 2>/dev/null | wc -l)"
        echo "Archivos: $(find "$HOME/.local" -type f 2>/dev/null | wc -l)"
    else
        echo "❌ Directorio ~/.local no encontrado"
    fi
    if [ -f "$HOME/.bashrc" ]; then
        echo ""
        echo "⚙️ Aliases personalizados en ~/.bashrc:"
        mostrar_con_paginador "grep '^alias' \"$HOME/.bashrc\" 2>/dev/null" 10
    fi
}

function mostrar_servicios_habilitados {
    mostrar_encabezado_seccion "SERVICIOS DE ARRANQUE (HABILITADOS)" "${AzulClaro}"
    if command -v systemctl &>/dev/null 2>&1; then
        echo "🔄 Servicios habilitados para arranque automático:"
        mostrar_con_paginador "systemctl list-unit-files --type=service --state=enabled" 15
        echo ""
        echo "📊 Total de servicios habilitados: $(systemctl list-unit-files --type=service --state=enabled | grep -c 'enabled')"
    else
        echo "❌ systemctl no disponible. Verificando con service:"
        mostrar_con_paginador "service --status-all 2>/dev/null | grep '\\[ + \\]'" 10
    fi
}

function mostrar_servicios_activos {
    mostrar_encabezado_seccion "SERVICIOS ACTIVOS (EN EJECUCIÓN)" "${AzulClaro}"
    if command -v systemctl &>/dev/null 2>&1; then
        echo "▶️ Servicios actualmente en ejecución:"
        mostrar_con_paginador "systemctl list-units --type=service --state=active" 15
        echo ""
        echo "📊 Total de servicios activos: $(systemctl list-units --type=service --state=active | grep -c 'active')"
    else
        echo "❌ systemctl no disponible. Mostrando procesos de sistema:"
        mostrar_con_paginador "ps aux | grep -E '\\[.*\\]'" 10
    fi
}

function mostrar_servicios_inactivos {
    mostrar_encabezado_seccion "SERVICIOS INACTIVOS (NO EJECUTÁNDOSE)" "${AzulClaro}"
    if command -v systemctl &>/dev/null 2>&1; then
        echo "⏸️ Servicios instalados pero no en ejecución:"
        mostrar_con_paginador "systemctl list-units --type=service --state=inactive" 15
        echo ""
        echo "📊 Total de servicios inactivos: $(systemctl list-units --type=service --state=inactive | grep -c 'inactive')"
        echo ""
        echo "❌ Servicios fallidos:"
        mostrar_con_paginador "systemctl list-units --type=service --state=failed" 5
    else
        echo "❌ systemctl no disponible. Verificando con service:"
        mostrar_con_paginador "service --status-all 2>/dev/null | grep '\\[ - \\]'" 10
    fi
}

function mostrar_procesos_tree {
    mostrar_encabezado_seccion "PROCESOS EN EJECUCIÓN (ÁRBOL)" "${AzulClaro}"
    if command -v pstree &>/dev/null 2>&1; then
        echo "🌳 Árbol de procesos:"
        mostrar_con_paginador "pstree -p" 15
    else
        echo "📋 Lista de procesos (pstree no disponible):"
        mostrar_con_paginador "ps aux --forest" 15
    fi
    echo ""
    echo "📊 Estadísticas de procesos:"
    echo "Total de procesos: $(ps aux | wc -l)"
    echo "Procesos del usuario actual: $(ps u | wc -l)"
}

function mostrar_conexiones_red {
    mostrar_encabezado_seccion "CONEXIONES DE RED (LISTENING)" "${AzulClaro}"
    echo "🌐 Puertos en escucha:"
    if command -v ss &>/dev/null 2>&1; then
        mostrar_con_paginador "ss -tuln" 12
    elif command -v netstat &>/dev/null 2>&1; then
        mostrar_con_paginador "netstat -tuln" 12
    else
        echo "❌ ss y netstat no disponibles"
    fi
    echo ""
    echo "🔗 Conexiones establecidas (primeras 10):"
    if command -v ss &>/dev/null 2>&1; then
        mostrar_con_paginador "ss -tun state established" 10
    else
        mostrar_con_paginador "netstat -tun | grep ESTABLISHED" 10
    fi
}

function mostrar_usuarios_sistema {
    mostrar_encabezado_seccion "USUARIOS DEL SISTEMA" "${VerdeClaro}"
    echo "👥 Usuarios del sistema:"
    mostrar_con_paginador "awk -F: '{print \$1 \" (UID:\" \$3 \", GID:\" \$4 \", Shell:\" \$7 \")\"}' /etc/passwd" 15
    echo ""
    echo "📊 Estadísticas:"
    echo "Total de usuarios: $(wc -l < /etc/passwd)"
    echo "Usuarios con UID >= 1000: $(awk -F: '\$3 >= 1000 {print \$1}' /etc/passwd | wc -l)"
    echo "Usuarios con shell /bin/bash: $(grep '/bin/bash' /etc/passwd | wc -l)"
}

function mostrar_grupos_miembros {
    mostrar_encabezado_seccion "GRUPOS Y MIEMBROS" "${VerdeClaro}"
    echo "👥 Grupos del sistema:"
    mostrar_con_paginador "awk -F: '{print \$1 \" (GID:\" \$3 \") - Miembros: \" \$4}' /etc/group" 15
    echo ""
    echo "🔑 Grupos importantes:"
    for grupo in sudo wheel admin root docker; do
        if grep -q "^$grupo:" /etc/group; then
            miembros=$(grep "^$grupo:" /etc/group | cut -d: -f4)
            echo "$grupo: $miembros"
        fi
    done
}

function mostrar_ultimos_logins {
    mostrar_encabezado_seccion "ÚLTIMOS LOGINS" "${VerdeClaro}"
    echo "🔐 Últimos logins exitosos:"
    if command -v last &>/dev/null 2>&1; then
        last -10
    else
        echo "❌ Comando 'last' no disponible"
    fi
    echo ""
    echo "❌ Intentos fallidos de login (últimos 10):"
    if [ -f /var/log/auth.log ]; then
        mostrar_con_paginador "grep 'Failed password' /var/log/auth.log 2>/dev/null | tail -10 | awk '{print \$1, \$2, \$3, \$9, \$11}'" 5
    elif [ -f /var/log/secure ]; then
        mostrar_con_paginador "grep 'Failed password' /var/log/secure 2>/dev/null | tail -10" 5
    else
        echo "❌ Logs de autenticación no accesibles"
    fi
}

function mostrar_usuarios_shell {
    mostrar_encabezado_seccion "USUARIOS CON SHELL" "${VerdeClaro}"
    echo "🐚 Usuarios con shell válido:"
    mostrar_con_paginador "grep -E '/bin/(bash|sh|zsh|fish|csh|tcsh)$' /etc/passwd | awk -F: '{print \$1, \$5, \$7}' | column -t" 8
    echo ""
    echo "🚫 Usuarios sin shell (nologin/false):"
    mostrar_con_paginador "grep -E '/(nologin|false)$' /etc/passwd" 8
    echo "Total: $(grep -E '/(nologin|false)$' /etc/passwd | wc -l)"
}

function mostrar_variables_entorno {
    mostrar_encabezado_seccion "VARIABLES DE ENTORNO" "${Amarillo}"
    echo "🌍 Variables de entorno del sistema:"
    mostrar_con_paginador "env | sort" 10
    echo ""
    echo "🔧 Variables importantes:"
    for var in PATH HOME USER SHELL TERM LANG; do
        echo "$var: ${!var}"
    done
}

function mostrar_tareas_cron {
    mostrar_encabezado_seccion "TAREAS PROGRAMADAS (CRON)" "${Amarillo}"
    echo "⏰ Crontab del usuario actual:"
    crontab -l 2>/dev/null || echo "No hay tareas cron para el usuario actual"
    echo ""
    echo "🗂️ Archivos cron del sistema:"
    if [ -d /etc/cron.d ]; then
        echo "Archivos en /etc/cron.d:"
        mostrar_con_paginador "ls -la /etc/cron.d/ 2>/dev/null" 10
    fi
    echo ""
    echo "📅 Tareas cron diarias/semanales/mensuales:"
    for periodo in daily weekly monthly; do
        if [ -d "/etc/cron.$periodo" ]; then
            echo "/etc/cron.$periodo: $(ls /etc/cron.$periodo 2>/dev/null | wc -l) archivos"
        fi
    done
}

function mostrar_modulos_kernel {
    mostrar_encabezado_seccion "MÓDULOS DEL KERNEL" "${Amarillo}"
    echo "🔧 Módulos cargados:"
    mostrar_con_paginador "lsmod | tail -n +2" 15
    echo ""
    echo "📊 Estadísticas de módulos:"
    echo "Total de módulos cargados: $(lsmod | tail -n +2 | wc -l)"
    echo ""
    echo "⚡ Módulos más utilizados:"
    mostrar_con_paginador "lsmod | tail -n +2 | sort -k3 -nr | awk '{print \$1, \"- Referencias:\", \$3}'" 10
}

function mostrar_parametros_kernel {
    mostrar_encabezado_seccion "PARÁMETROS DEL KERNEL (SYSCTL)" "${Amarillo}"
    echo "⚙️ Parámetros del kernel:"
    mostrar_con_paginador "sysctl -a 2>/dev/null" 15
    echo ""
    echo "🔒 Parámetros de seguridad importantes:"
    for param in kernel.randomize_va_space net.ipv4.ip_forward kernel.dmesg_restrict; do
        valor=$(sysctl -n $param 2>/dev/null)
        if [ -n "$valor" ]; then
            echo "$param = $valor"
        fi
    done
    echo ""
    echo "🌐 Parámetros de red importantes:"
    mostrar_con_paginador "sysctl -a 2>/dev/null | grep -E 'net.ipv4|net.ipv6'" 10
}

function generar_reporte_completo {
    mostrar_encabezado_seccion "REPORTE COMPLETO - AUDITORÍA DE CONFIGURACIÓN" "${MoradoClaro}"
    echo "📋 Generando reporte completo..."
    echo "⏰ Fecha: $(date)"
    echo "🖥️ Sistema: $(uname -a)"
    echo ""
    local funciones=(
        "mostrar_paquetes_sistema"
        "mostrar_binarios_path"
        "mostrar_software_usuario"
        "mostrar_servicios_habilitados"
        "mostrar_servicios_activos"
        "mostrar_servicios_inactivos"
        "mostrar_procesos_tree"
        "mostrar_conexiones_red"
        "mostrar_usuarios_sistema"
        "mostrar_grupos_miembros"
        "mostrar_ultimos_logins"
        "mostrar_usuarios_shell"
        "mostrar_variables_entorno"
        "mostrar_tareas_cron"
        "mostrar_modulos_kernel"
        "mostrar_parametros_kernel"
    )
    for func in "${funciones[@]}"; do
        echo -e "${Verde}Ejecutando: $func${NC}"
        $func
        echo -e "\n${GrisClaro}----------------------------------------${NC}\n"
        sleep 1
    done
    echo -e "${Verde}✅ Reporte completo generado exitosamente${NC}"
}

function evaluar_opcion {
    case $opcion in
        1)  mostrar_paquetes_sistema      ;;
        2)  mostrar_binarios_path         ;;
        3)  mostrar_software_usuario      ;;
        4)  mostrar_servicios_habilitados ;;
        5)  mostrar_servicios_activos     ;;
        6)  mostrar_servicios_inactivos   ;;
        7)  mostrar_procesos_tree         ;;
        8)  mostrar_conexiones_red        ;;
        9)  mostrar_usuarios_sistema      ;;
        10) mostrar_grupos_miembros       ;;
        11) mostrar_ultimos_logins        ;;
        12) mostrar_usuarios_shell        ;;
        13) mostrar_variables_entorno     ;;
        14) mostrar_tareas_cron           ;;
        15) mostrar_modulos_kernel        ;;
        16) mostrar_parametros_kernel     ;;
        17) generar_reporte_completo      ;;
        18)
            echo ""
            echo -e "${Verde}${Negrita}👋 ¡Gracias por usar el script de auditoría de configuración!${NC}"
            echo -e "${GrisClaro}Saliendo...${NC}"
            sleep 1
            exit 0
            ;;
        *)  echo -e "${Rojo}❌ Opción inválida. Intenta de nuevo.${NC}" ;;
    esac
}

function pausa {
    echo ""
    echo -e "${GrisClaro}${Negrita}Presiona [ENTER] para continuar...${NC}"
    read
}

function main {
    if [ -t 1 ]; then
        echo -e "${Verde}Iniciando script de auditoría de configuración...${NC}"
        sleep 1
    fi
    while true; do
        mostrar_menu
        while ! leer_opcion; do
            mostrar_menu
        done
        evaluar_opcion
        if [ "$opcion" != "18" ]; then
            pausa
        fi
    done
}

main
