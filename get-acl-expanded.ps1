#Option-1
#$ACL = get-acl "D:\gowrishankar.p\Bat_script\cmd-copy" -Recurse | Select path -ExpandProperty Access | Format-Table -Autosize 

#Option-2
#$content = Get-Content -Path @("D:\gowrishankar.p\Bat_script\get-acl-folder-list.txt") 
#foreach($folderPath in $content)
#{
    $Items = (Get-ChildItem "D:\gowrishankar.p\Bat_script/" -Recurse | Where { $_.PSIsContainer } | select fullname | %{$_.fullname.trim()})
    #$Items = (Get-ChildItem $folderPath -Recurse | Where { $_.PSIsContainer } | select fullname | %{$_.fullname.trim()})
    $Path = "D:\gowrishankar.p\Bat_script\ACLs.csv"

    $Table = @()
    $Record = [ordered]@{
    "Directory" = ""
    "Owner" = ""
    "FileSystemRights" = ""
    "AccessControlType" = ""
    "IdentityReference" = ""
    "IsInherited" = ""
    "InheritanceFlags" = ""
    "PropogationFlags" = ""

    }

    Foreach ($Item in $Items)
    {

    $ACL = (Get-Acl -Path $Item)

    $Record."Directory" = $ACL.path | %{$_.trimstart("Microsoft.PowerShell.Core\FileSystem::")}
    $Record."Owner" = $ACL.Owner

    Foreach ($SItem in $ACL.access)
    {
    $Record."FileSystemRights" = $SItem.FileSystemRights
    $Record."AccessControlType" = $SItem.AccessControlType
    $Record."IdentityReference" = $SItem.IdentityReference
    $Record."IsInherited" = $SItem.IsInherited
    $Record."InheritanceFlags" = $SItem.InheritanceFlags
    $Record."PropogationFlags" = $SItem.PropagationFlags


    $objRecord = New-Object PSObject -property $Record
    $Table += $objrecord
    }
    }
#}
$Table | Export-Csv -Path $Path -NoTypeInformation

