$ip_DM = "169.254.1.1" 
$ip_EP = "169.254.1.2" 
$mac_DM = "00:00:00:00:05:01"
$mac_EP = "00:00:00:00:05:02" 
$passed = $true

Set-Location V:\Golan\FW_Versions\GolanW\@Tools\SDK\_B0_\SDK_2_1_013

# 4 
$result = query.exe  -i $ip_DM -m $mac_DM -b original_bat.txt 
if ($result[-1] -notmatch 'BAT configuration file.*created') { $passed = $false }

$result = .\setconfig.exe -i $ip_DM -m $mac_DM -b corrupted_bat.txt
if ($result -contains 'set config done' ) { $passed = $false } 

# 6 

$result = query.exe  -i $ip_DM -m $mac_DM -b original_bat2.txt 
if ($result[-1] -notmatch 'BAT configuration file.*created') { $passed = $false }

$result = fc.exe /b .\original_bat.txt .\original_bat2.txt
        
if ($result[1] -notcontains "FC: no differences encountered") {
   $passed = $false
}

if ($passed) { Write-Host "Test is passed" }
else { Write-Host "Test is failed"}  