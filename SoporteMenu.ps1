# 1. PERMISOS DE ADMINISTRADOR
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Clear-Host
    Write-Host "==========================================================" -ForegroundColor Red
    Write-Host "  [¡ERROR!] SE REQUIEREN PERMISOS DE ADMINISTRADOR       " -ForegroundColor Red
    Write-Host "==========================================================" -ForegroundColor Red
    Exit
}

$RutaDestino = "C:\SoporteTI"
if (-not (Test-Path $RutaDestino)) { New-Item -ItemType Directory -Path $RutaDestino | Out-Null }
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# BASE DE DATOS DE TUS HERRAMIENTAS REALES (ESTILO HIREN'S PÚBLICO)
$Repo = @{
    "DRIVERS" = @{
        "1" = @{ Nombre = "Driver de Red Universal"; Url = "https://tu-nube.com"; Tipo = "Instalable"; Args = "/S" }
    }
    "UTILERIAS" = @{
        "1" = @{ Nombre = "AnyDesk Técnico Portable"; Url = "https://anydesk.com"; Tipo = "Portable"; Args = "" }
    }
    "OTROS" = @{
        "1" = @{ Nombre = "Win11Debloat (Optimizar RAM)"; Url = "https://githubusercontent.com"; Tipo = "Memoria"; Args = "" }
    }
}

function Ejecutar-Herramientas {
    param ($Categoria, $SubOpcion)
    $Tool = $Repo[$Categoria][$SubOpcion]
    $NombreArchivo = $Tool.Url -split '/' | Select-Object -Last 1
    $ArchivoLocal = Join-Path $RutaDestino $NombreArchivo
    
    Clear-Host
    Write-Host ">>> Procesando: $($Tool.Nombre)" -ForegroundColor Cyan
    
    try {
        if ($Tool.Tipo -eq "Memoria") {
            Write-Host "Ejecutando script directo en la memoria RAM..." -ForegroundColor Yellow
            $ScriptPuro = Invoke-RestMethod -Uri $Tool.Url -UseBasicParsing
            & ([scriptblock]::Create($ScriptPuro))
        } else {
            Write-Host "Descargando de forma segura desde el servidor oficial..." -ForegroundColor Yellow
            Invoke-WebRequest -Uri $Tool.Url -OutFile $ArchivoLocal -UseBasicParsing
            Write-Host "[✓] Descargado con éxito en: $ArchivoLocal" -ForegroundColor Green
            Start-Process $ArchivoLocal
        }
    } catch { 
        Write-Warning "Error al procesar: $_." 
    }
    Read-Host "`nPresiona Enter para volver"
}

while ($true) {
    Clear-Host
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host "          TOOLBOX TI - MENU PRINCIPAL             " -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host " [1] DRIVERS"
    Write-Host " [2] UTILERIAS"
    Write-Host " [3] OTROS"
    Write-Host " [X] Salir"
    Write-Host "==================================================" -ForegroundColor Green
    $Opcion = Read-Host "Selecciona una categoría"
    $CatSeleccionada = switch ($Opcion) { "1" {"DRIVERS"}; "2" {"UTILERIAS"}; "3" {"OTROS"}; "X" {break}; "x" {break}; default {continue} }
    while ($true) {
        Clear-Host
        Write-Host "==================================================" -ForegroundColor Cyan
        Write-Host "         CATEGORIA: $CatSeleccionada              " -ForegroundColor Cyan
        $Items = $Repo[$CatSeleccionada]
        $Items.Keys | Sort-Object | ForEach-Object { Write-Host "[$_] $($Items[$_].Nombre)" }
        Write-Host "[R] Regresar"
        $SubOpcion = Read-Host "Selecciona la herramienta"
        if ($SubOpcion -eq "R" -or $SubOpcion -eq "r") { break }
        if ($Items.ContainsKey($SubOpcion)) { Ejecutar-Herramientas -Categoria $CatSeleccionada -SubOpcion $SubOpcion }
    }
}
