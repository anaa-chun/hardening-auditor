# Estructura del Proyecto
```HARDENING-AUDITOR/
│
├── hardening-auditor.sh # Script principal de auditoría
├── README.md  # Documentación del proyecto
├── requirements.txt   # Dependencias (librería estándar)
│
├── config/
│   └── controls.json  # Definición de los 14 controles de seguridad
│
├── images/
│   ├── 1 crear proyectos.png
│   ├── 2 nano config controls json.png
│   ├── 3 cat config controls json.png
│   ├── 4 nano hardening auditor.png
│   ├── 5 cat hardening auditor.png
│   ├── 6 sudo shell hardening auditor.png
│   ├── 7 ls-la reports.png
│   └── 8 cat reports audit txt head -20.png
│
└── reports/
    ├── audit_kali-linux_20260317_171918.json
    ├── audit_kali-linux_20260317_171918.txt
    ├── audit_kali-linux_20260319_183553.json
    ├── audit_kali-linux_20260319_183553.txt
hardening-auditor.sh
README.md
requirements.txt 
```
<br>

# Hardening Auditor 
Es una herramienta de línea de comandos que evalúa automáticamente el nivel de hardening en sistemas Linux mediante más de 30 comprobaciones de seguridad organizadas por categorías. Genera reportes detallados con recomendaciones de solución para cada control fallido, es ideal para administradores de sistemas y auditores de seguridad.

##  Descripción Técnica

Hardening Auditor es un script en Shell que automatiza la verificación de controles de seguridad en sistemas Linux. Realiza comprobaciones en cinco áreas críticas:

- **SSH Hardening**: Configuración segura del servicio SSH
- **Permisos de archivos**: Verificación de permisos en archivos sensibles
- **Hardening del Kernel**: Parámetros de seguridad del kernel
- **Usuarios y grupos**: Auditoría de configuraciones de usuarios
- **Servicios**: Detección de servicios inseguros

La herramienta genera reportes detallados en formato JSON y TXT con recomendaciones de remediación.

##  Instalación

```bash
# Clonar el repositorio
git clone https://github.com/anaa-chun/hardening-auditor.git
cd hardening-auditor

# No requiere dependencias externas (usa solo la biblioteca estándar de Shell)
# Asegurar permisos de ejecución
chmod +x hardening-auditor.sh
```

## Evidencias

### 1. Creación de la estructura del proyecto
![Crear proyecto](images/1%20crear%20proyectos.png) <br>
Se crea la estructura inicial del proyecto con los directorios config, modules, reports y los archivos base mediante comandos mkdir y touch. Se utiliza tree para verificar la estructura creada..

### 2. Configuración de controles (nano)
![Nano controls](images/2%20nano%20config%20controls%20json.png) <br>
Edición del archivo config/controls.json donde se definen todos los controles de seguridad a auditar. Se establecen 14 controles organizados en 5 categorías: SSH hardening, permisos de archivos, kernel hardening, usuarios y grupos, y servicios inseguros.

### 3. Controles de seguridad (JSON)
![Controls JSON](/images/1%20crear%20proyectos.png) <br>
Visualización del contenido completo del archivo JSON con todos los controles implementados. Cada control incluye ID, descripción, comando de verificación, remediación y nivel de severidad.

### 4. Script principal (nano)
![Nano script](images/2%20nano%20config%20controls%20json.png) <br>
Edición del script principal hardening-auditor.sh donde se implementa la lógica de auditoría. Se desarrolla la clase HardeningAuditor con métodos para cargar controles y ejecutar comprobaciones.

### 5. Código del script
![Script code](images/5%20cat%20hardening%20auditor.png) <br>
Visualización completa del código bash de la herramienta. El script cuenta con más de 150 líneas, incluye colores en terminal para mejor visualización y genera reportes en formato JSON y TXT.

### 6. Ejecución de la auditoría
![Ejecución](images/6%20sudo%20shell%20hardening%20auditor.png) <br>
Ejecución de la herramienta con privilegios de superusuario para auditoría completa del sistema. Se auditan 14 controles obteniendo 8 pasados y 6 fallados, con recomendaciones de remediación para cada fallo.

### 7. Reportes generados
![Reportes](images/7%20ls-la%20reports.png) <br>
Se verifica los reportes generados automáticamente por la herramienta después de la auditoría. Se crean dos archivos con timestamp: uno en formato JSON para procesamiento y otro en TXT para lectura humana..

### 8. Contenido del reporte
![Reporte TXT](images/8%20cat%20reports%20audit%20txt%20head%20-20.png) <br>
Se muestra las primeras líneas del reporte TXT generado. Con esto se ve el hostname, sistema auditado, timestamp, resumen de resultados y los detalles de los primeros controles con sus estados y remediaciones.

## Proof of Concept (PoC)
Vídeo demostrativo del funcionamiento completo de la herramienta Hardening Auditor. <br>
En el vídeo se puede observar:
- Ejecución del script con privilegios de root
- Evaluación automática de controles de seguridad
- Resultados PASS/FAIL en tiempo real
- Generación de reportes en formato JSON y TXT
- Evidencia de funcionamiento en sistema Linux

**Vídeo PoC →** [Hardening Auditor PoC | Auditoría de Seguridad en Linux con Shell](https://www.youtube.com/watch?v=XoqN14f6LH4)