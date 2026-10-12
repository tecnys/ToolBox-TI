if(!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){powershell "-ExecutionPolicy" "Bypass" "-NoProfile" "-File" "$PSCommandPath";exit}
Add-Type -AssemblyName PresentationFramework

# ⚙️ CONFIGURACION
$WebURL = "https://tecnys.ueniweb.com/"

$V=New-Object System.Windows.Window
$V.Title="Tecnys"
$V.Width=440
$V.Height=820
$V.WindowStartupLocation="CenterScreen"
$V.ResizeMode="NoResize"
$P=New-Object System.Windows.Controls.StackPanel
$P.Margin="20"

# Encabezado descriptivo
$H = New-Object System.Windows.Controls.TextBlock
$H.Text = "Utilerias Tecnys`nServicio y Soporte Tecnico"
$H.HorizontalAlignment = "Center"
$H.TextAlignment = "Center"
$H.FontSize = 14
$H.FontWeight = "Bold"
$H.Foreground = "DarkBlue"
$H.Margin = "0,0,0,15"
$P.Children.Add($H) | Out-Null

$L=[ordered]@{
"1. AnyDesk"="https://anydesk.com/es/downloads/windows"
"2. Chrome"="https://dl.google.com/chrome/install/375.126/chrome_installer.exe"
"3. WinRAR"="https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-701.exe"
"4. CCleaner"="https://download.ccleaner.com/ccsetup.exe"
"5. PC Manager"="https://pcmanager.microsoft.com/"
"6. Web Endpoint Security"="https://support.checkpoint.com/results/download/132149"
"7. Web Nitro Pro"="https://gonitro.com"
"8. Web Driver Konica"="https://www.konicaminolta.jp/business/download/copiers/bizhub_287_227/pcl_ps_pcfax/detail_windows.html"
"9. Diagnostico (Sysinternals)"="https://learn.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite"
"10. Recuperacion (NirSoft)"="https://www.nirsoft.net/utils/index.html"
"11. Clonar Disco (Rescuezilla)"="https://rescuezilla.com/download"
"12. ABRIR WINUTIL (CHRIS TITUS)"="titus"
"13. ACTIVADOR OFFICE (MAS)"="mas"
}
foreach($N in $L.Keys){
    $B=New-Object System.Windows.Controls.Button
    $B.Content=$N
    $B.Height=40
    $B.Margin="4"
    $B.FontWeight="Bold"
    $B.Cursor="Hand"
    $B.Tag=$L[$N]
    if($N -like "*TITUS*"){$B.Background="Purple";$B.Foreground="White"}
    if($N -like "*MAS*"){$B.Background="DarkGreen";$B.Foreground="White"}
    $B.Add_Click({
        $cmd=$this.Tag
        if($cmd -eq "titus"){
            $V.Close()
            Start-Process powershell "-NoExit -ExecutionPolicy Bypass -Command irm https://christitus.com/win | iex" -Verb RunAs
        }elseif($cmd -eq "mas"){
            $V.Close()
            Start-Process powershell "-NoExit -ExecutionPolicy Bypass -Command irm https://get.activated.win | iex" -Verb RunAs
        }elseif($cmd -like "http*"){
            Start-Process $cmd
        }
    })
    $P.Children.Add($B)|Out-Null
}

# Separador visual
$sep = New-Object System.Windows.Controls.Separator
$sep.Margin = "10,15,10,10"
$P.Children.Add($sep) | Out-Null

# Texto de la web (clickeable)
$web = New-Object System.Windows.Controls.TextBlock
$web.Text = "tecnys.ueniweb.com"
$web.HorizontalAlignment = "Center"
$web.Foreground = "Blue"
$web.Cursor = "Hand"
$web.FontWeight = "Bold"
$web.TextDecorations = "Underline"
$web.Add_MouseLeftButtonUp({ Start-Process $WebURL })
$P.Children.Add($web) | Out-Null

$V.Content=$P
$V.ShowDialog()|Out-Null
