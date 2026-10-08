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

# === TU CONFIGURACIÓN DE SEGURIDAD ===
$Token = "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"
$HeadersGitHub = @{ Authorization = "token $Token" }

# 3. BASE DE DATOS DE TUS HERRAMIENTAS REALES
$Repo = @{
    "DRIVERS" = @{
        "1" = @{ Nombre = "Driver de Red Universal"; Url = "https://tu-nube.com"; Tipo = "Instalable"; Args = "/S" }
        "2" = @{ Nombre = "Driver Chipset Intel";    Url = "https://tu-nube.com"; Tipo = "Instalable"; Args = "-silent" }
    }
    "UTILERIAS" = @{
        "1" = @{ Nombre = "AnyDesk Técnico Real";    Url = "https://raw.githubusercontent.com/tecnys/ToolBox-TI/main/AnyDesk.exe"; Tipo = "Portable"; Args = "" }
        "2" = @{ Nombre = "CrystalDiskInfo (Disco)"; Url = "https://tu-nube.com"; Tipo = "Portable"; Args = "" }
        "3" = @{ Nombre = "7-Zip Extractor";         Url = "https://tu-nube.com"; Tipo = "Instalable"; Args = "/S" }
    }
    "ANTIVIRUS" = @{
        "1" = @{ Nombre = "Kaspersky Removal Tool";  Url = "https://tu-nube.com"; Tipo = "Portable"; Args = "" }
        "2" = @{ Nombre = "Malwarebytes AdwCleaner"; Url = "https://tu-nube.com"; Tipo = "Portable"; Args = "" }
    }
    "SAQMED" = @{
        "1" = @{ Nombre = "Programa Interno SAQMED"; Url = "https://tu-nube.com"; Tipo = "Instalable"; Args = "/silent" }
        "2" = @{ Nombre = "Base de Datos SAQMED";    Url = "https://tu-nube.com"; Tipo = "Portable"; Args = "" }
    }
    "OTROS" = @{
        "1" = @{ Nombre = "Navegador Google Chrome"; Url = "https://tu-nube.com"; Tipo = "Instalable"; Args = "/qn /norestart" }
        "2" = @{ Nombre = "Limpiador Temporal Windows"; Url = "https://tu-nube.com"; Tipo = "Script"; Args = "" }
    }
}

function Ejecutar-Herramientas {
    param ($Categoria, $SubOpcion)
    $Tool = $Repo[$Categoria][$SubOpcion]
    $NombreArchivo = $Tool.Url -split '/' | Select-Object -Last 1
    $ArchivoLocal = Join-Path $RutaDestino $NombreArchivo
    
    Clear-Host
    Write-Host ">>> Procesando: $($Tool.Nombre)" -ForegroundColor Cyan
    Write-Host "Descargando de forma segura desde tu GitHub..." -ForegroundColor Yellow
    
    try {
        Invoke-WebRequest -Uri $Tool.Url -OutFile $ArchivoLocal -Headers $HeadersGitHub -UseBasicParsing
        Write-Host "[✓] Descargado con éxito en: $ArchivoLocal" -ForegroundColor Green
        
        if ($Tool.Tipo -eq "Portable") { 
            Write-Host "Iniciando herramienta..." -ForegroundColor Green
            Start-Process $ArchivoLocal 
        } 
        elseif ($Tool.Tipo -eq "Instalable") { 
            Write-Host "Instalando en segundo plano..." -ForegroundColor Green
            Start-Process $ArchivoLocal -ArgumentList $Tool.Args -Wait 
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
    Write-Host "[1] DRIVERS"
    Write-Host "[2] UTILERIAS"
    Write-Host "[3] ANTIVIRUS"
    Write-Host "[4] SAQMED"
    Write-Host "[5] OTROS"
    Write-Host "[X] Salir"
    Write-Host "==================================================" -ForegroundColor Green
    $Opcion = Read-Host "Selecciona una categoría"
    $CatSeleccionada = switch ($Opcion) { "1" {"DRIVERS"}; "2" {"UTILERIAS"}; "3" {"ANTIVIRUS"}; "4" {"SAQMED"}; "5" {"OTROS"}; "X" {break}; "x" {break}; default {continue} }
    while ($true) {
        Clear-Host
        Write-Host "==================================================" -ForegroundColor Cyan
        Write-Host "         CATEGORIA: $CatSeleccionada              " -ForegroundColor Cyan
        $Items = $Repo[$CatSeleccionada]
        $Items.Keys | Sort-Object | ForEach-Object { Write-Host "[$_] $($Items[$_].Nombre) ($($Items[$_].Tipo))" }
        Write-Host "[R] Regresar"
        $SubOpcion = Read-Host "Selecciona la herramienta"
        if ($SubOpcion -eq "R" -or $SubOpcion -eq "r") { break }
        if ($Items.ContainsKey($SubOpcion)) { Ejecutar-Herramientas -Categoria $CatSeleccionada -SubOpcion $SubOpcion }
    }
}

