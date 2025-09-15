<#
# Timestamp update
$origintimestamp = (Get-ChildItem 'D:\gowrishankar.p\Python Script\mfes_input\testing.txt').LastWriteTime
Write-Output "timestamp $origintimestamp"
Copy-Item -Path 'D:\gowrishankar.p\Python Script\mf_input\MF.TEST.DATA.EBCID.txt' -Destination 'D:\gowrishankar.p\Python Script\mfes_input\testing.txt' -PassThru
(Get-ChildItem 'D:\gowrishankar.p\Python Script\mfes_input\testing.txt').LastWriteTime = $origintimestamp
#>

<#
#Get current date 
$date = Get-Date -Format "MM/dd/yyyy HH:mm"
Write-Output "Current Date $date"
#>

<#
# Set the input string
$inputString = "DELETE INTO 001"

# Create an ASCII encoding object
$asciiEncoding = [System.Text.Encoding]::ASCII

# Create an EBCDIC encoding object
$ebcdicEncoding = [System.Text.Encoding]::GetEncoding("IBM037")

# Convert the input string from ASCII to EBCDIC
$ebcdicBytes = [System.Text.Encoding]::Convert($asciiEncoding, $ebcdicEncoding, $asciiEncoding.GetBytes($inputString))
$ebcdicString = $ebcdicEncoding.GetString($ebcdicBytes)
#$ebcdicBytes = [System.Text.Encoding]::Convert($ebcdicEncoding, $asciiEncoding, $ebcdicEncoding.GetBytes($inputString))
#$ebcdicString = $asciiEncoding.GetString($ebcdicBytes)

# Print the output string
Write-Host $ebcdicBytes
Write-Host $ebcdicString

#>

<# Replace values using arrays 
$global:Default_volume = "D:\gowrishankar.p\Bat_script\"

function clean ($line) {
		$gdg_clean = @(@{check=$global:Default_volume;rep=""},@{check="\";rep="."})
		
		foreach ($g in $gdg_clean){
			$line = $line.replace($g.check,$g.rep)
		}
		return $line
		
}	

$line = "D:\gowrishankar.p\Bat_script\AC1\TEST\DATA"
$line = clean $line
Write-Output $line

#>

<#Arrray sorting and return

function sort_ ($arr) {
	#$val = $arr |Sort @{Expression={$_.date,$_.time,$_.header}; Ascending=$True}
	$val = $arr |Sort @{Expression={$_.date,$_.counter}; Ascending=$True}
	#Write-Output " " "Sorting" " "  $val
	return $val
}

$arr = @(@{counter=10; header='C10STG'; date=20230506; time=051501},@{counter=10; header='C10STG'; date=20230505; time=051501},
         @{counter=20; header='C20STG'; date=20230507; time=051501},@{counter=40; header='C40STG'; date=20230502; time=051501},@{counter=40; header='C40STG'; date=20230505; time=051501},
		 @{counter=40; header='C40STG'; date=20230508; time=051501},@{counter=50; header='C50STG'; date=20230505; time=051501},@{counter=50; header='C50STG'; date=20230506; time=051501})
		 

$file_out = 'D:\gowrishankar.p\Bat_script\AC1\TEST\DATA\array_out.txt'
Out-File -Filepath  $file_out	# Create a output file 

foreach ($a in $arr){
	$JoinedString += @(@{counter=$a.counter;date=$a.date})
}

$val = sort_ $JoinedString


foreach ($v in $val){
	$data = $v.counter,$v.date -join " " 
	Write-Output $data
	Add-Content $file_out $data
}

#>

<# Array sort

function open{
	$path = "D:\gowrishankar.p\Bat_script\AC1\TEST\DATA\array_out.txt"
	Out-File -Filepath $path
	return $path
}

function wrt($path,$data){
	Write-Output "path $path Data $data"
	Add-Content $path $data
}

$out = open
Wrt $out "quit"

$arr1 = @()
$arr = @(@{counter=10; header='C10STG'; date=20230506; time=051501},@{counter=10; header='C10STG'; date=20230505; time=051501},
         @{counter=20; header='C20STG'; date=20230507; time=051501},@{counter=40; header='C40STG'; date=20230502; time=051501},@{counter=40; header='C40STG'; date=20230505; time=051501},
		 @{counter=40; header='C40STG'; date=20230508; time=051501},@{counter=50; header='C50STG'; date=20230505; time=051501},@{counter=50; header='C50STG'; date=20230506; time=051501})
		 
		 
if($arr.Length -gt 0){
	Write-Output "data avail"
}

if($arr1.Length -eq 0){
	Write-Output "data not avail"
}

#>

<#
$j = 10
do
{
	"$j = $j"
	$data = $arr | Where-Object counter -eq $j
	
	#$count = $arr | Where-Object counter -eq $j | Group-Object counter | Select-Object Count
	#$count = $arr.Where-Object{$_.counter -eq $j}.Group-Object {$_.counter}.Select-Object Count
	$gen = $data | Group-Object counter | Select-Object Count
	Write-Output $data $gen.count

	Write-Output " " ">>>>>>>>>>" " "
	$j = $j + 10
} while($j -le 50) 	

#>

<# Acessing last filename in folder
$gdgbase = 'D:\gowrishankar.p\Bat_script\AC1\TEST\DATA\20STG'
$filename = get-childitem -Path $gdgbase -Filter "*.SEQ" | Sort-Object Name | % { $_.Name }

Write-Output $filename $filename[-1]

#>

# Merge / Concat Multilpe files
$file = 'D:\gowrishankar.p\Bat_script\AC1\TEST\DATA\10STG\G0001V00.SEQ'
$file_1 = 'D:\gowrishankar.p\Bat_script\AC1\TEST\DATA\10STG\G0002V00.SEQ'
$file_2 = '"D:\gowrishankar.p\Bat_script\AC1\TEST\DATA\test folder\G0005V00.SEQ"'
$out = 'D:\gowrishankar.p\Bat_script\AC1\TEST\DATA\ALLDATA.txt'

#Copy-Item $file -Destination D:\gowrishankar.p\Bat_script\AC1\TEST\DATA\ALLDATA.SEQ -PassThru -Force -Confirm:$false -ErrorAction Stop
#Copy-Item $file_1 -Destination D:\gowrishankar.p\Bat_script\AC1\TEST\DATA\ALLDATA.SEQ -PassThru -Force -Confirm:$false -ErrorAction Stop

$cehck = 'disp'
$cehck
#Merge Option1
cmd /c copy $file+$file_1+$file_2 $out

#Merge Option2
#Get-Content $file,$file_1 | Set-Content $out

#Merge Option
#gc $file, $file_1 > $out
