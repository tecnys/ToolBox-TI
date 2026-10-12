if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    \$powershellCmd = if (Get-Command pwsh -ErrorAction SilentlyContinue) { "pwsh" } else { "powershell" }
    Start-Process \$powershellCmd -ArgumentList @("-ExecutionPolicy", "Bypass", "-NoProfile", "-File", "`"$PSCommandPath`"") -Verb RunAs
    Exit
}

Add-Type -AssemblyName PresentationFramework

\$Ventana = New-Object System.Windows.Window
\$Ventana.Title = "Utilerias Tecnys"
\$Ventana.Width = 440
\(Ventana.Height = 550\)Ventana.WindowStartupLocation = "CenterScreen"
\$Ventana.ResizeMode = "NoResize"

\$Panel = New-Object System.Windows.Controls.StackPanel
\$Panel.Margin = "20"

\$Lista = [ordered]@{ 
    "1. AnyDesk"                  = "winget install Anydesk.Anydesk --accept-source-agreements --accept-package-agreements"
    "2. Chrome"                   = "winget install Google.Chrome --accept-source-agreements --accept-package-agreements"
    "3. WinRAR"                   = "winget install AlexanderRoshal.WinRAR --accept-source-agreements --accept-package-agreements"
    "4. CCleaner"                 = "winget install Piriform.CCleaner --accept-source-agreements --accept-package-agreements"
    "5. PC Manager"               = "winget install Microsoft.PCManager --accept-source-agreements --accept-package-agreements"
    "6. Web Endpoint Security"    = "https://microsoft.com"
    "7. Web Nitro Pro"            = "https://gonitro.com"
    "8. Web Driver Konica"        = "https://konicaminolta.eu"
    "9. ABRIR WINUTIL (CHRIS TITUS)" = "titus" 
}

foreach (\$Nombre in \(Lista.Keys) {\)Btn = New-Object System.Windows.Controls.Button -Property @{ Content=\$Nombre; Height=40; Margin="4"; FontWeight="Bold"; Cursor="Hand" }
    if (\$Nombre -like "*TITUS*") { Btn.Background = "Purple"; Btn.Foreground = "White" }
    
    Accion = Lista[\(Nombre]\)Btn.Add_Click({
        if (\$Accion -eq "titus") { 
            \$Ventana.Close()
            Start-Process powershell.exe -ArgumentList "-NoExit -ExecutionPolicy Bypass -Command `"irm https://christitus.com | iex`"" -Verb RunAs 
        } elseif (\$Accion -like "http*") {
            Start-Process \$Accion
        } else {
            Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command \$Accion" -WindowStyle Hidden
        }
    })
    Panel.Children.Add(Btn) | Out-Null
}

\$Ventana.Content = \(Panel\)Ventana.ShowDialog() | Out-Null
