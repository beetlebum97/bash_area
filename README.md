# 🖥️ 1. SISTEMA-INFO.SH
Script interactivo para obtener información detallada de sistemas Linux.  

[![Script Preview](https://raw.githubusercontent.com/beetlebum97/bash_area/main/screenshots/sistema-info.png)]()

## 🔍 Funcionalidades  
- Menú interactivo con opciones numeradas.  
- Información categorizada por color:  
  - 🟡 **Sistema (1-9):** Hostname, versión kernel, usuarios activos, etc.  
  - 🔵 **Hardware (10-17):** BIOS, placa base, CPU, memorias USB.  
  - 🟢 **Red (18-21):** Interfaces de red, conexiones activas.
  - 🔴 **Guardar informe completo en archivo. (22):** Resultados de todas las opciones.    
  - 🔴 **Salir (23):** Cierra el script.  

## ⚙️ Requisitos  
- **Sistemas basados en Linux** (probado en Debian 12).  
- Paquete `usbutils` instalado para opción 17:  
  ```bash 
  sudo apt-get install usbutils
  ```
  
---

# 🖥️ 2. SISTEMA-CONF.SH
Script interactivo para obtener la configuración de sistemas Linux.  

[![Script Preview](https://raw.githubusercontent.com/beetlebum97/bash_area/main/screenshots/sistema-conf.png)]()

## 🔍 Funcionalidades  
- Menú interactivo con opciones numeradas.  
- Información categorizada por color:  
  - 🟡 **Programas (1-3):** Paquetes, binarios.  
  - 🔵 **Servicios y procesos (4-8):** Servicios, procesos, conexiones.  
  - 🟢 **Usuarios y grupos (9-12):** Usuarios, grupos, shells, logins.
  - 🟠 **Configuración avanzada (13-16):** Variables, tareas, kernel.
  - 🔴 **Guardar informe completo en archivo. (17):** Resultados de todas las opciones.    
  - 🔴 **Salir (18):** Cierra el script.
 
 ---

 # 🖥️ 3. ARCHIVOS.SH
Script interactivo para obtener listados de archivos y directorios por tamaño y fecha. 
 
[![Script Preview](https://raw.githubusercontent.com/beetlebum97/bash_area/main/screenshots/archivos.png)]()

## 🔍 Funcionalidades  
- Menú interactivo con opciones numeradas.  
- Información categorizada por color:  
  - 🟡 **Análisis por tamaño (1-2):** De mayor a menor.  
  - 🔵 **Análisis por fecha (3-4):**  De más reciente a más antiguo.
  - 🟢 **Análisis combinado (5-6)** 
  - 🔴 **Salir (7):** Cierra el script.
