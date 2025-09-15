param($esp_file,$cawla_file,$output)
$timer = Measure-command { get-process }
#$esp_file = 'D:\gowrishankar.p\Bat_script\ps_input\ESP.txt'
#$cawla_file = 'D:\gowrishankar.p\Bat_script\ps_input\Nov20-27.csv'
#$output = 'D:\gowrishankar.p\Bat_script\compare_2.csv'
if(!(test-path $esp_file)){
    "Error!! Please provide valid file path $esp_file"
    exit
}
if(!(test-path $cawla_file)){
    "Error!! Please provide Raincode Sysout CSV file path $cawla_file"
    exit
}


$data = Import-csv -path $cawla_file -Delimiter ',' 
$cawla_job = $data | Select-Object Job_Name,Application,Date,"Start Time","End Time",Duration,CODE,RC | sort Job_Name
#$cawla_job

#break
$header = "Job_Name" +","+	"Application" +","+	"Date" +","+ "Start Time" +","+	"End Time"	+","+ "Duration" +","+	"CODE"	+","+ "RC" +","+ "Exec time(ESP)" +","+ "Post time(ESP)" +","+ "Total time(ESP)"
$header | Out-file -FilePath $output -Encoding utf8

function validation
{
    param($esp_data,$job,$formatdate)
    $result = ''
    foreach($i in $esp_data)
    {
    $i = $i -replace '\s+', ' '
    $split = $i -split " "
    $idx = 0
    foreach($sp in $split){
        if($sp.Contains($formatdate))
        {
            $exec_time = $split[$idx+1]
            $post_time = $split[$idx+2]
            $tot_time  = $split[$idx+3]
            if($exec_time.Contains('M') -or $post_time.Contains('M') -or $tot_time.Contains('M'))
            {
                $exec_time = $exec_time -replace('M',":")
                $post_time = $post_time -replace('M',":")
                $tot_time = $tot_time -replace('M',":")
            }
            if($exec_time.Contains('H') -or $post_time.Contains('H') -or $tot_time.Contains('H'))
            {
                $exec_time = $exec_time -replace('H',":") 
                $post_time = $post_time -replace('H',":") 
                $tot_time = $tot_time -replace('H',":")
                
                if(!$exec_time.Contains('-')) { $exec_time = $exec_time + ":00" }
                if(!$post_time.Contains('-')){ $post_time = $post_time + ":00" }
                if(!$tot_time.Contains('-')) { $tot_time = $tot_time + ":00" }
            }
            $result = $exec_time +","+ $post_time +","+ $tot_time
            #$result = [PSCustomObject]@{ esp_exec = $exec_time; esp_post = $post_time ; esp_tot = $tot_time}
        }
        $idx += 1
        }
    }
    return $result
}

$esp_data = ''
$job_prev = ''
$arr = @()
$br_cnt = 0
foreach($line in $cawla_job)
{
    $job = $line.Job_Name
    $dt = $line.Date
    $dateobject = get-date $dt
    $br_cnt += 1
    $formatdate = $dateobject.ToString("ddMMMyy").ToUpper()
    "Processing line- $br_cnt : $job $formatdate"
    if($job_prev -ne $job)
    {
        "Reading from soruce esp"
        $esp_data = Get-content -path $esp_file | Select-String -Pattern $job -SimpleMatch
    }
    $response = validation $esp_data $job $formatdate
    $job_prev = $line.Job_Name
    $temp = $line.Job_Name +","+ $line.Application +","+ $line.Date +","+ $line.'Start Time'+","+ $line.'End Time' +","+ $line.Duration +","+ $line.CODE +","+ $line.RC + "," + $response
    #$temp = [PSCustomObject]@{ job = $line.Job_Name; app = $line.Application; date = $line.Date; start =$line.'Start Time'; end = $line.'End Time'; duration = $line.Duration; code = $line.CODE; rc = $line.RC; response = $response  }
    $arr += $temp
    #if($br_cnt -gt 10) {break}
}


#$arr | ForEach-Object { $_ | Select-Object * }
#$arr | Format-Table -AutoSize
#$arr | Sort-Object -Property date
"Export the data into csv file"
$arr | Add-content $output -Encoding UTF8 

$timer
