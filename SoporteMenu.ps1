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

# 3. BASE DE DATOS PÚBLICA / HÍBRIDA (INSPIRADA EN HIREN'S BOOT CD)
$Repo = @{
    "DRIVERS" = @{
        "1" = @{ Nombre = "Driver de Red Universal"; Url = "https://tu-nube.com"; Tipo = "Instalable"; Args = "/S" }
        "2" = @{ Nombre = "Driver Chipset Intel";    Url = "https://tu-nube.com"; Tipo = "Instalable"; Args = "-silent" }
    }
    "UTILERIAS" = @{
        # URL Oficial Directa Pública de AnyDesk - Vuela sin restricciones
        "1" = @{ Nombre = "AnyDesk Técnico Portable"; Url = "https://anydesk.com"; Tipo = "Portable"; Args = "" }
        # URL Espejo de Hiren's Boot para CrystalDiskInfo Portable
        "2" = @{ Nombre = "CrystalDiskInfo (Disco)";  Url = "https://hirensbootcd.org"; Tipo = "ZipPortable"; Args = "DiskInfo64.exe" }
        "3" = @{ Nombre = "7-Zip Extractor (Oficial)";Url = "https://7-zip.org"; Tipo = "Instalable"; Args = "/S" }
    }
    "ANTIVIRUS" = @{
        "1" = @{ Nombre = "Kaspersky Removal Tool";  Url = "https://tu-nube.com"; Tipo = "Portable"; Args = "" }
        "2" = @{ Nombre = "Malwarebytes AdwCleaner"; Url = "https://tu-nube.com"; Tipo = "Portable"; Args = "" }
    }
    "SAQMED" = @{
        # Modo Híbrido: Herramientas privadas se ejecutan localmente si traes tu USB o carpeta lista
        "1" = @{ Nombre = "Programa Interno SAQMED"; Url = "Saqmed.exe"; Tipo = "LocalInstalable"; Args = "/silent" }
        "2" = @{ Nombre = "Base de Datos SAQMED";    Url = "BaseSaqmed.exe"; Tipo = "LocalPortable"; Args = "" }
    }
    "OTROS" = @{
        "1" = @{ Nombre = "Navegador Google Chrome"; Url = "https://google.com"; Tipo = "Instalable"; Args = "/qn /norestart" }
        "2" = @{ Nombre = "Limpiador Temporal Windows"; Url = "https://tu-nube.com"; Tipo = "Script"; Args = "" }
        "3" = @{ Nombre = "Win11Debloat (Optimizar Sistema)"; Url = "https://githubusercontent.com"; Tipo = "Memoria"; Args = "" }
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
            Write-Host "Ejecutando script optimizador directo en memoria RAM estilo Raphire..." -ForegroundColor Yellow
            $ScriptPuro = Invoke-RestMethod -Uri $Tool.Url -UseBasicParsing
            & ([scriptblock]::Create($ScriptPuro))
        } 
        elseif ($Tool.Tipo -startswith "Local") {
            # Lógica para tus archivos privados de SAQMED (sin internet)
            $ArchivoPrivado = Join-Path $RutaDestino $Tool.Url
            if (-not (Test-Path $ArchivoPrivado)) {
                Write-Warning "El instalador privado no se encuentra en C:\SoporteTI"
                Write-Host "Por favor coloca el archivo [$($Tool.Url)] en C:\SoporteTI para usar esta opción interna." -ForegroundColor Yellow
            } else {
                Write-Host "Iniciando herramienta interna de la empresa..." -ForegroundColor Green
                if ($Tool.Tipo -eq "LocalPortable") { Start-Process $ArchivoPrivado }
                else { Start-Process $ArchivoPrivado -ArgumentList $Tool.Args -Wait }
            }
        }
        else {
            # Descargas públicas directas ultra rápidas
            Write-Host "Descargando desde el servidor público oficial..." -ForegroundColor Yellow
            Invoke-WebRequest -Uri $Tool.Url -OutFile $ArchivoLocal -UseBasicParsing
            Write-Host "[✓] Descargado con éxito en: $ArchivoLocal" -ForegroundColor Green
            
            if ($Tool.Tipo -eq "Portable") { 
                Write-Host "Iniciando herramienta..." -ForegroundColor Green
                Start-Process $ArchivoLocal 
            } 
            elseif ($Tool.Tipo -eq "Instalable") { 
                Write-Host "Instalando en segundo plano..." -ForegroundColor Green
                Start-Process $ArchivoLocal -ArgumentList $Tool.Args -Wait 
            }
            elseif ($Tool.Tipo -eq "ZipPortable") {
                Write-Host "Extrayendo utilería portable comprimida..." -ForegroundColor Green
                $CarpetaZip = Join-Path $RutaDestino ($NombreArchivo -replace '\.zip$', '')
                Expand-Archive -Path $ArchivoLocal -DestinationPath $CarpetaZip -Force
                $Ejecutable = Join-Path $CarpetaZip $Tool.Args
                Start-Process $Ejecutable
            }
        }
    } catch { 
        Write-Warning "Error al procesar la herramienta: $_." 
    }
    Read-Host "`nPresiona Enter para volver"
}

while ($true) {
    Clear-Host
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host "          TOOLBOX TI - MENU PRINCIPAL             " -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host " DRIVERS"
    Write-Host " UTILERIAS"
    Write-Host " ANTIVIRUS"
    Write-Host " SAQMED"
    Write-Host " OTROS"
    Write-Host " [X] Salir"
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
