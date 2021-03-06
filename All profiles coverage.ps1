$ip_DM = "169.254.1.1" 
$ip_EP = "169.254.1.2" 
$mac_DM = "00:00:00:00:05:01"
$mac_EP = "00:00:00:00:05:02" 
$bat_files_location = "C:\Temp\CG5316Imager"
$attenuator = "C:\jenkins\workspace\UVP\ReleaseAutomation\B0-Tests\Bulk-Reset\8c14331c\screener\tools\Variable_Attenuator.exe"

& $attenuator -d 1 -a 30
& $attenuator
$passed = $true

#TODO Run the traffic

$profiles = Get-ChildItem "$($bat_files_location)\BAT_file*_*txt" | Where-Object { $_.Name -match "(DM|EP).txt" } 

$hash_table = @{}

#build a hash_table of bats and maps relations.

Get-ChildItem "$($bat_files_location)\Maps\map*.bin" | ForEach-Object {
  foreach ($profile in $profiles) {
    $seek_me = $profile.Name -replace "^.*File_(\w+)_FB.*", '$1'
    if ($_.Name -like "*$($seek_me)*" -and $_.Name -notmatch ".*(ack|hybrid).*") {
      if ($profile -notmatch ".*EP.*") {
        $hash_table[$profile] = $_ 
        $_.Name
        $profile.Name
      }
    }
  }
} 

Set-Location V:\Golan\FW_Versions\GolanW\@Tools\SDK\_B0_\SDK_2_1_013


foreach ($key in $hash_table.Keys) { 
  $key.FullName
  $hash_table[$key].FullName
}

foreach ($key in $hash_table.Keys) { 

  $map = $hash_table[$key].FullName
  $bat = $key.FullName

  $map
  $bat

  ".\setmap.exe -i $($ip_DM) -m $($mac_DM) -f $($map)"
  $result = .\setmap.exe -i $ip_DM -m $mac_DM -f $map
  if ($result -notcontains 'set map done' ) { $passed = $false } 

  ".\activateconfig.exe -i $($ip_DM) -m $($mac_DM) -M"
  $result = .\activateconfig.exe -i $ip_DM -m $mac_DM -M 
  if ($result -notcontains 'activate config done for bat' ) { $passed = $false }

  ".\setconfig.exe -i $($ip_DM) -m $($mac_DM) -b $($bat)"
  $result = .\setconfig.exe -i $ip_DM -m $mac_DM -b $bat 
  if ($result -notcontains 'set config done' ) { $passed = $false } 

  ".\activateconfig.exe -i $($ip_DM) -m $($mac_DM) -B"
  $result = .\activateconfig.exe -i $ip_DM -m $mac_DM -B
  if ($result -notcontains 'activate config done for bat' ) { $passed = $false }

  Start-Sleep -Seconds 2

  ".\setconfig.exe -i $($ip_EP) -m $($mac_EP) -b $($((Get-item ($bat -replace '(.*_file_).*(_InputsFile.*)','$1*$2' -replace 'DM','EP')).FullName))"
  $result = .\setconfig.exe -i $ip_EP -m $mac_EP -b ((Get-item ($bat -replace '(.*_file_).*(_InputsFile.*)', '$1*$2' -replace 'DM', 'EP')).FullName)
  if ($result -notcontains 'set config done' ) { $passed = $false } 

  ".\activateconfig.exe -i $($ip_EP) -m $($mac_EP) -M"
  $result = .\activateconfig.exe -i $ip_EP -m $mac_EP -B
  if ($result -notcontains 'activate config done for bat' ) { $passed = $false }
  
  ".\query.exe  -i $($ip_DM) -m $($mac_DM) -b changed_bat_DM.txt"
  $result = .\query.exe  -i $ip_DM -m $mac_DM -b changed_bat_DM.txt 
  if ($result[-1] -notmatch 'BAT configuration file.*created') { $passed = $false }
  
  ".\query.exe  -i $($ip_EP) -m $($mac_EP) -b changed_bat_EP.txt"
  $result = .\query.exe  -i $ip_EP -m $mac_EP -b changed_bat_EP.txt 
  if ($result[-1] -notmatch 'BAT configuration file.*created') { $passed = $false }
  
  ".\getmap.exe -i $($ip_DM) -m $($mac_DM) -f changed_map_DM.bin"
  $result = .\getmap.exe -i $ip_DM -m $mac_DM -f changed_map_DM.bin 
  if ($result -notcontains 'get map done' ) { $passed = $false }
  
  ".\getmap.exe -i $($ip_EP) -m $($mac_EP) -f changed_map_EP.bin"
  $result = .\getmap.exe -i $ip_EP -m $mac_EP -f changed_map_EP.bin 
  if ($result -notcontains 'get map done' ) { $passed = $false }
  
  Start-Sleep -Seconds 5 
}

$result = .\reset.exe -i $ip_DM -m $mac_DM
if ($result -notcontains 'reset done' ) { $passed = $false }

Start-Sleep -Seconds 5

$result = .\query.exe  -i $ip_DM -m $mac_DM -b original_bat_DM.txt 
if ($result[-1] -notmatch 'BAT configuration file.*created') { $passed = $false }
  
$result = .\query.exe  -i $ip_EP -m $mac_EP -b original_bat_EP.txt 
if ($result[-1] -notmatch 'BAT configuration file.*created') { $passed = $false }

# Restore the attenuator
& $attenuator -d 1 -a 0

if ($passed) { Write-Host "Test is passed" }
else { Write-Host "Test is failed" }  

# .\getmap.exe -i $ip_DM -m $mac_DM -f changed_map_DM.bin | ForEach-Object {
#   if ($_ -like '*get map done') {
#     $true
#   }
# } |  Where-Object {$_ -eq $true } | Foreach-Object { Write-Output "passed" }