if(!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){powershell "-ExecutionPolicy" "Bypass" "-NoProfile" "-File" "$PSCommandPath";exit}
Add-Type -AssemblyName PresentationFramework
$V=New-Object System.Windows.Window
$V.Title="Utilerias Technys"
$V.Width=440
$V.Height=550
$V.WindowStartupLocation="CenterScreen"
$V.ResizeMode="NoResize"
$P=New-Object System.Windows.Controls.StackPanel
$P.Margin="20"
$L=[ordered]@{
"1. AnyDesk"="winget install Anydesk.Anydesk --accept-source-agreements --accept-package-agreements"
"2. Chrome"="winget install Google.Chrome --accept-source-agreements --accept-package-agreements"
"3. WinRAR"="winget install AlexanderRoshal.WinRAR --accept-source-agreements --accept-package-agreements"
"4. CCleaner"="winget install Piriform.CCleaner --accept-source-agreements --accept-package-agreements"
"5. PC Manager"="winget install Microsoft.PCManager --accept-source-agreements --accept-package-agreements"
"6. Web Endpoint Security"="https://microsoft.com"
"7. Web Nitro Pro"="https://gonitro.com"
"8. Web Driver Konica"="https://konicaminolta.eu"
"9. ABRIR WINUTIL (CHRIS TITUS)"="titus"
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
    $B.Add_Click({
        $cmd=$this.Tag
        if($cmd -eq "titus"){
            $V.Close()
            Start-Process powershell "-NoExit -ExecutionPolicy Bypass -Command IMR https://christitus.com/win | IEX" -Verb RunAs
        }elseif($cmd -like "http*"){
            Start-Process $cmd
        }else{
            Start-Process powershell "-NoProfile -ExecutionPolicy Bypass -Command $cmd" -WindowStyle Hidden
        }
    })
    $P.Children.Add($B)|Out-Null
}
$V.Content=$P
$V.ShowDialog()|Out-Null
