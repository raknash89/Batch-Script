
# Start-Job -FilePath D:chipseft_rexx.ps1
# Status about the job "Get-Job | Format-List -Property *"
# Filter the job details using date and status
# $running = @(Get-Job | Where-Object { ($_.State -eq 'Running' -or $_.State -eq 'Completed') -and ($_.PSBeginTime -ge $start_date)})


$arr = @('D:\gowrishankar.p\Bat_script\chipseft_rexx.ps1','D:\gowrishankar.p\Bat_script\accept.ps1')

$start_date = Date

foreach ($job in $arr)
{
	$file = Split-Path $job -Leaf
	$date = Date
	Write-Output "Job Submitted Time : $date Job : $file"
	#Tigger the jobs in background
	Start-Job -FilePath $job | Out-Null 
}

$running = @(Get-Job | Where-Object {$_.PSBeginTime -gt $start_date})
$running

#$Date = Date
#Write "Trigger job process ends $Date"
function Date
{
	Return Get-Date
}
