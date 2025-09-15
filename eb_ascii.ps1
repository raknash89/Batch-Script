


#Model 1
$SourceFileName = 'D:\gowrishankar.p\Python Script\mf_input\MF.TEST.DATA.EBCID.txt'
$outpath_ascii = 'D:\gowrishankar.p\Python Script\mfes_input\testing.txt'
$outpath_ebcdic = 'D:\gowrishankar.p\Python Script\mfes_input\testing1.txt'


$Buffer = Get-Content $SourceFileName -Encoding byte
Write-Host "buffer byte read $Buffer"

$Encoding_ebcdic = [System.Text.Encoding]::GetEncoding("IBM037")
$String_ebcdic = $Encoding_ebcdic.GetString($Buffer)
#$String_ebcdic | Out-File -FilePath $outpath_ascii
Write-Host "Convert ASCII $String_ebcdic"


#Convert the ASCII to EBCDIC data

$inputString = "DELETE INTO 001"
$asciiEncoding = [System.Text.Encoding]::ASCII
$ebcdicEncoding = [System.Text.Encoding]::GetEncoding("IBM037")
# Convert the input string from ASCII to EBCDIC
$ebcdicBytes = [System.Text.Encoding]::Convert($asciiEncoding, $ebcdicEncoding, $asciiEncoding.GetBytes($inputString))
$ebcdicString = $ebcdicEncoding.GetString($ebcdicBytes)


# Print the output string
Write-Host "check $ebcdicBytes"
Write-Host $ebcdicString

<#
#Get the type of the sting 

$str = "ShellGeek"
$str.GetType()

# converting string to bytes stream
$bytesArr = [System.Text.Encoding]::UTF8.GetBytes($str)
Write-Host "byte $bytesArr"
# Get the data type of the variable
$bytesArr.GetType()
#>


<#
while (!$io_file.EndOfStream){
	$content = $io_file.ReadLine()
	Write-Output $content
}
#>

#$io_file.close()




<# 
#READ Line by line conversion

# Set input and output file paths
$inputFilePath = "D:\gowrishankar.p\Python Script\mf_input\MF.TEST.DATA.EBCID.txt"
#$outputFilePath = "C:\output_file.txt"

# Create EBCDIC encoding object
$ebcdicEncoding = [System.Text.Encoding]::GetEncoding("IBM037")

# Open input file for reading with byte encoding
$inputFile = New-Object System.IO.StreamReader($inputFilePath, $ebcdicEncoding)

# Open output file for writing with ASCII encoding
#$outputFile = [System.IO.File]::CreateText($outputFilePath)

# Loop through input file and convert each line from EBCDIC to ASCII
while (!$inputFile.EndOfStream) {
    $line = $inputFile.ReadLine()
    #$asciiLine = [System.Text.Encoding]::ASCII.GetString($line)
	Write-Output $line
	#break
	#Write-Output $asciiLine
    #$outputFile.WriteLine($asciiLine)
}

# Close input and output files
$inputFile.Close()
#$outputFile.Close()

#>

<#
#Model 2
# Set input and output file paths
$inputFilePath = "D:\gowrishankar.p\Python Script\mf_input\MF.TEST.DATA.EBCID.txt"
#$inputFilePath = "D:\gowrishankar.p\Python Script\mf_input\MF.TEST.DATA.ASCII.txt"

#$outputFilePath = "C:\output_file.txt"

# Create EBCDIC encoding object
$ebcdicEncoding = New-Object System.Text.ASCIIEncoding

# Read EBCDIC file content
$inputFileContent = Get-Content -Path $inputFilePath -Encoding Byte

# Convert EBCDIC to ASCII
#$asciiContent = $ebcdicEncoding.GetString($inputFileContent)
$String = [System.Text.Encoding]::GetEncoding("IBM037")
$asciiContent = $String.GetString($inputFileContent)

Write-Output $asciiContent
# Write ASCII content to output file
#Set-Content -Path $outputFilePath -Value $asciiContent -Encoding ASCII

#>

<#
#Model 3
# Set input and output file paths
$inputFilePath = [io.fileinfo]"D:\gowrishankar.p\Python Script\mf_input\MF.TEST.DATA.EBCID.txt"
#$outputFilePath = "C:\output_file.txt"

# Create EBCDIC encoding object
$ebcdicEncoding = New-Object System.Text.ASCIIEncoding

# Open input file for reading
$inputFile = [System.IO.File]::OpenText($inputFilePath)

# Open output file for writing
#$outputFile = [System.IO.File]::CreateText($outputFilePath)

# Loop through input file and convert each line from EBCDIC to ASCII
while ($line = $inputFile.ReadLine()) {
    $asciiLine = $ebcdicEncoding.GetString([byte[]][char[]]$line)
	Write-Output $asciiLine
    #$outputFile.WriteLine($asciiLine)
}

# Close input and output files
$inputFile.Close()
#$outputFile.Close()
#>

<#
#Model 4
#$SourceFileName = [io.fileinfo]'D:\gowrishankar.p\Python Script\mf_input\MF.TEST.DATA.EBCID.txt'
$reader= $SourceFileName.OpenRead()
$len = $reader.Length
$buffer = New-Object byte[] $len
$reader.Read($buffer,0,$len)
Write-Output $reader
$enc=[System.Text.Encoding]::GetEncoding(37)
Write-Output $enc
$enc1 = $enc.GetString($enc.GetBytes($buffer))
Write-Output $enc1
#>

#foreach($s in $string){
	#Write-Output $s
#}
<#
Write-Output $String.Substring(1,30)
Write-Output $String.Indexof('&') 
#>
