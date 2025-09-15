$proc = Start-Process -PassThru -NoNewWindow -Wait -FilePath (Join-Path -Path $env:RCBATCHDIR "Submit") `
    -ArgumentList "-File=`"$PSScriptRoot\GDG2.JCL`"", "-LogLevel=ERROR"
