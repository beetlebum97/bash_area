# 🖥️ 1. INFO SISTEMA 
Script interactivo para obtener información detallada de sistemas Linux.  

[![Script Preview](https://github.com/beetlebum97/bash_area/blob/main/menu.png)]()

## 🔍 Funcionalidades  
- Menú interactivo con opciones numeradas.  
- Información categorizada por color:  
  - 🟡 **Sistema (1-9):** Hostname, versión kernel, usuarios activos, etc.  
  - 🔵 **Hardware (10-17):** BIOS, placa base, CPU, memorias USB.  
  - 🟢 **Red (18-21):** Interfaces de red, conexiones activas.  
  - 🔴 **Salir (22):** Cierra el script.  

## ⚙️ Requisitos  
- **Sistemas basados en Linux** (probado en Debian 12).  
- Paquete `usbutils` instalado para opción 17:  
  ```bash 
  sudo apt-get install usbutils
  ```
  
---

# 🖥️ 2. CONF SISTEMA 
Script interactivo para obtener la configuración de sistemas Linux.  
[![Script Preview](https://github.com/beetlebum97/bash_area/blob/main/menu_conf.png)]()

## 🔍 Funcionalidades  
- Menú interactivo con opciones numeradas.  
- Información categorizada por color:  
  - 🟡 **Programas (1-3):** Paquetes, binarios.  
  - 🔵 **Servicios y procesos (4-8):** Servicios, procesos, conexiones.  
  - 🟢 **Usuarios y grupos (9-12):** Usuarios, grupos, shells, logins.
  - 🟠 **Configuración avanzada (13-16):** Variables, tareas, kernel.
  - 🔴 **Salir (18):** Cierra el script.  
