# Función para verificar el uso del CPU
function cpu_usage {
    param (
        [int]$CPU_THRESHOLD = 80
    )
    $cpuLoad = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty LoadPercentage
    $cpuUsage = [math]::Round([double]$cpuLoad, 2)
    
    Write-Host "Uso del CPU: $cpuUsage%"
    
    if ($cpuUsage -gt $CPU_THRESHOLD) {
        Write-Host "ALERTA: El uso del CPU está por encima del $CPU_THRESHOLD%" -ForegroundColor Red
    }
}

# Función para verificar el uso de la memoria
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

# Función para verificar el uso del disco
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

# Función para verificar el uso de la red
function network_usage {
    param (
        [int]$NETWORK_THRESHOLD = 1000 # En KB/s
    )
    $netStats = Get-NetAdapterStatistics
    $receivedBytes = 0
    $netStats | ForEach-Object { $receivedBytes += $_.ReceivedBytesPersec }
    
    $netUsageKB = [math]::Round($receivedBytes / 1KB, 2)
    
    Write-Host "Uso de la red: $netUsageKB KB/s"
    
    if ($netUsageKB -gt $NETWORK_THRESHOLD) {
        Write-Host "ALERTA: El uso de la red está por encima del $NETWORK_THRESHOLD KB/s" -ForegroundColor Red
    }
}

# Función principal para verificar el uso del sistema
function Check_System_Usage {
    param (
        [int]$CPU_THRESHOLD = 80,
        [int]$MEMORY_THRESHOLD = 80,
        [int]$DISK_THRESHOLD = 80,
        [int]$NETWORK_THRESHOLD = 1000
    )

    Write-Host "Verificando el uso del sistema..." -ForegroundColor Cyan
    
    # Llamada a las funciones de verificación individuales
    cpu_usage -CPU_THRESHOLD $CPU_THRESHOLD
    memory_usage -MEMORY_THRESHOLD $MEMORY_THRESHOLD
    disk_usage -DISK_THRESHOLD $DISK_THRESHOLD
    network_usage -NETWORK_THRESHOLD $NETWORK_THRESHOLD
}
