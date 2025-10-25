#!/usr/bin/env bash

# COLORES Y VARIABLES BASE
Negro='\033[0;30m'; Rojo='\033[0;31m'; Verde='\033[0;32m'; Marron_Naranja='\033[0;33m'
Azul='\033[0;34m'; Morado='\033[0;35m'; Cian='\033[0;36m'; GrisClaro='\033[0;37m'
GrisOscuro='\033[1;30m'; RojoClaro='\033[1;31m'; VerdeClaro='\033[1;32m'; Amarillo='\033[1;33m'
AzulClaro='\033[1;34m'; MoradoClaro='\033[1;35m'; CianClaro='\033[1;36m'; Blanco='\033[1;37m'; NaranjaClaro='\033[38;2;255;184;82m'
Negrita='\033[1m'; Subrayado='\033[4m'; Inverso='\033[7m'; NC='\033[0m'

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
        eval "$cmd" 2>/dev/null | head -n "$resumen"
        echo ""
        read -p "Hay $total_lineas resultados. ¿Ver todos paginados en less? (s/n): " resp
        if [[ "$resp" =~ ^[sS]$ ]]; then
            eval "$cmd" 2>/dev/null | less
        fi
    fi
}

# ========================================
# FUNCIONES DE PANTALLA Y UTILIDADES BÁSICAS
# ========================================
function limpiar_pantalla { clear; }

function mostrar_banner {
    echo -e "${CianClaro}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CianClaro}║${Blanco}${Negrita}  ANALIZADOR DE DIRECTORIOS Y ARCHIVOS                      ${NC}${CianClaro}║${NC}"
    echo -e "${CianClaro}║${GrisClaro}             Análisis por tamaño y fecha                    ${NC}${CianClaro}║${NC}"
    echo -e "${CianClaro}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
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
    linea " ${Amarillo}${Negrita}📊 ANÁLISIS POR TAMAÑO${NC}" 1
    linea "    ${Amarillo}[1]${NC}  Directorios por tamaño (mayor a menor)"
    linea "    ${Amarillo}[2]${NC}  Archivos por tamaño (mayor a menor)"
    linea ""
    linea " ${AzulClaro}${Negrita}🕒 ANÁLISIS POR FECHA${NC}" 1
    linea "    ${CianClaro}[3]${NC}  Directorios por fecha (más recientes)"
    linea "    ${CianClaro}[4]${NC}  Archivos por fecha (más recientes)"
    linea ""
    linea " ${Verde}${Negrita}🔍 ANÁLISIS COMBINADO${NC}" 1
    linea "    ${VerdeClaro}[5]${NC}  Resumen del directorio actual"
    linea "    ${VerdeClaro}[6]${NC}  Archivos grandes recientes (tamaño+fecha)"
    linea ""
    echo -e "${Morado}┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫${NC}"
    linea " ${RojoClaro}${Negrita}[7]${NC} 🚪 Salir" 1
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
    echo -ne "${Cian}${Negrita}➤ Selecciona una opción [1-7]: ${NC}"
    read opcion
    if ! [[ "$opcion" =~ ^[0-9]+$ ]] || [ "$opcion" -lt 1 ] || [ "$opcion" -gt 7 ]; then
        echo -e "${Rojo}❌ Opción inválida. Por favor, introduce un número entre 1 y 7.${NC}"
        sleep 2
        return 1
    fi
    return 0
}

function solicitar_directorio {
    echo -ne "${Verde}📁 Directorio a analizar (Enter para actual: $PWD): ${NC}"
    read directorio
    if [ -z "$directorio" ]; then
        directorio="$PWD"
    fi

    # Verificar que el directorio existe y es accesible
    if [ ! -d "$directorio" ]; then
        echo -e "${Rojo}❌ El directorio '$directorio' no existe.${NC}"
        return 1
    fi

    if [ ! -r "$directorio" ]; then
        echo -e "${Rojo}❌ No tienes permisos de lectura en '$directorio'.${NC}"
        return 1
    fi

    return 0
}

function solicitar_numero_resultados {
    echo -ne "${Verde}🔢 Número de resultados a mostrar (Enter para 10): ${NC}"
    read num_resultados
    if [ -z "$num_resultados" ]; then
        num_resultados=10
    fi

    if ! [[ "$num_resultados" =~ ^[0-9]+$ ]] || [ "$num_resultados" -lt 1 ]; then
        echo -e "${Rojo}❌ Número inválido. Usando 10 por defecto.${NC}"
        num_resultados=10
    fi
}

# ================
# FUNCIONES DE ANÁLISIS
# ================

