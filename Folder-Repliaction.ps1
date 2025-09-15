param($copy)

if($copy.Length -eq 0)
{
   [uint16]$copy = Read-Host -Prompt "How many Groups want to replicate in Numbers"
}
$copy = $copy + 1
$base_path = 'D:\gowrishankar.p\Bat_script\AC1\Group1'
$old = 'Group1'
$count = 1

while($count -le $copy)
{
    $new = "Group" + $count
    $folder_Rename = $base_path -replace $old, $new
    #$folder_Rename

    If(test-path -path $folder_Rename)
    {
        "Folder are already created $folder_Rename"
    }
    else
    {
        "Replicating for $folder_Rename"
        #Repliacate the Groups
        Copy-Item -Path $base_path -Destination $folder_Rename -recurse

        $copied_files = Get-ChildItem -Path $folder_Rename -File -Recurse
        foreach($cp in $copied_files)
        {
            $split_file = Split-Path -Path $cp.FullName -Leaf -Resolve
            
            # Content data replace
            $fileContents = Get-Content -Path $cp.FullName -Raw
            #$split_file
            if($split_file -like "*IND_XX*") 
            { 
                "Match $split_file "
                $newContents = $fileContents -replace $old, $new.ToUpper() 
            }
            else { 
                $newContents = $fileContents -replace $old, $new }
            
            $newContents | Set-Content -Path $cp.FullName

            # File and folder name replace
            
            #$file_replace
            $file_replace = $split_file -replace $old, $new
            Rename-Item -Path $cp.FullName -NewName $file_replace
        }
        
    }
    $count += 1
}





