$ip_DM = "169.254.1.1" 
$ip_EP = "169.254.1.2" 
$mac_DM = "00:00:00:00:05:01"
$mac_EP = "00:00:00:00:05:02" 
$imager_folder = "C:\Program Files (x86)\ISSI\CG5316Imager"
$passed = $true

Set-Location V:\Golan\FW_Versions\GolanW\@Tools\SDK\_B0_\SDK_2_1_013
Get-ChildItem $imager_folder\MAPs

$maps=@('100_5','40_5','50_50')
$image = $maps[2]

$result = .\setmap.exe -i $ip_DM -m $mac_DM -f "$imager_folder\MAPs\map_$image.bin" 
if ($result -notcontains 'set map done' ) { $passed = $false } 
$result

$result = .\activateconfig.exe -i $ip_DM -m $mac_DM -M 
if ($result -notcontains 'activate config done for bat' ) { $passed = $false }
$result

$result = .\setconfig.exe -i $ip_DM -m $mac_DM -b (Get-ChildItem "$imager_folder\BAT_file*$image*DM*").FullName
if ($result -notcontains 'set config done' ) { $passed = $false } 
$result

$result = .\activateconfig.exe -i $ip_DM -m $mac_DM -B
if ($result -notcontains 'activate config done for bat' ) { $passed = $false }
$result

$result = .\setconfig.exe -i $ip_EP -m $mac_EP -b (Get-ChildItem "$imager_folder\BAT_file*$image*EP*").FullName
if ($result -contains 'set config done' ) { $passed = $false }
$result 

$result = .\activateconfig.exe -i $ip_EP -m $mac_EP -B
if ($result -notcontains 'activate config done for bat' ) { $passed = $false }
$result

if ($passed) { Write-Host "Test is passed" }
else { Write-Host "Test is failed"}  