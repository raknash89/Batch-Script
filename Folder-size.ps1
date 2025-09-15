(gci "D:\gowrishankar.p" | measure Length -s).sum / 1Gb

"{0:N2} GB" -f ((gci "D:\gowrishankar.p" | measure Length -s).sum / 1Gb)

# Specify the path to the folder you want to check
# Specify the path to the folder you want to check
$folderPath = "D:\gowrishankar.p"

# Get the total size of all items in the folder (including subfolders)
$folderSizeBytes = (Get-ChildItem -Path $folderPath -File -Recurse | Measure-Object -Property Length -Sum).Sum

# Convert the size to GB
$folderSizeGB = [math]::Round(($folderSizeBytes / 1GB), 2)

# Display the folder size in GB
Write-Host "Folder Size: $folderSizeGB GB"
