# Template.txt 
#$x = "job is NAME"
#$y = "job is locatied in this PATH"

#Write-Output $x
#Write-Output $y
#*****************
$regex = ''
$list = @()
$joblist = @('GDG,C:/XX/','PSFB,D:/YY/','PSVB,D:/YY/')

$content = Get-Content -Path @("D:\gowrishankar.p\Bat_script\template.txt")  # IBM job submit tempate

$source = 'D:\gowrishankar.p\Bat_script\cmd-rename\'						 # Mainframe downloaded PDS file path
$target = 'D:\gowrishankar.p\Bat_script\cmd-rename-copy\'					 # Raincode  FTPied PDS file path

#$path = get-childitem -Path "D:\gowrishankar.p\Bat_script\cmd-rename\" -Filter *.txt -Recurse | % { $_.FullName }
$filename = get-childitem -Path $source -Filter "*(*.*" -Recurse | % { $_.Name }

# Copy Files from From source and reanme the files name and paste into Target path
foreach($file in $filename)
{
	$ext = (Get-ChildItem $source$file).Extension
	$pattern = '(?<=\().+?(?=\))'
	$regex = [regex]::Matches($file, $pattern).Value
	Copy-Item "$source$file" "$target$regex$ext"
	$list += $regex + $ext
	
}



foreach($job in $joblist)
{
	$count = 0
	$jcl = $job.Split(",")[0]
	$filepath = $job.Split(",")[1]
	do
	{
		$jobname = $jcl + $count + ".jcl"
		if($list.Contains($jobname)){	
			Write-Output "Match $jobname"
			$out = $content -replace "NAME",$jobname 						# Replace the string
			#$out = $out -replace "PATH",$filepath
			Out-File -Filepath "D:\gowrishankar.p\Bat_script\display.ps1" 	# Create a output file 
			$out > "D:\gowrishankar.p\Bat_script\display.ps1"   			# Write into a output file 
			& "D:\gowrishankar.p\Bat_script\display.ps1"  					# Trigger the PS script 
			#Start-Process -Filepath "D:\gowrishankar.p\Bat_script\display.ps1"

		}
		$count++
	} Until($count -gt $list.length)
	
	

}



