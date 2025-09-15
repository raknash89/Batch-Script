$regex = ''
$list = @()
$joblist = @('GDG','PSFB') 											# List of jobs 

$content = Get-Content -Path @("C:\Users\XXXXX\template.txt")  		# IBM job submit tempate


$source = 'C:\Users\XXXXX\source_few\'          					# Mainframe downloaded PDS file path
$target = 'C:\Users\XXXXX\target\'          						# Raincode  FTPied PDS file path


$filename = get-childitem -Path $source -Filter "*(*.*" -Recurse | % { $_.Name }

# Copy Files from From source and reanme the files name and paste into Target path
foreach($file in $filename)
{

	$ext = ".JCL"
    $pattern = '(?<=\().+?(?=\))'
    $regex = [regex]::Matches($file, $pattern).Value
    Copy-Item "$source$file" "$target$regex$ext"
    $list += $regex + $ext
    
}

foreach($job in $joblist)
{
    $count = 0
    $jcl = $job
    do
    {
        $jobname = $jcl + $count + ".JCL"
        if($list.Contains($jobname)){   
            Write-Output "Match $jobname"
            $out = $content -replace "JCLNAME",$jobname     # Replace the string
            Out-File -Filepath $out_path   					# Create a output file 
            $out > $out_path      			        		# Override the output for each job execution 
            & $out_path          			          		# Trigger the PS script 
        }
        $count++
    } Until($count -gt $list.length)
    
    

}
