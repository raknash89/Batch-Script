param($inp)
"Recieve $inp"
$line = @('123,Hello','345,ALSO','789,Hello')
#${my variable} = 'Hello'
$arr = @('Hello','ALSO')
foreach($l in $line)
{
    $sp = $l.split(',')
    $file = $sp[0]
    $app = $sp[1]
    if ($arr -contains $app )
    {
        ${my variable} += $app
    }
}
$out_path = 'D:\gowrishankar.p\Bat_script\invoke_out.txt'
${my variable} > 'D:\gowrishankar.p\Bat_script\invoke_out.txt'
