$ip_DM = "169.254.1.1" 
$ip_EP = "169.254.1.2" 
$mac_DM = "00:00:00:00:05:01"
$mac_EP = "00:00:00:00:05:02" 
$powerswitch_ip = "192.168.22.234"
$dm_port = "p16"
$ep_port = "p14"
$passed = $true

# 1 . Burn the device with profile Coax Fast Config 40-5 FB, include LinkEvaluation in the process. 

# 2 Generate traffic 
Set-Location V:\Golan\FW_Versions\GolanW\@Tools\SDK\_B0_\SDK_2_1_013

# 3 

Push-Location (Get-Location) 

Set-Location C:\SVN\Golan_suite\Golan\Global_Tools;

.\ePowerSwitch_SNMP.exe $powerswitch_ip "$($ep_port)=0"

Pop-Location

# 4 

Start-Sleep -Seconds 3 

$result = .\setmap.exe -i $ip_DM -m $mac_DM -f map_50_50.bin 
if ($result -notcontains 'set map done' ) { $passed = $false } 

$result = .\activateconfig.exe -i $ip_DM -m $mac_DM -M
if ($result -notcontains 'activate config done for bat' ) { $passed = $false }


# 5 
Push-Location (Get-Location) 

Set-Location C:\SVN\Golan_suite\Golan\Global_Tools;

.\ePowerSwitch_SNMP.exe $powerswitch_ip "$($ep_port)=1"

Pop-Location

# 6 
$result = .\reset.exe -i $ip_DM -m $mac_DM 
if ($result -notcontains 'reset done' ) { $passed = $false }

# 8 

$result = .\getmap.exe -i $ip_DM -m $mac_DM -f my_map.bin 
if ($result -notcontains 'get map done' ) { $passed = $false }

# 9
$result = .\reset.exe -i $ip_EP -m $mac_EP 
if ($result -notcontains 'reset done' ) { $passed = $false }

#10 
$result = .\getmap.exe -i $ip_EP -m $mac_EP -f my_map.bin 
if ($result -notcontains 'get map done' ) { $passed = $false }

if ($passed) { Write-Host "Test is passed" }
else { Write-Host "Test is failed"}  