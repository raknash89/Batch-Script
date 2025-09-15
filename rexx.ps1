param ($inp)
function GDG ($gdgbase){
	#param ($gdgbase)
	if (Test-Path -Path $gdgbase) {
		Write-Output "GDGBASE Exists         >> $gdgbase"					# Validating GDG base exists
		#return $gdgbase
		#$filename = get-childitem -Path $gdgbase -Filter "*.txt" -Recurse | Sort-Object LastWriteTime -Descending | % { $_.Name + "," + $_.LastWriteTime} 
		#$filename = get-childitem -Path $global:gdgbase  | Sort-Object LastWriteTime -Descending | % { $_.Name + "," + $_.LastWriteTime} 
		
		#$filename = get-childitem -Path $gdgbase -Filter "*.SEQ" | Sort-Object LastWriteTime -Descending | % { $_.Name }
		$filename = get-childitem -Path $gdgbase -Filter "*.SEQ" | Sort-Object Name | % { $_.Name }
		#Write-Output $filename
		READ_FILE $filename $gdgbase
		
	} else {
		ABEND 4 "$Folder not listed in Catalogue"
		Write-Output "GDG base not created $gdgbase"
		
	}
	
}

function READ_FILE ($filename,$gdgbase) {
	
	$global:header = ''
	$global:date = 99999999
	$global:datetime = 99999999
	$filename_count = ([regex]::Matches($filename, ".SEQ" )).count
	
	if ($filename_count -ge 1) {
		
		$path_file = $gdgbase +"\"+ $filename[0]
		if ($filename_count -eq 1){
			$path_file = $gdgbase +"\"+ $filename
		}
		Write-Output "Reading the Generation >> $path_file"
		## Invoke only if data format as EBCDIC ##
		<#
		$Buffer = Get-Content -Path $path_file -Encoding byte
		$Encoding = [System.Text.Encoding]::GetEncoding("IBM037")
		$content = $Encoding.GetString($Buffer)
		#>
		$content = Get-Content -Path $path_file
		Write-Output $content
		EXTRACT_INFO $content[0] $gdgbase
		$global:file_present = 'yes'
		#Write-Output $path_file
	}
	else{
		#$global:arr += "No file for company"
		$global:arr += @(@{counter=$i; header=$global:header; date=$global:date; time=$global:datetime})
		Write-Output "''' counter=$i; header=$global:header; date=$global:date; time=$global:datetime"
		Write-Output "Generation is EMPTY $gdgbase"
	}

}

function EXTRACT_INFO ($line,$gdgbase){
	Write-Output "data $line"
	$pos = $line.Indexof('.') 
	$lastpos = $line.LastIndexof('.')
	$global:header = $line.Substring(63,$pos - 63)
	$global:date = $line.Substring($pos+1,8)
	$global:datetime = $line.Substring($lastpos+1,8)
	
	if ($global:header -ne 'JHENROLRPT') {
		$global:header = $line.Substring(62,$pos - 62)
	}

	#$global:arr += "$gdgbase >> $header|$date|$time"
	$global:arr += @(@{counter=$i; header=$global:header; date=$global:date; time=$global:datetime})
	Write-Output "''' counter=$i; header=$global:header; date=$global:date; time=$global:datetime"
	
}


function ABEND ($code,$reason){
	#Write-Host Script Start
	Write-Host Executing exit command with exit code $code
	Write-Host $reason
	exit $code
	Write-Host Script End
}

function HIGHEST_DATE_CAL {
	Write-Output " /* Determine most recent of the five files */ "
	$calc_val = $global:arr |Sort @{Expression={$_.date,$_.time}; Ascending=$False}
	Write-Output $calc_val
	Write-Output "top two >" $calc_val.date[0]
	Write-Output "top Three >" $calc_val.date[1]
	Write-Output "top Four >" $calc_val.date[2]
	
	$res = $global:arr.Where{$_.counter -eq 10} 
	Write-Output $res.date
}

<#
function WRITE_FILE ($data){
	Write-Output $data
	$file_out = $global:Folder_out + "C10_TEMP.txt"
	Out-File -Filepath $file_out 	# Create a output file 
	$data > $file_out


#>

$global:Folder = $inp

#$global:Folder = 'D:\gowrishankar.p\Bat_script\AC1\test\data'

#$param = $global:Folder									# Accept parm value run-time
Write-Output "response $param1" 
$global:Folder_out = 'D:\gowrishankar.p\Bat_script\'    # Outifle optional
$global:arr = @()
$global:file_present = 'yes'

Write-Output " ***** Call Process_Files for the first time at the begining *** "
$i = 10
do
{
  "`$i = $i"
  $a = $global:Folder+"\"+$i+"STG"						#passing C*STG base file
  "Each $a"
  $g = GDG $a
  Write-Output $g
  $i = $i + 10
} while($i -le 30) 										#Incremental based on the base name

#Write-Output "filePresent : $global:file_present"

if ($global:file_present -ne 'yes') {
	Write-Output "No Files are present"
	ABEND 0 "REXX Program Completed Sucessfully"
	#NEED to Call write program"
}
else{
	HIGHEST_DATE_CAL
}


#$g = GDG $Folder
#Write-Output $global:arr.Where{$_.counter -eq 20} | Select-Object {$_.date}
