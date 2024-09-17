#USO DEL SISTEMA

<#
.SYNOPSIS
Verifica el uso actual del CPU y lo compara con un umbral proporcionado.

.DESCRIPTION
La función `cpu_usage` obtiene el porcentaje de uso del CPU y lo muestra en pantalla. Si el uso del CPU supera el umbral proporcionado, se genera una alerta en rojo.

.PARAMETER CPU_THRESHOLD
El umbral de uso de CPU que se utiliza para activar la alerta. El valor predeterminado es 80%.

.EXAMPLE
cpu_usage -CPU_THRESHOLD 85
Verifica el uso del CPU y alerta si es superior al 85%.

.EXAMPLE
cpu_usage
Verifica el uso del CPU y alerta si es superior al 80%, que es el valor predeterminado.

#>

# Verificamos el uso del CPU
function cpu_usage {
    param (
        [int]$CPU_THRESHOLD = 80
    )
    # Obtenemos el uso del CPU usando Win32_Processor
    $cpuLoad = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty LoadPercentage
    $cpuUsage = [math]::Round([double]$cpuLoad, 2)
    
    Write-Host "Uso del CPU: $cpuUsage%"
    
    if ($cpuUsage -gt $CPU_THRESHOLD) {
        Write-Host "ALERTA: El uso del CPU está por encima del $CPU_THRESHOLD%" -ForegroundColor Red
    }
}

<#
.SYNOPSIS
Verifica el uso actual de la memoria y lo compara con un umbral proporcionado.

.DESCRIPTION
La función `memory_usage` calcula el porcentaje de memoria física en uso y lo muestra en pantalla. Si el uso de la memoria supera el umbral proporcionado, se genera una alerta en rojo.

.PARAMETER MEMORY_THRESHOLD
El umbral de uso de memoria que se utiliza para activar la alerta. El valor predeterminado es 80%.

.EXAMPLE
memory_usage -MEMORY_THRESHOLD 75
Verifica el uso de la memoria y alerta si es superior al 75%.

.EXAMPLE
memory_usage
Verifica el uso de la memoria y alerta si es superior al 80%, que es el valor predeterminado.

#>

# Verificamos el uso de la memoria
function memory_usage {
    param (
        [int]$MEMORY_THRESHOLD = 80
    )
    $memInfo = Get-WmiObject Win32_OperatingSystem
    $totalMem = $memInfo.TotalVisibleMemorySize
    $freeMem = $memInfo.FreePhysicalMemory
    $usedMem = (($totalMem - $freeMem) / $totalMem) * 100
    $usedMem = [math]::Round($usedMem, 2)
    Write-Host "Uso de la memoria: $usedMem%"
    if ($usedMem -gt $MEMORY_THRESHOLD) {
        Write-Host "ALERTA: El uso de la memoria está por encima del $MEMORY_THRESHOLD%" -ForegroundColor Red
    }
}


<#
.SYNOPSIS
Verifica el uso actual del disco y lo compara con un umbral proporcionado.

.DESCRIPTION
La función `disk_usage` calcula el porcentaje de espacio en disco usado y lo muestra en pantalla. Si el uso del disco supera el umbral proporcionado, se genera una alerta en rojo.

.PARAMETER DISK_THRESHOLD
El umbral de uso de disco que se utiliza para activar la alerta. El valor predeterminado es 80%.

.EXAMPLE
disk_usage -DISK_THRESHOLD 90
Verifica el uso del disco y alerta si es superior al 90%.

.EXAMPLE
disk_usage
Verifica el uso del disco y alerta si es superior al 80%, que es el valor predeterminado.

#>

# Verificamos el uso del disco
function disk_usage {
    param (
        [int]$DISK_THRESHOLD = 80
    )
    $disk = Get-PSDrive -Name C
    $usedDisk = ($disk.Used / ($disk.Used + $disk.Free)) * 100
    $usedDisk = [math]::Round($usedDisk, 2)
    Write-Host "Uso del disco: $usedDisk%"
    if ($usedDisk -gt $DISK_THRESHOLD) {
        Write-Host "ALERTA: El uso del disco está por encima del $DISK_THRESHOLD%" -ForegroundColor Red
    }
}

<#
.SYNOPSIS
Verifica el uso actual de la red y lo compara con un umbral proporcionado.

.DESCRIPTION
La función `network_usage` obtiene el uso de la red en KB/s y lo muestra en pantalla. Si el uso de la red supera el umbral proporcionado, se genera una alerta en rojo.

.PARAMETER NETWORK_THRESHOLD
El umbral de uso de red (en KB/s) que se utiliza para activar la alerta. El valor predeterminado es 1000 KB/s.

.EXAMPLE
network_usage -NETWORK_THRESHOLD 1500
Verifica el uso de la red y alerta si es superior a 1500 KB/s.

.EXAMPLE
network_usage
Verifica el uso de la red y alerta si es superior a 1000 KB/s, que es el valor predeterminado.

#>

# Verificamos el uso de la red

function network_usage {
    param (
        [int]$NETWORK_THRESHOLD = 1000 # En KB/s
    )
    $netStats = Get-NetAdapterStatistics
    # Alternativa a Measure-Object: usamos ForEach-Object para sumar manualmente los bytes recibidos
    $receivedBytes = 0
    $netStats | ForEach-Object { $receivedBytes += $_.ReceivedBytesPersec }
    
    $netUsageKB = [math]::Round($receivedBytes / 1KB, 2)
    
    Write-Host "Uso de la red: $netUsageKB KB/s"
    
    if ($netUsageKB -gt $NETWORK_THRESHOLD) {
        Write-Host "ALERTA: El uso de la red está por encima del $NETWORK_THRESHOLD KB/s" -ForegroundColor Red
    }
}