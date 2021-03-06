$tools_location = "V:\Golan\FW_Versions\GolanW\@Tools\SDK\_B0_\SDK_2_1_013"
$bin_file = "C:\Users\ver\AppData\Roaming\UVP\for_prog\CG5316-02.01.001.0046-COAX - FAST_CFG_180_1 - FB.bin"
$bat_file = "C:\temp\bat_load1.txt"
$memory_location = "0x706C0208"
$board_ip = 169.254.1.1
$mac = 00:C5:D9:51:00:00

Set-Location $tools_location
$passed = $true 

$res = ./eraseflash.exe -i $board_ip -e ebl_spi_header_bcb_b0.dat -f golan_FlashUpgrade_image.dat
$res
if ($res -notcontains 'erase flash done') { $passed = $false } 
$passed

$res = ./readmem.exe  -i $board_ip -m $mac -a $memory_location  -l 4
$res
if ($res -notmatch '\d{2} \d{2} \d{2} \d{2}') { $passed = $false } 
$passed

$res = ./writemem.exe   -i $board_ip -m $mac -a $memory_location -b 0x11223344
$res
if ($res -notcontains "write to address $($memory_location) done") { $passed = $false } 
$passed

$res = ./reset.exe -i $board_ip -m $mac
$res
if ($res -notcontains 'reset done') { $passed = $false }
$passed
 
Start-sleep 3

$res = ./fwload.exe -i $board_ip -f $bin_file -c $bat_file
$res
if (-not( ($res.Length -ge 3) -and ($res[2] -like '*fw load done successfully*'))) { $passed = $false }

if ($passed) { Write-Host "Test is passed" }
else { Write-Host "Test is failed"}  

