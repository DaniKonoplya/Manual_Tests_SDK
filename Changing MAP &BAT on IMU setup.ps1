
$ip_EP = "169.254.1.2" 
$mac_DM = "00:00:00:00:05:01"
$mac_EP = "00:00:00:00:05:02" 
$passed = $true
$imager_folder = "C:\Program Files (x86)\ISSI\CG5316Imager"

Set-Location V:\Golan\FW_Versions\GolanW\@Tools\SDK\_B0_\SDK_2_1_013

#1
$result = .\setmap.exe -i $ip_DM -m $mac_DM -f  "$($imager_folder)\MAPs\map_40_5.bin" 
if ($result -notcontains 'set map done' ) { $passed = $false } 

$result = .\activateconfig.exe -i $ip_DM -m $mac_DM -M 
if ($result -notcontains 'activate config done for bat' ) { $passed = $false }

$result = .\setconfig.exe -i $ip_DM -m $mac_DM -b "C:\Users\ver\Documents\BAT_file_20210107_111226_InputsFile_100_5_FB_configuration_DM.txt"
if ($result -contains 'set config done' ) { $passed = $false } 

$result = .\activateconfig.exe -i $ip_DM -m $mac_DM -B
if ($result -notcontains 'activate config done for bat' ) { $passed = $false }

".\getmap.exe -i $($ip_DM) -m $($mac_DM) -f changed_map_DM.bin"
$result = .\getmap.exe -i $ip_DM -m $mac_DM -f changed_map_DM.bin 
if ($result -notcontains 'get map done' ) { $passed = $false }

".\query.exe  -i $($ip_DM) -m $($mac_DM) -b changed_bat_DM.txt"
$result = .\query.exe  -i $ip_DM -m $mac_DM -b changed_bat_DM.txt 
if ($result[-1] -notmatch 'BAT configuration file.*created') { $passed = $false }

if ($passed) { Write-Host "Test is passed" }
else { Write-Host "Test is failed" }  
