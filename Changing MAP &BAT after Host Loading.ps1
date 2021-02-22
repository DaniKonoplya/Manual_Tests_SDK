$ip_DM = "169.254.1.1" 
$ip_EP = "169.254.1.2" 
$mac_DM = "00:00:00:00:05:01"
$mac_EP = "00:00:00:00:05:02" 
$passed = $true
Set-Location V:\Golan\FW_Versions\GolanW\@Tools\SDK\_B0_\SDK_2_1_013
#BAT
#2
$result = .\setconfig.exe -i $ip_DM -m $mac_DM -b BAT_40_5_DM.txt
if ($result -notcontains 'set config done' ) { $passed = $false } 

Start-Sleep -Seconds 2

$result = .\activateconfig.exe -i $ip_DM -m $mac_DM -B
if ($result -notcontains 'activate config done for bat' ) { $passed = $false }

#3
$result = .\query.exe  -i $ip_DM -m $mac_DM -b original_bat_DM.txt 
if ($result[-1] -notmatch 'BAT configuration file.*created') { $passed = $false }

#MAP
#2
$result = .\setmap.exe -i $ip_DM -m $mac_DM -f "$($imager_folder)\map_100_5_ack.bin" 
if ($result -notcontains 'set map done' ) { $passed = $false } 

Start-Sleep -Seconds 3 
$result = .\activateconfig.exe -i $ip_DM -m $mac_DM -M 
if ($result -notcontains 'activate config done for bat' ) { $passed = $false }

Start-Sleep -Seconds 3 
#3
$result = .\getmap.exe -i $ip_DM -m $mac_DM -f changed_map.bin 
if ($result -notcontains 'get map done' ) { $passed = $false }

if ($passed) { Write-Host "Test is passed" }
else { Write-Host "Test is failed" }  