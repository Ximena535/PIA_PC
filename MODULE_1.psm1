function Get-VirusTotalReport {
    param (
        [Parameter(Mandatory=$true)]
        [String]$FilePath
    )
    try {
        if (-Not (Test-Path -Path $FilePath)) {
            throw "El archivo no existe en la ruta especificada."
        }

        # Solicitar la API Key al usuario
        $apiKey = Read-Host "Por favor, ingrese su API Key de VirusTotal"

        if (-not $apiKey) {
            throw "No se ingresó una API Key."
        }

        $fileHash = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash
        $headers = @{
            'x-apikey' = $apiKey
        }
        $response = Invoke-RestMethod -Uri "https://www.virustotal.com/api/v3/files/$fileHash" -Method Get -Headers $headers
        
        if ($response -and $response.data -and $response.data.attributes -and $response.data.attributes.last_analysis_stats) {
            return $response.data.attributes.last_analysis_stats
        } else {
            throw "No se encontró el reporte en VirusTotal o la estructura de la respuesta es diferente."
        }
    } catch {
        Write-Error "Error al obtener el reporte hash de VirusTotal: $_"
    }
}