function analizar_directorios_por_tamano {
    mostrar_encabezado_seccion "DIRECTORIOS POR TAMAÑO" "${Verde}"

    if ! solicitar_directorio; then
        return 1
    fi
    solicitar_numero_resultados

    echo "📊 Analizando directorios en: $directorio"
    echo "🔍 Mostrando los $num_resultados directorios más grandes..."
    echo ""

    # Contar subdirectorios antes de mostrar
    local total_subdirs=$(find "$directorio" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
    if [ "$total_subdirs" -eq 0 ]; then
        echo -e "${Amarillo}⚠️  No se encontraron subdirectorios en el directorio especificado.${NC}"
        echo ""
        echo -e "${Verde}📈 Estadísticas:${NC}"
        echo "Total de subdirectorios encontrados: $total_subdirs"

        # Mostrar archivos si no hay subdirectorios
        local total_archivos=$(find "$directorio" -maxdepth 1 -type f 2>/dev/null | wc -l)
        if [ "$total_archivos" -gt 0 ]; then
            echo "Archivos en este directorio: $total_archivos"
            echo ""
            echo -e "${CianClaro}💡 Para analizar archivos, usa la opción 2 del menú.${NC}"
        fi
        return
    fi

    # Comando corregido: solo subdirectorios, excluyendo el directorio padre
    local cmd="find \"$directorio\" -mindepth 1 -maxdepth 1 -type d -exec du -sh {} + 2>/dev/null | sort -hr"

    echo -e "${Amarillo}${Negrita}TAMAÑO    DIRECTORIO${NC}"
    echo -e "${GrisClaro}────────  ──────────────────────────────────────────────────${NC}"

    mostrar_con_paginador "$cmd" "$num_resultados"

    echo ""
    echo -e "${Verde}📈 Estadísticas:${NC}"
    echo "Total de subdirectorios encontrados: $total_subdirs"

    if command -v du &>/dev/null; then
        local tamano_total=$(du -sh "$directorio" 2>/dev/null | cut -f1)
        echo "Tamaño total del directorio padre: $tamano_total"
    fi
}

function analizar_archivos_por_tamano {
    mostrar_encabezado_seccion "ARCHIVOS POR TAMAÑO" "${Verde}"

    if ! solicitar_directorio; then
        return 1
    fi
    solicitar_numero_resultados

    echo "📊 Analizando archivos en: $directorio"
    echo "🔍 Mostrando los $num_resultados archivos más grandes..."
    echo ""

    # Buscar archivos recursivamente y ordenar por tamaño
    local cmd="find \"$directorio\" -type f -exec du -h {} + 2>/dev/null | sort -hr | awk '{print \$1, \$2}'"

    echo -e "${Amarillo}${Negrita}TAMAÑO    ARCHIVO${NC}"
    echo -e "${GrisClaro}────────  ──────────────────────────────────────────────────${NC}"

    # Verificar si hay archivos antes de mostrar
    local total_archivos=$(find "$directorio" -type f 2>/dev/null | wc -l)
    if [ "$total_archivos" -eq 0 ]; then
        echo -e "${Amarillo}⚠️  No se encontraron archivos en el directorio especificado.${NC}"
    else
        mostrar_con_paginador "$cmd" "$num_resultados"
    fi

    echo ""
    echo -e "${Verde}📈 Estadísticas:${NC}"
    echo "Total de archivos encontrados: $total_archivos"

    # Mostrar subdirectorios si no hay archivos en el nivel actual
    if [ "$total_archivos" -eq 0 ]; then
        local total_subdirs=$(find "$directorio" -mindepth 1 -type d 2>/dev/null | wc -l)
        echo "Subdirectorios encontrados: $total_subdirs"
        if [ "$total_subdirs" -gt 0 ]; then
            echo ""
            echo -e "${CianClaro}💡 Subdirectorios disponibles:${NC}"
            find "$directorio" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | head -5
        fi
    fi
}

function analizar_directorios_por_fecha {
    mostrar_encabezado_seccion "DIRECTORIOS POR FECHA" "${AzulClaro}"

    if ! solicitar_directorio; then
        return 1
    fi
    solicitar_numero_resultados

    echo "📊 Analizando directorios en: $directorio"
    echo "🕒 Mostrando los $num_resultados directorios más recientes..."
    echo ""

    local cmd="find \"$directorio\" -maxdepth 1 -type d -printf '%TY-%Tm-%Td %TH:%TM %p\n' 2>/dev/null | grep -v \"^[0-9-]* [0-9:]* $directorio\$\" | sort -r"

    echo -e "${CianClaro}${Negrita}FECHA      HORA   DIRECTORIO${NC}"
    echo -e "${GrisClaro}──────────  ─────  ──────────────────────────────────────────${NC}"

    local total_dirs=$(find "$directorio" -maxdepth 1 -type d 2>/dev/null | wc -l)
    if [ "$total_dirs" -le 1 ]; then
        echo -e "${Amarillo}⚠️  No se encontraron subdirectorios en el directorio especificado.${NC}"
    else
        mostrar_con_paginador "$cmd" "$num_resultados"
    fi

    echo ""
    echo -e "${AzulClaro}📈 Estadísticas:${NC}"
    echo "Total de directorios encontrados: $((total_dirs - 1))"
}

function analizar_archivos_por_fecha {
    mostrar_encabezado_seccion "ARCHIVOS POR FECHA" "${AzulClaro}"

    if ! solicitar_directorio; then
        return 1
    fi
    solicitar_numero_resultados

    echo "📊 Analizando archivos en: $directorio"
    echo "🕒 Mostrando los $num_resultados archivos más recientes..."
    echo ""

    # Verificar si hay archivos antes de mostrar
    local total_archivos=$(find "$directorio" -type f 2>/dev/null | wc -l)
    if [ "$total_archivos" -eq 0 ]; then
        echo -e "${Amarillo}⚠️  No se encontraron archivos en el directorio especificado.${NC}"
        echo ""
        echo -e "${Verde}📈 Estadísticas:${NC}"
        echo "Total de archivos encontrados: $total_archivos"

        local total_subdirs=$(find "$directorio" -mindepth 1 -type d 2>/dev/null | wc -l)
        echo "Subdirectorios encontrados: $total_subdirs"
        if [ "$total_subdirs" -gt 0 ]; then
            echo ""
            echo -e "${CianClaro}💡 Subdirectorios disponibles:${NC}"
            find "$directorio" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | head -5
        fi
        return
    fi

    # Usar stat y formatear con numfmt si está disponible, sino usar ls -lh
    local cmd="find \"$directorio\" -type f -exec stat --format='%Y %s %n' {} + 2>/dev/null | sort -nr | while read timestamp size path; do
        fecha=\$(date -d @\$timestamp +'%Y-%m-%d %H:%M' 2>/dev/null)
        if command -v numfmt &>/dev/null; then
            tamaño=\$(numfmt --to=iec-i --suffix=B \$size)
        else
            if [ \$size -ge 1073741824 ]; then
                tamaño=\$(awk \"BEGIN{printf \\\"%.1fG\\\", \$size/1073741824}\")
            elif [ \$size -ge 1048576 ]; then
                tamaño=\$(awk \"BEGIN{printf \\\"%.1fM\\\", \$size/1048576}\")
            elif [ \$size -ge 1024 ]; then
                tamaño=\$(awk \"BEGIN{printf \\\"%.1fK\\\", \$size/1024}\")
            else
                tamaño=\${size}B
            fi
        fi
        printf \"%-8s %-16s %s\n\" \"\$tamaño\" \"\$fecha\" \"\$path\"
    done"

    echo -e "${CianClaro}${Negrita}TAMAÑO   FECHA           ARCHIVO${NC}"
    echo -e "${GrisClaro}───────  ───────────────  ────────────────────────────────────${NC}"

    mostrar_con_paginador "$cmd" "$num_resultados"

    echo ""
    echo -e "${AzulClaro}📈 Estadísticas:${NC}"
    echo "Total de archivos encontrados: $total_archivos"
}

function resumen_directorio {
    mostrar_encabezado_seccion "RESUMEN DEL DIRECTORIO" "${VerdeClaro}"

    if ! solicitar_directorio; then
        return 1
    fi

    echo "📊 Generando resumen completo de: $directorio"
    echo ""

    # Estadísticas generales
    echo -e "${VerdeClaro}${Negrita}📈 ESTADÍSTICAS GENERALES:${NC}"
    local total_archivos=$(find "$directorio" -type f 2>/dev/null | wc -l)
    local total_dirs=$(find "$directorio" -type d 2>/dev/null | wc -l)
    local tamano_total=$(du -sh "$directorio" 2>/dev/null | cut -f1)

    echo "Archivos: $total_archivos"
    echo "Directorios: $total_dirs"
    echo "Tamaño total: $tamano_total"
    echo ""

    # Top 5 directorios más grandes
    echo -e "${Amarillo}${Negrita}📁 TOP 5 DIRECTORIOS MÁS GRANDES:${NC}"
    find "$directorio" -maxdepth 1 -type d -exec du -sh {} + 2>/dev/null | sort -hr | head -6 | tail -5
    echo ""

    # Top 5 archivos más grandes (solo si hay archivos)
    if [ "$total_archivos" -gt 0 ]; then
        echo -e "${Amarillo}${Negrita}📄 TOP 5 ARCHIVOS MÁS GRANDES:${NC}"
        find "$directorio" -type f -exec du -h {} + 2>/dev/null | sort -hr | head -5 | awk '{print $1, $2}'
        echo ""

        # Archivos más recientes
        echo -e "${CianClaro}${Negrita}🕒 TOP 5 ARCHIVOS MÁS RECIENTES:${NC}"
        find "$directorio" -type f -exec stat --format='%Y %n' {} + 2>/dev/null | sort -nr | head -5 | while read timestamp path; do
            fecha=$(date -d @$timestamp +'%Y-%m-%d %H:%M' 2>/dev/null)
            printf "%-16s %s\n" "$fecha" "$path"
        done
    else
        echo -e "${Amarillo}⚠️  No hay archivos regulares en este directorio.${NC}"
        echo ""
        echo -e "${CianClaro}${Negrita}📂 SUBDIRECTORIOS DISPONIBLES:${NC}"
        find "$directorio" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | head -10
    fi
}

function archivos_grandes_recientes {
    mostrar_encabezado_seccion "ARCHIVOS GRANDES Y RECIENTES" "${VerdeClaro}"

    if ! solicitar_directorio; then
        return 1
    fi
    solicitar_numero_resultados

    echo "📊 Buscando archivos grandes y recientes en: $directorio"
    echo "🔍 Criterio: Archivos modificados en los últimos 30 días"
    echo ""

    # Verificar si hay archivos recientes
    local archivos_recientes=$(find "$directorio" -type f -mtime -30 2>/dev/null | wc -l)
    if [ "$archivos_recientes" -eq 0 ]; then
        echo -e "${Amarillo}⚠️  No se encontraron archivos modificados en los últimos 30 días.${NC}"
        echo ""
        echo -e "${VerdeClaro}📈 Estadísticas:${NC}"
        echo "Archivos modificados en los últimos 30 días: $archivos_recientes"
        return
    fi

    # Buscar archivos modificados en los últimos 30 días y ordenar por tamaño
    local cmd="find \"$directorio\" -type f -mtime -30 -exec stat --format='%Y %s %n' {} + 2>/dev/null | sort -k2 -nr | while read timestamp size path; do
        fecha=\$(date -d @\$timestamp +'%Y-%m-%d %H:%M' 2>/dev/null)
        if command -v numfmt &>/dev/null; then
            tamaño=\$(numfmt --to=iec-i --suffix=B \$size)
        else
            if [ \$size -ge 1073741824 ]; then
                tamaño=\$(awk \"BEGIN{printf \\\"%.1fG\\\", \$size/1073741824}\")
            elif [ \$size -ge 1048576 ]; then
                tamaño=\$(awk \"BEGIN{printf \\\"%.1fM\\\", \$size/1048576}\")
            elif [ \$size -ge 1024 ]; then
                tamaño=\$(awk \"BEGIN{printf \\\"%.1fK\\\", \$size/1024}\")
            else
                tamaño=\${size}B
            fi
        fi
        printf \"%-8s %-16s %s\n\" \"\$tamaño\" \"\$fecha\" \"\$path\"
    done"

    echo -e "${VerdeClaro}${Negrita}TAMAÑO   FECHA           ARCHIVO${NC}"
    echo -e "${GrisClaro}───────  ───────────────  ────────────────────────────────────${NC}"

    mostrar_con_paginador "$cmd" "$num_resultados"

    echo ""
    echo -e "${VerdeClaro}📈 Estadísticas:${NC}"
    echo "Archivos modificados en los últimos 30 días: $archivos_recientes"
}

function evaluar_opcion {
    case $opcion in
        1)  analizar_directorios_por_tamano ;;
        2)  analizar_archivos_por_tamano    ;;
        3)  analizar_directorios_por_fecha  ;;
        4)  analizar_archivos_por_fecha     ;;
        5)  resumen_directorio              ;;
        6)  archivos_grandes_recientes      ;;
        7)
            echo ""
            echo -e "${Verde}${Negrita}👋 ¡Gracias por usar el analizador de directorios!${NC}"
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
        echo -e "${Verde}Iniciando analizador de directorios y archivos...${NC}"
        sleep 1
    fi
    while true; do
        mostrar_menu
        while ! leer_opcion; do
            mostrar_menu
        done
        evaluar_opcion
        if [ "$opcion" != "7" ]; then
            pausa
        fi
    done
}

main
