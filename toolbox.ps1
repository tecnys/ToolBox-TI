if(!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){powershell "-ExecutionPolicy" "Bypass" "-NoProfile" "-File" "$PSCommandPath";exit}
Add-Type -AssemblyName PresentationFramework
$V=New-Object System.Windows.Window
$V.Title="Utilerias Technys"
$V.Width=440
$V.Height=600
$V.WindowStartupLocation="CenterScreen"
$V.ResizeMode="NoResize"
$P=New-Object System.Windows.Controls.StackPanel
$P.Margin="20"
$L=[ordered]@{
"1. AnyDesk"="https://download.anydesk.com/AnyDesk.exe"
"2. Chrome"="https://dl.google.com/chrome/install/375.126/chrome_installer.exe"
"3. WinRAR"="https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-701.exe"
"4. CCleaner"="https://download.ccleaner.com/ccsetup.exe"
"5. PC Manager"="https://pcmanager.microsoft.com/"
"6. Web Endpoint Security"="https://microsoft.com"
"7. Web Nitro Pro"="https://gonitro.com"
"8. Web Driver Konica"="https://konicaminolta.eu"
"9. ABRIR WINUTIL (CHRIS TITUS)"="titus"
"10. ACTIVADOR OFFICE (MAS)"="mas"
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
            Start-Process powershell "-NoExit -ExecutionPolicy Bypass -Command IMR https://christitus.com/win | IEX" -Verb RunAs
        }elseif($cmd -eq "mas"){
            $V.Close()
            Start-Process powershell "-NoExit -ExecutionPolicy Bypass -Command IMR https://get.activated.win | IEX" -Verb RunAs
        }elseif($cmd -like "http*"){
            Start-Process $cmd
        }
    })
    $P.Children.Add($B)|Out-Null
}
$V.Content=$P
$V.ShowDialog()|Out-Null
