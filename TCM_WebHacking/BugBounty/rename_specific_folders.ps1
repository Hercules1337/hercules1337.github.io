# Define the base directory
$baseDirectory = "G:\Github\Projects\TCM_WebHacking\BugBounty"

# Ensure the base directory exists
if (-not (Test-Path $baseDirectory -PathType Container)) {
    Write-Host "Error: Directory '$baseDirectory' not found!" -ForegroundColor Red
    exit 1
}

# Define the custom order (folder names -> numbers)
$folderOrder = @(
    "Web Application Security",    # 1
    "Before We Attack",    # 2
    "Lab Build",    # 3
    "Web Application Technologies",    # 4
    "Reconnaissance and Information Gathering",    # 5
    "Authentication and Authorization Attacks",    # 6
    "Injection Attacks",    # 7
    "Automated Tools",    # 8
    "Other Common Vulnerabilities",    # 9
    "Reporting",    # 10
    "Evasion Techniques",    # 11
    "Wrapping up"     # 12
)

# Check if the custom folder names exist in the Bugbounty directory
foreach ($folderName in $folderOrder) {
    $folderPath = Join-Path -Path $baseDirectory -ChildPath $folderName
    if (-not (Test-Path $folderPath -PathType Container)) {
        Write-Host "Error: Folder '$folderName' not found in '$baseDirectory'!" -ForegroundColor Red
        exit 1
    }
}

# Rename the folders with a numerical prefix (01 to 12)
for ($i = 0; $i -lt $folderOrder.Count; $i++) {
    $folderName = $folderOrder[$i]
    $folderPath = Join-Path -Path $baseDirectory -ChildPath $folderName
    $newName = "{0:D2}-$folderName" -f ($i + 1)  # Formats the number as 01, 02, ..., 12
    Rename-Item -Path $folderPath -NewName "$baseDirectory\$newName"
    Write-Host "Renamed '$folderName' to '$newName'" -ForegroundColor Green
}

Write-Host "Folders renamed and organized successfully!" -ForegroundColor Green
