#!/usr/bin/env bash

# COLORES Y VARIABLES BASE
Negro='\033[0;30m'; Rojo='\033[0;31m'; Verde='\033[0;32m'; Marron_Naranja='\033[0;33m'
Azul='\033[0;34m'; Morado='\033[0;35m'; Cian='\033[0;36m'; GrisClaro='\033[0;37m'
GrisOscuro='\033[1;30m'; RojoClaro='\033[1;31m'; VerdeClaro='\033[1;32m'; Amarillo='\033[1;33m'
AzulClaro='\033[1;34m'; MoradoClaro='\033[1;35m'; CianClaro='\033[1;36m'; Blanco='\033[1;37m'; NaranjaClaro='\033[38;2;255;184;82m'
Negrita='\033[1m'; Subrayado='\033[4m'; Inverso='\033[7m'; NC='\033[0m'
FECHA_REPORTE=$(date '+%Y-%m-%d_%H-%M-%S')

# ============================================
# VARIABLE GLOBAL PARA MODO REPORTE
# ============================================
MODO_REPORTE=0

# ============================================
# FUNCIÓN MEJORADA PARA MOSTRAR Y PAGINAR LISTADOS
# ============================================
function mostrar_con_paginador() {
    local cmd="$1"
    local resumen="$2"
    
    # En modo reporte, mostrar todo sin interacción
    if [ "$MODO_REPORTE" -eq 1 ]; then
        eval "$cmd" 2>/dev/null
        return
    fi
    
    local total_lineas
    total_lineas=$(eval "$cmd" 2>/dev/null | wc -l)
    if (( total_lineas <= resumen )) || [ "$total_lineas" -eq 0 ]; then
        eval "$cmd" 2>/dev/null || echo "❌ No se pudo ejecutar el comando o no hay datos"
    else
        eval "$cmd 2>/dev/null | head -n $resumen"
        echo ""
        read -p "Hay $total_lineas resultados. ¿Ver todos paginados en less? (s/n): " resp
        if [[ "$resp" =~ ^[sS]$ ]]; then
            eval "$cmd 2>/dev/null | less"
        fi
    fi
}

# ========================================
# FUNCIONES DE PANTALLA Y UTILIDADES BÁSICAS
# ========================================
function limpiar_pantalla { clear; }

