# conn.txt > Username  password [nextline] 
# Start-Job -FilePath D:chipseft_rexx.ps1
# Status about the job "Get-Job | Format-List -Property *"
# Filter the job details using date and status
# $running = @(Get-Job | Where-Object { ($_.State -eq 'Running' -or $_.State -eq 'Completed') -and ($_.PSBeginTime -ge $start_date)})

$path = 'D:\gowrishankar.p\Bat_script\boston_ftp_\'

$conn_path = $path +'\conn.txt'
$ftp_list_fb = $path + '\Input_fb.txt'
$ftp_list_vb = $path + '\Input_vb.txt'
$job_out = $path + '\boston_output\'

function Abend($rc,$reason)
{
	Write-Output $reason
	exit $rc
}

function process($file_list,$type)
{
	"recieve $type"
	$temp = $conn_string
	$temp += 'prompt off'
	if ($type -eq "vb")
	{
		$temp += 'literal site rdw'
	}
	
	foreach ($line in $file_list)
	{
		$temp += "get '$line' "
	}
	
	$temp += 'quit'
	#Write Connection string and files to output
	$conn_output = $path + '\connection_'+ $type + '.txt'
	$conn_log = $path + '\' + $type + 'job_log.txt'
	Out-File -FilePath $conn_output
	Out-File -FilePath $conn_log
	$temp > $conn_output
	
	#cd $job_out
	#ftp -s:$conn_output_ boston > $conn_log
	#cd $path
	
}
function Validation
{
	if (Test-Path $path)
	{
		if(Test-Path $job_out){}
		else {New-Item $job_out -itemType Directory }
		
	}
	else
	{
		Abend 08 "Base Path not available, Please validate the path $path"
	}
	
	if (Test-Path $conn_path -PathType Leaf)
	{
		$conn_string = Get-Content $conn_path
	}
	else
	{
		Abend 08 "Connection details not provided" 
	}

	if ((Test-Path $ftp_list_fb) -or (Test-Path $ftp_list_vb) )
	{
		if (Test-Path $ftp_list_fb)
		{
			$ftp_fb = Get-Content $ftp_list_fb
			if ($ftp_fb.Length -gt 0)
			{
				process $ftp_fb "fb"
			}
			else
			{
				"Input_fb file is empty"
			}
		}
		
		if (Test-Path $ftp_list_vb)
		{
			$ftp_vb = Get-Content $ftp_list_vb
			if ($ftp_vb.Length -gt 0)
			{
				process $ftp_fb "vb"
			}
			else
			{
				"Input_vb file is empty"
			}
		}
	}
	else
	{
		Abend 08 "Input Files either Input_fb.txt or Input_vb.txt not present" 
	}
	
	
}

Validation

<#

$count = 0
foreach ($list in $input)
{
	$count = $count + 1
	$split = $list.split(",")
	$file = $split[0]
	$type = $split[1]
	$file
	$temp = $conn_string.replace('MAINFRAME_FILE',$file)
	if ($type -eq 'VB')
	{
		$temp = $temp.replace('rem ','')
		#$conn_temp
	}
	
	$conn_temp = $job_out+'conn_temp'+ $count + '.txt'
	Out-File -FilePath $conn_temp 
	
	$temp > $conn_temp
	$job_temp = $job.replace('ftp_jobXXX','conn_temp'+ $count)
	#$job_temp
	#$Date = Date
	#Write-Output "Job submittion $job_temp : $Date"
	#Start-Job -FilePath $job_temp | Out-Null 
	Start-Job -ScriptBlock {$job_temp | Out-Null}
}

function Date
{
	Return Get-Date
}
<#
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
#>
#>
