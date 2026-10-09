Add-Type -AssemblyName PresentationFramework

\$Ventana = New-Object System.Windows.Window
\$Ventana.Title = "Toolbox Tecnys - Panel de Soporte TI"
\$Ventana.Width = 500
\(Ventana.Height = 630\)Ventana.WindowStartupLocation = "CenterScreen"
\$Ventana.Background = "#F5F5F5"

\$PanelPrincipal = New-Object System.Windows.Controls.StackPanel
\$PanelPrincipal.Margin = "20"

\$Titulo = New-Object System.Windows.Controls.TextBlock
\$Titulo.Text = "UTILERIAS TECNYS"
\(Titulo.FontSize = 22\)Titulo.FontWeight = "Bold"
\$Titulo.HorizontalAlignment = "Center"
\$Titulo.Margin = "0,0,0,15"
PanelPrincipal.Children.Add(Titulo) | Out-Null

\$SubA = New-Object System.Windows.Controls.TextBlock
\$SubA.Text = "Instalaciones Automatizadas (Winget)"
\$SubA.FontWeight = "Bold"
\$SubA.Margin = "0,5,0,5"
PanelPrincipal.Children.Add(SubA) | Out-Null

\$Fila1 = New-Object System.Windows.Controls.WrapPanel
\$B1 = New-Object System.Windows.Controls.Button -Property @{ Content="1. AnyDesk"; Width=215; Height=35; Margin="0,5,5,5"; Background="#E31A1A"; Foreground="White"; FontWeight="Bold" }
\$B1.Add_Click({ Start-Process cmd.exe -ArgumentList "/c winget install Anydesk.Anydesk --accept-source-agreements --accept-package-agreements" -NoNewWindow -Wait; [System.Windows.MessageBox]::Show("AnyDesk Finalizado", "Tecnys") })
\$B2 = New-Object System.Windows.Controls.Button -Property @{ Content="2. Google Chrome"; Width=215; Height=35; Margin="5,5,0,5"; Background="#0078D4"; Foreground="White"; FontWeight="Bold" }
\$B2.Add_Click({ Start-Process cmd.exe -ArgumentList "/c winget install Google.Chrome --accept-source-agreements --accept-package-agreements" -NoNewWindow -Wait; [System.Windows.MessageBox]::Show("Chrome Finalizado", "Tecnys") })
Fila1.Children.Add(B1) | Out-Null
Fila1.Children.Add(B2) | Out-Null
PanelPrincipal.Children.Add(Fila1) | Out-Null

\$Fila2 = New-Object System.Windows.Controls.WrapPanel
\$B3 = New-Object System.Windows.Controls.Button -Property @{ Content="3. WinRAR"; Width=215; Height=35; Margin="0,5,5,5"; Background="#7A2482"; Foreground="White"; FontWeight="Bold" }
\$B3.Add_Click({ Start-Process cmd.exe -ArgumentList "/c winget install AlexanderRoshal.WinRAR --accept-source-agreements --accept-package-agreements" -NoNewWindow -Wait; [System.Windows.MessageBox]::Show("WinRAR Finalizado", "Tecnys") })
\$B4 = New-Object System.Windows.Controls.Button -Property @{ Content="4. CCleaner"; Width=215; Height=35; Margin="5,5,0,5"; Background="#FF5722"; Foreground="White"; FontWeight="Bold" }
\$B4.Add_Click({ Start-Process cmd.exe -ArgumentList "/c winget install Piriform.CCleaner --accept-source-agreements --accept-package-agreements" -NoNewWindow -Wait; [System.Windows.MessageBox]::Show("CCleaner Finalizado", "Tecnys") })
Fila2.Children.Add(B3) | Out-Null
Fila2.Children.Add(B4) | Out-Null
PanelPrincipal.Children.Add(Fila2) | Out-Null

\$B5 = New-Object System.Windows.Controls.Button -Property @{ Content="5. PC Windows Manager (Microsoft)"; Height=35; Margin="0,5,0,15"; Background="#008080"; Foreground="White"; FontWeight="Bold" }
\$B5.Add_Click({ Start-Process cmd.exe -ArgumentList "/c winget install Microsoft.PCManager --accept-source-agreements --accept-package-agreements" -NoNewWindow -Wait; [System.Windows.MessageBox]::Show("PC Manager Finalizado", "Tecnys") })
PanelPrincipal.Children.Add(B5) | Out-Null

\$SubB = New-Object System.Windows.Controls.TextBlock
\$SubB.Text = "Enlaces de Descarga Manual (Navegador)"
\$SubB.FontWeight = "Bold"
\$SubB.Margin = "0,5,0,5"
PanelPrincipal.Children.Add(SubB) | Out-Null

\$B6 = New-Object System.Windows.Controls.Button -Property @{ Content="6. Abrir Web Endpoint Security"; Height=35; Margin="0,5,0,5"; Background="#107C41"; Foreground="White"; FontWeight="Bold" }
\$B6.Add_Click({ Start-Process "https://microsoft.com" })
PanelPrincipal.Children.Add(B6) | Out-Null

\$B7 = New-Object System.Windows.Controls.Button -Property @{ Content="7. Abrir Web Nitro Pro"; Height=35; Margin="0,5,0,5"; Background="#D24726"; Foreground="White"; FontWeight="Bold" }
\$B7.Add_Click({ Start-Process "https://gonitro.com" })
PanelPrincipal.Children.Add(B7) | Out-Null

\$B8 = New-Object System.Windows.Controls.Button -Property @{ Content="8. Abrir Web Driver Konica Bizhub 287"; Height=35; Margin="0,5,0,15"; Background="#005A9E"; Foreground="White"; FontWeight="Bold" }
\$B8.Add_Click({ Start-Process "https://konicaminolta.eu" })
PanelPrincipal.Children.Add(B8) | Out-Null

\$SubC = New-Object System.Windows.Controls.TextBlock
\$SubC.Text = "Herramientas de Emergencia"
\$SubC.FontWeight = "Bold"
\$SubC.Margin = "0,5,0,5"
PanelPrincipal.Children.Add(SubC) | Out-Null

\$B9 = New-Object System.Windows.Controls.Button -Property @{ Content="9. ABRIR WINUTIL (CHRIS TITUS)"; Height=40; Background="#4B0082"; Foreground="White"; FontWeight="Bold" }
\(B9.Add_Click({\)Ventana.Close(); Start-Process powershell.exe -ArgumentList "-NoExit -ExecutionPolicy Bypass -Command `"irm ://christitus.com | iex`"" -Verb RunAs })
PanelPrincipal.Children.Add(B9) | Out-Null

\$Ventana.Content = \(PanelPrincipal\)Ventana.ShowDialog() | Out-Null
