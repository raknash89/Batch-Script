
$content = Get-Content -Path @("D:\gowrishankar.p\Bat_script\get-acl-folder-list.txt")  # IBM job submit tempate

# Copy Files from From source and reanme the files name and paste into Target path
Out-File -FilePath "D:\gowrishankar.p\Bat_script\get-acl-output.txt"
'' > "D:\gowrishankar.p\Bat_script\get-acl-pharse.txt"
foreach($folderPath in $content)
{
	get-acl $folderPath | Format-List -Property PSPath,AccessToString 	>> "D:\gowrishankar.p\Bat_script\get-acl-output.txt"
	
}

$result = Get-Content -Path @("D:\gowrishankar.p\Bat_script\get-acl-output.txt")  # IBM job submit tempate

foreach($line in $result)
{
    $line = $line.trim()
    $line =  $line -replace '\s+', ' '
    if($line.Length -gt 0)
    {
        if($line.Contains('PSPath'))
        {
            $split = $line -split ' '
            #$line
            $path = $split[2] 
            $len = $path.Length
            $path = $path.Substring(38,$len-38)
            #$path = $path -replace 'Microsoft.PowerShell.Core', ''
            #$path = $path -replace 'FileSystem::', ''
        }
        else
        {
            $line = $line -replace 'AccessToString : ',''
            $split_ = $line -split 'Allow'
            #$split_[0]
            #$split_[1] 
            $data = $path + "," + $split_[0] + ",ALLOW," + $split_[1]
            $data >> "D:\gowrishankar.p\Bat_script\get-acl-pharse.txt"
        }
    }
}
