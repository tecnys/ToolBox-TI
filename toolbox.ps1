Add-Type -AssemblyName PresentationFramework

$Ventana = New-Object System.Windows.Window
$Ventana.Title = "Toolbox Tecnys"
$Ventana.Width = 450
$Ventana.Height = 400
$Ventana.WindowStartupLocation = "CenterScreen"

$Panel = New-Object System.Windows.Controls.StackPanel
$Panel.Margin = "20"

$Titulo = New-Object System.Windows.Controls.TextBlock
$Titulo.Text = "UTILERIAS TECNYS"
$Titulo.FontSize = 20
$Titulo.FontWeight = "Bold"
$Titulo.HorizontalAlignment = "Center"
$Titulo.Margin = "0,0,0,15"
$Panel.Children.Add($Titulo) | Out-Null

$Btn1 = New-Object System.Windows.Controls.Button -Property @{ Content="1. Instalar AnyDesk"; Height=35; Margin="5" }
$Btn1.Add_Click({ Start-Process cmd.exe -ArgumentList "/c winget install Anydesk.Anydesk --accept-source-agreements --accept-package-agreements" -NoNewWindow -Wait; [System.Windows.MessageBox]::Show("AnyDesk Finalizado", "Tecnys") })
$Panel.Children.Add($Btn1) | Out-Null

$Btn2 = New-Object System.Windows.Controls.Button -Property @{ Content="2. Instalar Google Chrome"; Height=35; Margin="5" }
$Btn2.Add_Click({ Start-Process cmd.exe -ArgumentList "/c winget install Google.Chrome --accept-source-agreements --accept-package-agreements" -NoNewWindow -Wait; [System.Windows.MessageBox]::Show("Chrome Finalizado", "Tecnys") })
$Panel.Children.Add($Btn2) | Out-Null

$Btn3 = New-Object System.Windows.Controls.Button -Property @{ Content="3. Instalar WinRAR"; Height=35; Margin="5" }
$Btn3.Add_Click({ Start-Process cmd.exe -ArgumentList "/c winget install AlexanderRoshal.WinRAR --accept-source-agreements --accept-package-agreements" -NoNewWindow -Wait; [System.Windows.MessageBox]::Show("WinRAR Finalizado", "Tecnys") })
$Panel.Children.Add($Btn3) | Out-Null

$Ventana.Content = $Panel
$Ventana.ShowDialog() | Out-Null
