$ext = "*.META", "*.SEQ" ,".txt"
$path = "D:\gowrishankar.p\Bat_script\AC1"
$outpath = "D:\gowrishankar.p\Bat_script\volume.txt"

function Format-FileSize {
    param([long]$Vol)
    $Bytes = "B", "KB", "MB", "GB", "TB"
    $Idx = 0
    while ($Vol -ge 1024 -and $Idx -lt $Bytes.Length - 1) {
        $Vol = $Vol / 1024
        $Idx++
    }
    "{0:N2} {1}" -f $Vol, $Bytes[$Idx]

}


$out = Get-ChildItem -Path $path -File -Recurse -Include $ext |
    ForEach-Object {
        $sizeFormatted = Format-FileSize $_.Length
        "{0},{1}" -f $_.FullName, $sizeFormatted | Format-Table -AutoSize
    }
	
$out > $outpath

#$res = Get-ChildItem -Path $path -File -Recurse -Include $ext |
#    Select-Object @{Name="Path"; Expression={$_.FullName}}, 
#                  @{Name="Volume"; Expression={Format-FileSize $_.Length}} | Format-Table -AutoSize
				  