function mostrar_banner {
    echo -e "${CianClaro}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CianClaro}║${Blanco}${Negrita}           CONFIGURACIÓN DEL SISTEMA                        ${NC}${CianClaro}║${NC}"
    echo -e "${CianClaro}║${GrisClaro}                   Debian GNU/Linux                         ${NC}${CianClaro}║${NC}"
    echo -e "${CianClaro}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Función auxiliar para crear líneas del menú con ancho consistente
function menu_line {
    local left="$1"
    local right="$2"
    local ancho_total=58  # 66 - 8 caracteres de margen
    local ancho_left=${#left}
    local ancho_right=${#right}
    local espacios=$((ancho_total - ancho_left - ancho_right))
    
    printf "${Morado}┃${NC}  %s%*s%s  ${Morado}┃${NC}\n" "$left" "$espacios" "" "$right"
}

function menu_seccion {
    local titulo="$1"
    local color="$2"
    printf "${Morado}┃${NC}  ${color}${Negrita}%-58s${NC}  ${Morado}┃${NC}\n" "$titulo"
}

function menu_item {
    local numero="$1"
    local texto="$2"
    local color="$3"
    printf "${Morado}┃${NC}    ${color}%-4s${NC} %-50s  ${Morado}┃${NC}\n" "$numero" "$texto"
}

function menu_item_doble {
    local num1="$1"
    local text1="$2"
    local num2="$3"
    local text2="$4"
    local color="$5"
    printf "${Morado}┃${NC}    ${color}%-4s${NC} %-20s   ${color}%-4s${NC} %-20s  ${Morado}┃${NC}\n" "$num1" "$text1" "$num2" "$text2"
}

function mostrar_menu {
    limpiar_pantalla
    mostrar_banner
    
    # Función auxiliar simple sin detección automática de emojis
    linea() {
        local contenido="$1"
        local ajuste_emoji="${2:-0}"  # Parámetro opcional para compensar emojis
        local ancho=60
        local limpio=$(echo -e "$contenido" | sed 's/\x1b\[[0-9;]*m//g')
        local len=${#limpio}
        local espacios=$((ancho - len - ajuste_emoji))
        printf "${Morado}┃${NC}%b%*s${Morado}┃${NC}\n" "$contenido" "$espacios" ""
    }
    
    echo -e "${Morado}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${NC}"
    linea " ${Blanco}${Negrita}MENÚ DE OPCIONES${NC}"
    echo -e "${Morado}┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫${NC}"
    linea ""
    linea " ${Amarillo}${Negrita}📦 PROGRAMAS INSTALADOS${NC}" 1
    linea "    ${Amarillo}[1]${NC}  Paquetes del sistema (apt/rpm)"
    linea "    ${Amarillo}[2]${NC}  Binarios en PATH"
    linea "    ${Amarillo}[3]${NC}  Software de usuario (~/.local)"
    linea ""
    linea " ${AzulClaro}${Negrita}🔧 SERVICIOS Y PROCESOS${NC}" 1
    linea "    ${CianClaro}[4]${NC}  Servicios de arranque (habilitados)"
    linea "    ${CianClaro}[5]${NC}  Servicios activos (en ejecución)"
    linea "    ${CianClaro}[6]${NC}  Servicios inactivos (no ejecutándose)"
    linea "    ${CianClaro}[7]${NC}  Procesos en ejecución (tree)"
    linea "    ${CianClaro}[8]${NC}  Conexiones de red (listen)"
    linea ""
    linea " ${Verde}${Negrita}👥 USUARIOS Y GRUPOS${NC}" 1
    linea "    ${VerdeClaro}[9]${NC}  Usuarios del sistema"
    linea "    ${VerdeClaro}[10]${NC} Grupos y miembros"
    linea "    ${VerdeClaro}[11]${NC} Últimos logins"
    linea "    ${VerdeClaro}[12]${NC} Usuarios con shell"
    linea ""
    linea " ${NaranjaClaro}${Negrita}⚡ CONFIGURACIÓN AVANZADA${NC}" 1
    linea "    ${NaranjaClaro}[13]${NC} Variables de entorno"
    linea "    ${NaranjaClaro}[14]${NC} Tareas programadas (cron)"
    linea "    ${NaranjaClaro}[15]${NC} Módulos del kernel"
    linea "    ${NaranjaClaro}[16]${NC} Parámetros del kernel (sysctl)"
    linea ""
    echo -e "${Morado}┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫${NC}"
    linea " ${MoradoClaro}${Negrita}[17]${NC} 📊 REPORTE COMPLETO (todas las secciones)" 1
    linea " ${RojoClaro}${Negrita}[18]${NC} 🚪 Salir" 1
    echo -e "${Morado}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${NC}"
    echo ""
}

function mostrar_encabezado_seccion {
    local titulo="$1"
    local color="$2"
    local ancho=62
    
    # En modo reporte, usar formato simple sin colores
    if [ "$MODO_REPORTE" -eq 1 ]; then
        echo ""
        echo "========================================================================"
        echo "    $titulo"
        echo "========================================================================"
        echo ""
        return
    fi
    
    # Eliminar códigos ANSI para calcular longitud real
    local titulo_limpio=$(echo -e "$titulo" | sed 's/\x1b\[[0-9;]*m//g')
    local len=${#titulo_limpio}
    local espacios=$((ancho - len - 2))  # -2 por los espacios antes y después
    
    printf "\n"
    echo -e "${color}╔══════════════════════════════════════════════════════════════╗${NC}"
    printf "${color}║${NC} ${Blanco}${Negrita}%s${NC}%*s ${color}║${NC}\n" "$titulo" "$espacios" ""
    echo -e "${color}╚══════════════════════════════════════════════════════════════╝${NC}"
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
# SECCIONES MEJORADAS (SIN INTERACCIÓN EN MODO REPORTE)
# ================

function mostrar_paquetes_sistema {
    mostrar_encabezado_seccion "PAQUETES DEL SISTEMA" "${Verde}"
    if command -v dpkg &>/dev/null; then
        local total_pkgs=$(dpkg --get-selections | grep -c 'install')
        echo "📦 Total de paquetes instalados (dpkg): $total_pkgs"
        echo ""
        
        if [ "$MODO_REPORTE" -eq 1 ]; then
            echo "🔝 Últimos 50 paquetes instalados:"
            grep ' install ' /var/log/dpkg.log 2>/dev/null | tail -50 | awk '{print $1, $2, $4}' | column -t
            echo ""
            echo "Lista completa de paquetes:"
            dpkg --get-selections | grep 'install' | head -100
        else
            echo "🔝 Últimos 20 paquetes instalados (resumen):"
            local cmd_resumen="grep ' install ' /var/log/dpkg.log 2>/dev/null | tail -20 | awk '{print \$1, \$2, \$4}' | column -t"
            mostrar_con_paginador "$cmd_resumen" 20
            
            echo ""
            read -p "¿Desea ver la lista completa de paquetes instalados paginada? (s/n): " resp
            if [[ "$resp" =~ ^[sS]$ ]]; then
                dpkg --get-selections | grep 'install' | less
            fi
        fi
    elif command -v rpm &>/dev/null; then
        local total_pkgs=$(rpm -qa | wc -l)
        echo "📦 Total de paquetes instalados (rpm): $total_pkgs"
        echo ""
        
        if [ "$MODO_REPORTE" -eq 1 ]; then
            echo "🔝 Últimos 50 paquetes instalados:"
            rpm -qa --last | head -50
        else
            echo "🔝 Últimos 20 paquetes instalados (resumen):"
            local cmd_resumen="rpm -qa --last | head -20"
            mostrar_con_paginador "$cmd_resumen" 20
            
            echo ""
            read -p "¿Desea ver la lista completa de paquetes instalados paginada? (s/n): " resp
            if [[ "$resp" =~ ^[sS]$ ]]; then
                rpm -qa | sort | less
            fi
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
                count=$(find "$dir" -maxdepth 1 -type f -executable 2>/dev/null | wc -l)
                echo "$dir: $count binarios ejecutables"
            fi
        done
    } | mostrar_con_paginador "cat" 10
}

function mostrar_software_usuario {
    mostrar_encabezado_seccion "SOFTWARE DE USUARIO" "${Verde}"
    if [ -d "$HOME/.local" ]; then
        echo "📁 Contenido de ~/.local:"
        if [ "$MODO_REPORTE" -eq 1 ]; then
            find "$HOME/.local" -maxdepth 2 -type d 2>/dev/null
        else
            mostrar_con_paginador "find \"$HOME/.local\" -maxdepth 2 -type d 2>/dev/null" 10
        fi
        echo ""
        echo "📊 Estadísticas:"
        echo "Directorios: $(find "$HOME/.local" -type d 2>/dev/null | wc -l)"
        echo "Archivos: $(find "$HOME/.local" -type f 2>/dev/null | wc -l)"
    else
        echo "❌ Directorio ~/.local no encontrado"
    fi
}

function mostrar_servicios_habilitados {
    mostrar_encabezado_seccion "SERVICIOS DE ARRANQUE (HABILITADOS)" "${AzulClaro}"
    if command -v systemctl &>/dev/null; then
        echo "🔄 Servicios habilitados para arranque automático:"
        if [ "$MODO_REPORTE" -eq 1 ]; then
            systemctl list-unit-files --type=service --state=enabled
        else
            mostrar_con_paginador "systemctl list-unit-files --type=service --state=enabled" 15
        fi
        echo ""
        echo "📊 Total de servicios habilitados: $(systemctl list-unit-files --type=service --state=enabled | grep -c 'enabled')"
    else
        echo "❌ systemctl no disponible. Verificando con service:"
        service --status-all 2>/dev/null | grep '\[ + \]' | head -10
    fi
}

function mostrar_servicios_activos {
    mostrar_encabezado_seccion "SERVICIOS ACTIVOS (EN EJECUCIÓN)" "${AzulClaro}"
    if command -v systemctl &>/dev/null; then
        echo "▶️ Servicios actualmente en ejecución:"
        if [ "$MODO_REPORTE" -eq 1 ]; then
            systemctl list-units --type=service --state=active
        else
            mostrar_con_paginador "systemctl list-units --type=service --state=active" 15
        fi
        echo ""
        echo "📊 Total de servicios activos: $(systemctl list-units --type=service --state=active | grep -c 'active')"
    else
        echo "❌ systemctl no disponible. Mostrando procesos de sistema:"
        ps aux | grep -E '\[.*\]' | head -10
    fi
}

function mostrar_servicios_inactivos {
    mostrar_encabezado_seccion "SERVICIOS INACTIVOS (NO EJECUTÁNDOSE)" "${AzulClaro}"
    if command -v systemctl &>/dev/null; then
        echo "⏸️ Servicios instalados pero no en ejecución:"
        if [ "$MODO_REPORTE" -eq 1 ]; then
            systemctl list-units --type=service --state=inactive
        else
            mostrar_con_paginador "systemctl list-units --type=service --state=inactive" 15
        fi
        echo ""
        echo "📊 Total de servicios inactivos: $(systemctl list-units --type=service --state=inactive | grep -c 'inactive')"
        echo ""
        echo "❌ Servicios fallidos:"
        systemctl list-units --type=service --state=failed
    else
        echo "❌ systemctl no disponible en este sistema"
    fi
}

function mostrar_procesos_tree {
    mostrar_encabezado_seccion "PROCESOS EN EJECUCIÓN (ÁRBOL)" "${AzulClaro}"
    if command -v pstree &>/dev/null; then
        echo "🌳 Árbol de procesos:"
        if [ "$MODO_REPORTE" -eq 1 ]; then
            pstree -p -U
        else
            mostrar_con_paginador "pstree -p -U" 20
        fi
    else
        echo "📋 Lista de procesos (pstree no disponible):"
        mostrar_con_paginador "ps aux --forest" 15
    fi
    echo ""
    echo "📊 Estadísticas de procesos:"
    echo "Total de procesos: $(ps aux | wc -l)"
    echo "Procesos del usuario actual: $(ps -u \"$USER\" | wc -l)"
}

function mostrar_conexiones_red {
    mostrar_encabezado_seccion "CONEXIONES DE RED (LISTENING)" "${AzulClaro}"
    echo "🌐 Puertos en escucha:"
    if command -v ss &>/dev/null; then
        if [ "$MODO_REPORTE" -eq 1 ]; then
            ss -tuln
        else
            ss -tuln | head -15
        fi
    elif command -v netstat &>/dev/null; then
        if [ "$MODO_REPORTE" -eq 1 ]; then
            netstat -tuln
        else
            netstat -tuln | head -15
        fi
    else
        echo "❌ ss y netstat no disponibles"
    fi
}

function mostrar_usuarios_sistema {
    mostrar_encabezado_seccion "USUARIOS DEL SISTEMA" "${VerdeClaro}"
    echo "👥 Usuarios del sistema:"
    if [ "$MODO_REPORTE" -eq 1 ]; then
        awk -F: '{print $1 " (UID:" $3 ", GID:" $4 ", Shell:" $7 ")"}' /etc/passwd
    else
        mostrar_con_paginador "awk -F: '{print \$1 \" (UID:\" \$3 \", GID:\" \$4 \", Shell:\" \$7 \")\"}' /etc/passwd" 15
    fi
    echo ""
    echo "📊 Estadísticas:"
    echo "Total de usuarios: $(wc -l < /etc/passwd)"
    echo "Usuarios con UID >= 1000: $(awk -F: '$3 >= 1000 {print $1}' /etc/passwd | wc -l)"
}

function mostrar_grupos_miembros {
    mostrar_encabezado_seccion "GRUPOS Y MIEMBROS" "${VerdeClaro}"
    echo "👥 Grupos del sistema:"
    if [ "$MODO_REPORTE" -eq 1 ]; then
        awk -F: '{print $1 " (GID:" $3 ") - Miembros: " $4}' /etc/group
    else
        mostrar_con_paginador "awk -F: '{print \$1 \" (GID:\" \$3 \") - Miembros: \" \$4}' /etc/group" 15
    fi
}

function mostrar_ultimos_logins {
    mostrar_encabezado_seccion "ÚLTIMOS LOGINS" "${VerdeClaro}"
    echo "🔐 Últimos logins exitosos:"
    if command -v last &>/dev/null; then
        if [ "$MODO_REPORTE" -eq 1 ]; then
            last -20
        else
            last -10
        fi
    else
        echo "❌ Comando 'last' no disponible"
    fi
}

function mostrar_usuarios_shell {
    mostrar_encabezado_seccion "USUARIOS CON SHELL" "${VerdeClaro}"
    echo "🐚 Usuarios con shell válido:"
    if [ "$MODO_REPORTE" -eq 1 ]; then
        grep -E '/bin/(bash|sh|zsh|fish|csh|tcsh)$' /etc/passwd | awk -F: '{print $1, $5, $7}' | column -t
    else
        mostrar_con_paginador "grep -E '/bin/(bash|sh|zsh|fish|csh|tcsh)$' /etc/passwd | awk -F: '{print \$1, \$5, \$7}' | column -t" 8
    fi
}

function mostrar_variables_entorno {
    mostrar_encabezado_seccion "VARIABLES DE ENTORNO" "${Amarillo}"
    echo "🌍 Variables de entorno del sistema:"
    if [ "$MODO_REPORTE" -eq 1 ]; then
        env | sort
    else
        mostrar_con_paginador "env | sort" 15
    fi
}

function mostrar_tareas_cron {
    mostrar_encabezado_seccion "TAREAS PROGRAMADAS (CRON)" "${Amarillo}"
    echo "⏰ Crontab del usuario actual:"
    crontab -l 2>/dev/null || echo "   No hay tareas cron para el usuario actual"
    echo ""
    echo "🗂️ Archivos cron del sistema:"
    if [ -d /etc/cron.d ] && [ -r /etc/cron.d ]; then
        ls -la /etc/cron.d/ 2>/dev/null | head -10
    fi
}

function mostrar_modulos_kernel {
    mostrar_encabezado_seccion "MÓDULOS DEL KERNEL" "${Amarillo}"
    if [ -f /proc/modules ]; then
        echo "🔧 Módulos cargados:"
        if [ "$MODO_REPORTE" -eq 1 ]; then
            cat /proc/modules
        else
            cat /proc/modules | head -20
        fi
    else
        echo "❌ No se puede acceder a la información de módulos"
    fi
}

function mostrar_parametros_kernel {
    mostrar_encabezado_seccion "PARÁMETROS DEL KERNEL (SYSCTL)" "${Amarillo}"
    if command -v sysctl &>/dev/null; then
        echo "⚙️ Parámetros del kernel (resumen):"
        if [ "$MODO_REPORTE" -eq 1 ]; then
            sysctl -a 2>/dev/null
        else
            sysctl -a 2>/dev/null | head -30
        fi
    else
        echo "❌ Comando sysctl no disponible"
    fi
}

# ============================================
# FUNCIÓN MEJORADA: GUARDAR REPORTE COMPLETO EN ARCHIVO
# ============================================
function guardar_reporte_completo {
    local archivo="reporte_configuracion_$(date '+%Y%m%d_%H%M%S').txt"
    
    mostrar_encabezado_seccion "GENERANDO REPORTE COMPLETO EN ARCHIVO" "${MoradoClaro}"
    echo -e "${Verde}📋 Generando reporte completo del sistema...${NC}"
    echo -e "${GrisClaro}📁 Archivo: $archivo${NC}"
    echo ""
    
    # Activar modo reporte
    MODO_REPORTE=1
    
    # Crear archivo con encabezado
    {
        echo "==================================================="
        echo "    REPORTE DE CONFIGURACIÓN DEL SISTEMA"
        echo "    Generado: $(date)"
        echo "    Sistema: $(uname -a)"
        echo "    Usuario: $USER"
        echo "    Hostname: $(hostname)"
        echo "==================================================="
        echo ""
    } > "$archivo"
    
    # Lista de funciones a ejecutar
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
    
    # Ejecutar cada función y guardar en archivo
    for func in "${funciones[@]}"; do
        echo ">>> EJECUTANDO: $func" >> "$archivo"
        $func >> "$archivo" 2>&1
        echo "" >> "$archivo"
        echo "--------------------------------------------------------------------------------" >> "$archivo"
        echo "" >> "$archivo"
        echo -e "${Verde}✓${NC} Sección '$func' completada"
    done
    
    # Desactivar modo reporte
    MODO_REPORTE=0
    
    echo -e "${VerdeClaro}${Negrita}✅ Reporte completo guardado en: $archivo${NC}"
    echo -e "${GrisClaro}📊 Tamaño del archivo: $(du -h "$archivo" | cut -f1)${NC}"
    echo -e "${GrisClaro}🔍 Líneas totales: $(wc -l < "$archivo")${NC}"
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
        17) guardar_reporte_completo      ;;
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
