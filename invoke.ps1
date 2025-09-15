$start = get-date

start-sleep -Seconds 5

$end = get-date

$res = $end - $start
"First program"

#invoke-expression "D:\gowrishankar.p\Bat_script\invoke_2.ps1 $res" 
#& "D:\gowrishankar.p\Bat_script\invoke_2.ps1"
#Start-process -FilePath "D:\gowrishankar.p\Bat_script\invoke_2.ps1"
invoke-expression "& `"D:\gowrishankar.p\Bat_script\invoke_2.ps1`"  -inp SET"
"First End program"
"Second program starts"
invoke-expression "D:\gowrishankar.p\Bat_script\invoke_3.ps1"
"second program ends"
