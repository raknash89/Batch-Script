param ($inp)
$inp = $inp.replace(".","\")
function GDG ($gdgbase){
	if (Test-Path -Path $gdgbase) {
		$filename = get-childitem -Path $gdgbase -Filter "*.SEQ" | Sort-Object Name | % { $_.Name }
		if ($filename.Length -gt 0)
		{	$filename_count = ([regex]::Matches($filename, ".SEQ","IgnoreCase")).count 
			$global:arr += @{counter=$i;gdg=$gdgbase;generation=$filename_count}
			$global:indicator = "Yes"
			#Write-Output "counter=$i;gdg=$gdgbase;generation=$filename_count"
		}
		else
		{
		$global:arr += @{counter=$i;gdg=$gdgbase;generation=0}
		#Write-Output "counter=$i;gdg=$gdgbase;generation=0"
		}
	} else {
		Write-Output "GDG base not created '$gdgbase'"
		ABEND 4 "$Folder not listed in Catalogue"
		
	}
	
}


function clean ($line) {
		$gdg_clean = @(@{check=$global:Default_volume;rep=""},@{check="\";rep="."},@{check="STG";rep=""})
		foreach ($g in $gdg_clean){
			$line = $line.replace($g.check,$g.rep)
		}
		return $line
		
}

function process()
{
	$dd_count = 0
	foreach($array in $global:arr)
	{
		#Write-Output $array
		
		#Dynamic to get create the GDG Versions for XXX.XXX.10
		if($array.counter -eq 10 -And $array.generation -gt 0){
			$inc = 0
			While($inc -le $array.generation-1){
				foreach($t in $template)
				{

					if($t.Substring(0,3) -ne '//*' -And $t.Substring(0,9) -eq '//DD@DD10')
					{
						$inc = $inc+1
						$dd_count = $dd_count + 1
						$gdg_ = clean $array.gdg
						$ddname = "//DD" + $dd_count
						$ver = "+" + $inc
						$t = $t.replace("//DD@DD10",$ddname)
						$t = $t.replace("@GDGBASE",$gdg_)
						$t = $t.replace("@INC",$ver)
						$global:jcl_create += $t
						#Write-Output $t
					}
					if ($t.Substring(0,3) -ne '//*' -And $t.Substring(0,5) -eq '//#10')
					{
						$t = $t.replace('//#10','//')
						$global:jcl_create += $t
					}
				}
			}
		}
		
		#Dynamic to get create the GDG Versions for XXX.XXX.20
		if($array.counter -eq 20 -And $array.generation -gt 0){
			$inc = 0
	#		Write-Output $array.generation
			While($inc -le $array.generation-1){
				foreach($t in $template)
				{
					if($t.Substring(0,3) -ne '//*' -And $t.Substring(0,9) -eq '//DD@DD20')
					{
						$inc = $inc+1
						$dd_count = $dd_count + 1
						$gdg_ = clean $array.gdg
						$ddname = "//DD" + $dd_count
						$ver = "+" + $inc
						$t = $t.replace("//DD@DD20",$ddname)
						$t = $t.replace("@GDGBASE",$gdg_)
						$t = $t.replace("@INC",$ver)
						$global:jcl_create += $t
						#Write-Output $t
					}
					if ($t.Substring(0,3) -ne '//*' -And $t.Substring(0,5) -eq '//#20')
					{
						$t = $t.replace('//#20','//')
						$global:jcl_create += $t
					}
				}
			}
		}
		
		#Dynamic to get create the GDG Versions for XXX.XXX.30
		if($array.counter -eq 30 -And $array.generation -gt 0){
			$inc = 0
			While($inc -le $array.generation-1){
				foreach($t in $template)
				{
					if($t.Substring(0,3) -ne '//*' -And $t.Substring(0,9) -eq '//DD@DD30')
					{
						$inc = $inc+1
						$dd_count = $dd_count + 1
						$gdg_ = clean $array.gdg
						$ddname = "//DD" + $dd_count
						$ver = "+" + $inc
						$t = $t.replace("//DD@DD30",$ddname)
						$t = $t.replace("@GDGBASE",$gdg_)
						$t = $t.replace("@INC",$ver)
						$global:jcl_create += $t
						#Write-Output $t
					}
					if ($t.Substring(0,3) -ne '//*' -And $t.Substring(0,5) -eq '//#30')
					{
						$t = $t.replace('//#30','//')
						$global:jcl_create += $t
					}
				}
			}
		}
	}
	#return $jcl_create
}

function ABEND ($code,$reason){
	Write-Host Executing exit command with exit code $code
	Write-Host $reason
	exit $code
	Write-Host Script End
}


<###############    Main fucntion   ########################>

$global:Default_volume = "D:\gowrishankar.p\Bat_script\"
$global:Folder = $global:Default_volume +$inp
$template_file = $global:Default_volume + "AC1\TEST\DATA\chipseft_trigger_template.jcl"
$global:arr = @()
$global:jcl_create = @()
$global:indicator = "No"
$file_out = $global:Default_volume + "Dynamic_jcl_output.txt"


$i = 10
do
{
  #"`$i = $i"
  $a = $global:Folder+"\"+$i+"STG"						#passing C*STG base file
  $g = GDG $a
  Write-Output $g
  $i = $i + 10
} while($i -le 30) 										#Incremental based on the base name

if ($global:indicator -eq "Yes")
{
	$template = Get-Content -Path $template_file
	foreach ($t in $template)
	{
		if ($t.Substring(0,3) -ne '//*' -And $t.Substring(0,9) -eq '//DD@DD10')
		{
			break
		}			
						
		$global:jcl_create += $t
	}
	Write-Output "Staging file generation recieved"
	process
	$global:jcl_create += "//* Dynamic creation of file process ends"
	
	Out-File -Filepath $file_out 	# Create a output file 
	$global:jcl_create > $file_out
	
	<#
	foreach($j in $global:jcl_create)
	{
		Write-Output $j
	}
	#>
}
else{
	Write-Output "No More Staging files recieved"
	ABEND 4 "No More Staging files recieved"
}



