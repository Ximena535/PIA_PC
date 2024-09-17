<#
.SYNOPSIS
Revisión de hashes de archivos y consulta de la API de VirusTotal usando los hashes de los archivos locales

.PARAMETER FilePath
Es donde se almacena la ruta de acceso a la carpeta

#>

# Definición de funciones
function Get-VirusTotalReport {
    param (
        [Parameter(Mandatory=$true)]
        [String]$FilePath
    )
    try {
        if (-Not (Test-Path -Path $FilePath)) {
            throw "El archivo no existe en la ruta especificada."
        }
        $fileHash = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash
        $headers = @{
            'x-apikey' = "05a41458770464ac34cf17e2de4b6ed2db122847e7dbc25a98b68ee84bf0b4b2"
        }
        $response = Invoke-RestMethod -Uri "https://www.virustotal.com/api/v3/files/$fileHash" -Method Get -Headers $headers
        $response.data.attributes.last_analysis_stats
    } catch {
        Write-Error "Error al obtener el reporte hash de VirusTotal: $_"
    }
}