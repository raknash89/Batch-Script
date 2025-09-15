$regex = ''
#$list = @()
#$joblist = @('GDG,C:/XX/','PSFB,D:/YY/','PSVB,D:/YY/')

$content = Get-Content -Path @("D:\gowrishankar.p\Bat_script\file_list_empty.txt")  # IBM job submit tempate

$jcl = 'D:\gowrishankar.p\Bat_script\empty_jcl.jcl'					 # Raincode  FTPied PDS file path
Out-File -Filepath $jcl

#Header write
"//JOBEMPTY  JOB (123),'RAINCODE JOB',CLASS=C,MSGCLASS=S,MSGLEVEL=(1,1)," >> $jcl
"//       NOTIFY=&SYSUID" >> $jcl
"//*"  >> $jcl

$count = 0
$stepcount = 0
$dd_count = 0
foreach($file in $content)
{
	if ($count -eq 0) 
	{
		$stepcount = $stepcount + 1
		"//STEP$stepcount  EXEC PGM=IEFBR14" >> $jcl
		"//SYSPRINT DD SYSOUT=*" >> $jcl
		"//SYSOUT   DD SYSOUT=*" >> $jcl
		"//SYSDUMP  DD SYSOUT=*" >> $jcl
	}
	#Write-Output $file
	#$file >> $jcl
	$dd_count = $dd_count + 1
	$unit = 'SYSDA'
	
	if ($file.Contains(".TAPE."))
	{
		$unit = 'TAPEA'
		#Write-Output $file
		"//DD$dd_count   DD DSN=$file," >> $jcl
		"//            DISP=(NEW,CATLG,DELETE)," >> $jcl
		"//            DCB=(DSORG=PS,RECFM=FB,LRECL=10,BLKSIZE=100)," >> $jcl
		"//            UNIT=$unit" >> $jcl
	}
	else
	{
		"//DD$dd_count   DD DSN=$file," >> $jcl
		"//            DISP=(NEW,CATLG,DELETE)," >> $jcl
		"//            SPACE=(TRK,(1,1),RLSE),UNIT=$unit," >> $jcl
		"//            DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=800)" >> $jcl
	}
	$count = $count + 1
	
	if ($count -ge 50) 
	{
		$count = 0
		$dd_count = 0
		"//*        " >> $jcl
	}
}

"//*        " >> $jcl



