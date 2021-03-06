$ip_DM = "169.254.1.1" 
$ip_EP = "169.254.1.2" 
$mac_DM = "00:00:00:00:05:01"
$mac_EP = "00:00:00:00:05:02" 
$imager_folder = "C:\Program Files (x86)\ISSI\CG5316Imager\MAPs"
$passed = $true
# 1 . Burn the device with profile Coax Fast Config 40-5 FB, include LinkEvaluation in the process. 
Set-Location V:\Golan\FW_Versions\GolanW\@Tools\SDK\_B0_\SDK_2_1_013

$result = .\getmap.exe -i $ip_DM -m $mac_DM -f original_DM.bin 
if ($result -notcontains 'get map done' ) { $passed = $false }

Start-Sleep -Seconds 3 
$result = .\getmap.exe -i $ip_EP -m $mac_EP -f original_EP.bin 
if ($result -notcontains 'get map done' ) { $passed = $false }

Start-Sleep -Seconds 3 

#1
$result = .\setmap.exe -i $ip_DM -m $mac_DM -f "$($imager_folder)\map_100_5_ack.bin" 
if ($result -notcontains 'set map done' ) { $passed = $false } 

Start-Sleep -Seconds 3 
#4
$result = .\activateconfig.exe -i $ip_DM -m $mac_DM -M 
if ($result -notcontains 'activate config done for bat' ) { $passed = $false }

Start-Sleep -Seconds 3 

#3
$result = .\getmap.exe -i $ip_DM -m $mac_DM -f changed_map.bin 
if ($result -notcontains 'get map done' ) { $passed = $false }

Start-Sleep -Seconds 3 

$result = fc.exe /b .\original_DM.bin .\changed_map.bin 
        
if ($result[1] -contains "FC: no differences encountered") {
   $passed = $false
}

$result = .\reset.exe -i $ip_DM -m $mac_DM 

#6
if ($result -notcontains 'reset done' ) { $passed = $false }

Start-Sleep -Seconds 3 

$result = .\getmap.exe -i $ip_DM -m $mac_DM -f original_map_DM2.bin 
if ($result -notcontains 'get map done' ) { $passed = $false }

Start-Sleep -Seconds 3 

$result = fc.exe /b .\original_DM.bin .\original_map_DM2.bin 
if ($result -notcontains 'get map done' ) { $passed = $false }
        
if ($result[1] -notcontains "FC: no differences encountered") {
   $passed = $false
}

Start-Sleep -Seconds 3 

$result = .\reset.exe -i $ip_EP -m $mac_EP 

if ($result -notcontains 'reset done' ) { $passed = $false }
Start-Sleep -Seconds 3 

$result = .\getmap.exe -i $ip_EP -m $mac_EP -f original_EP2.bin 
if ($result -notcontains 'get map done' ) { $passed = $false }

Start-Sleep -Seconds 3 

$result = fc.exe /b .\original_EP.bin .\original_EP2.bin 
        
if ($result[1] -notcontains "FC: no differences encountered") {
   $passed = $false
}

if ($passed) { Write-Host "Test is passed" }
else { Write-Host "Test is failed" }  