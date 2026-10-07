<#
.NOTES
    Nombre: SoporteMenu.ps1
    Objetivo: Tu propio ToolBox de TI automatizado en la nube
#>

# 1. FORZAR EJECUCIÓN COMO ADMINISTRADOR
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"\$PSCommandPath`"" -Verb RunAs
    break
}

# 2. CONFIGURACIÓN DEL ENTORNO LOCAL TEMPORAL
$RutaDestino = "C:\SoporteTI"
if (-not (Test-Path $RutaDestino)) { New-Item -ItemType Directory -Path $RutaDestino | Out-Null }

# Configurar TLS 1.2 para asegurar las descargas desde nubes modernas
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 3. BASE DE DATOS DE TUS HERRAMIENTAS (REEMPLAZA LAS URLS POR TUS ENLACES DIRECTOS DE TU NUBE)
$Repo = @{
    "DRIVERS" = @{
        "1" = @{ Nombre = "Driver de Red Universal"; Url = "https://tu-nube.com"; Tipo = "Instalable"; Args = "/S" }
        "2" = @{ Nombre = "Driver Chipset Intel";    Url = "https://tu-nube.com"; Tipo = "Instalable"; Args = "-silent" }
    }
    "UTILERIAS" = @{
        "1" = @{ Nombre = "AnyDesk Técnico";        Url = "https://tu-nube.com";   Tipo = "Portable"; Args = "" }
        "2" = @{ Nombre = "CrystalDiskInfo (Disco)"; Url = "https://tu-nube.com"; Tipo = "Portable"; Args = "" }
        "3" = @{ Nombre = "7-Zip Extractor";         Url = "https://tu-nube.com";      Tipo = "Instalable"; Args = "/S" }
    }
    "ANTIVIRUS" = @{
        "1" = @{ Nombre = "Kaspersky Removal Tool";  Url = "https://tu-nube.com";         Tipo = "Portable"; Args = "" }
        "2" = @{ Nombre = "Malwarebytes AdwCleaner"; Url = "https://tu-nube.com";   Tipo = "Portable"; Args = "" }
    }
    "SAQMED" = @{
        "1" = @{ Nombre = "Programa Interno SAQMED"; Url = "https://tu-nube.com"; Tipo = "Instalable"; Args = "/silent" }
        "2" = @{ Nombre = "Base de Datos SAQMED";    Url = "https://tu-nube.com";   Tipo = "Portable"; Args = "" }
    }
    "OTROS" = @{
        "1" = @{ Nombre = "Navegador Google Chrome"; Url = "https://tu-nube.com"; Tipo = "Instalable"; Args = "/qn /norestart" }
        "2" = @{ Nombre = "Limpiador Temporal Windows"; Url = "https://tu-nube.com"; Tipo = "Script"; Args = "" }
    }
}

# 4. FUNCIÓN CENTRAL DE DESCARGA Y PROCESAMIENTO
function Ejecutar-Herramientas {
    param (\$Categoria, \$SubOpcion)
    
    $Tool = $Repo[\$Categoria][\$SubOpcion]
    $NombreArchivo = \$Tool.Url -split '/' | Select-Object -Last 1
    $ArchivoLocal = Join-Path $RutaDestino \$NombreArchivo
    
    Clear-Host
    Write-Host ">>> Procesando: $($Tool.Nombre)" -ForegroundColor Cyan
    Write-Host "Descargando desde tu nube..." -ForegroundColor Yellow
    
    try {
        # Descarga el archivo de forma limpia
        Invoke-WebRequest -Uri \$Tool.Url -OutFile \$ArchivoLocal -UseBasicParsing
        Write-Host "[OK] Descargado exitosamente en \$ArchivoLocal" -ForegroundColor Green
        
        # Lógica según el tipo de herramienta
        if (\$Tool.Tipo -eq "Portable") {
            Write-Host "Iniciando herramienta portable..." -ForegroundColor Green
            Start-Process \$ArchivoLocal
        } 
        elseif (\$Tool.Tipo -eq "Instalable") {
            Write-Host "Instalando en segundo plano (Modo Silencioso)..." -ForegroundColor Green
            if (\$Tool.Args) {
                Start-Process \$ArchivoLocal -ArgumentList \$Tool.Args -Wait
            } else {
                Start-Process \$ArchivoLocal -Wait
            }
            Write-Host "¡Instalación completada!" -ForegroundColor Green
        }
        elseif (\$Tool.Tipo -eq "Script") {
            Write-Host "Ejecutando script secundario..." -ForegroundColor Green
            Start-Process \$ArchivoLocal -Wait
        }
    } catch {
        Write-Warning "No se pudo procesar la herramienta. Verifica el enlace directo de tu nube."
    }
    Read-Host "`nPresiona Enter para volver al menú anterior"
}

# 5. MENÚ INTERACTIVO BUCLE (Estructura principal)
while (\$true) {
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
    
    \$Opcion = Read-Host "Selecciona una categoría"
    
    # Mapeo de opciones principales a las llaves de nuestro diccionario
    \$CatSeleccionada = ""
    switch (\$Opcion) {
        "1" { \$CatSeleccionada = "DRIVERS" }
        "2" { \$CatSeleccionada = "UTILERIAS" }
        "3" { \$CatSeleccionada = "ANTIVIRUS" }
        "4" { \$CatSeleccionada = "SAQMED" }
        "5" { \$CatSeleccionada = "OTROS" }
        "X" { Clear-Host; break }
        "x" { Clear-Host; break }
        Default { continue }
    }
    
    # Submenú dinámico para la categoría seleccionada
    while (\$true) {
        Clear-Host
        Write-Host "==================================================" -ForegroundColor Cyan
        Write-Host "         CATEGORIA: \$CatSeleccionada              " -ForegroundColor Cyan
        Write-Host "==================================================" -ForegroundColor Cyan
        
        # Listar las subopciones disponibles en esta categoría
        \$Items = \$Repo[\$CatSeleccionada]
        \$Items.Keys | Sort-Object | ForEach-Object {
            Write-Host "[\$_] \((\)Items[\(_].Nombre) (\)(\(Items[\)_].Tipo))"
        }
        Write-Host "[R] Regresar al Menú Principal"
        Write-Host "==================================================" -ForegroundColor Cyan
        
        \$SubOpcion = Read-Host "Selecciona la herramienta a descargar"
        
        if (\$SubOpcion -eq "R" -or \$SubOpcion -eq "r") { break }
        
        if (\$Items.ContainsKey(\$SubOpcion)) {
            Ejecutar-Herramientas -Categoria \$CatSeleccionada -SubOpcion \$SubOpcion
        }
    }
}
