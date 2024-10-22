# Get the path of the current directory of the script
$modulePath = $PSScriptRoot
# Import the modules by specifying the full path
Import-Module "$modulePath\MODULE_1\MODULE_1.psm1"
Import-Module "$modulePath\MODULE_2\MODULE_2.psm1"
Import-Module "$modulePath\MODULE_3\MODULE_3.psm1"

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# MENU
<#
.SYNOPSIS
Muestra el menú de opciones para ejecutar diversas tareas de ciberseguridad.

.DESCRIPTION
La función Get-Menu despliega en pantalla un menú con varias opciones que permiten realizar tareas como la revisión de hashes de archivos,
la consulta a la API de VirusTotal, el listado de archivos ocultos y la revisión de uso de recursos del sistema.

.EXAMPLE
Get-Menu
Muestra el menú con las opciones disponibles.
#>
function Get-Menu {
    clear
    Write-Host "*** MENU ***" -ForegroundColor Green
    Write-Host "1. Revisión de hashes de archivos y consulta a la API de VirusTotal"
    Write-Host "2. Listado de archivos ocultos en una carpeta"
    Write-Host "3. Revisión de uso de recursos del sistema"
    Write-Host "4. Salir"
}

<#
.SYNOPSIS
Gestiona la lógica del menú y permite seleccionar una opción.

.DESCRIPTION
La función Use-Menu despliega el menú y gestiona la ejecución de las funciones correspondientes según la opción seleccionada por el usuario.

.EXAMPLE
Use-Menu
Permite seleccionar y ejecutar las tareas disponibles en el menú.
#>
function Use-Menu {
    do {
        try {
            $opcion = 0
            Get-Menu
            $opcion = [int](Read-Host "Seleccione una opción")
            
            switch ($opcion) {
                1 {
                    Write-Host "Revisión de hashes de archivos y consulta a la API de VirusTotal."
                    Get-VirusTotalReport
                }
                2 {
                    Write-Host "Listado de archivos ocultos en una carpeta."
                    $path = Read-Host "Ingrese la ruta que desee ver los archivos ocultos"
                    Get-HiddenFiles -path $path
                }
                3 {
                    Write-Host "Revisión de uso de recursos del sistema."
                    Check_System_Usage
                }
                4 {
                    Write-Host "Saliendo..."
                    break
                }
                default {
                    Write-Host "Opción inválida, seleccione una opción válida." -ForegroundColor Red
                }
            }
        } catch {
            Write-Host "Opción inválida, ingresa un número entero válido." -ForegroundColor Red
        }
        pause
    } while ($opcion -ne 4)
}

Use-Menu
