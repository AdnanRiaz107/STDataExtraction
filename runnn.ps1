# PowerShell script to call Python script for conversion

#!/usr/bin/env pwsh

# Try to locate Python executable
$pythonExecutable = Get-Command "python" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Definition
if (-Not $pythonExecutable) {
    Write-Host "Could not find python, please install it" -ForegroundColor Red
    Exit 1
} else {
    Write-Host "Using python from $pythonExecutable"
}

# Path to your Python script for conversion
$pythonScript = "C:\Users\adnan\Desktop\code\script\ps10-cli.py"

# Input directory containing .tcPOU files
$inputDirectory = "C:\Users\adnan\Desktop\code\tcopen-tcpou"
#"C:\Users\adnan\Desktop\code\import"

# Output directory for .st files
$outputDirectory = "C:\Users\adnan\Desktop\code\export"


try {
    # Check if the input directory exists
    if (Test-Path $inputDirectory -PathType Container) {
        # Get all .tcPOU files in the input directory
        $tcPOUFiles = Get-ChildItem -Path $inputDirectory -Filter "*.tcPOU"

        # Check if there are any files to process
        if ($tcPOUFiles.Count -gt 0) {
            # Loop through each .tcPOU file and call the Python script
            foreach ($file in $tcPOUFiles) {
                # Capture the output and error of the Python script
                $argumentList = "`"$pythonScript`" $($file.FullName) -o $outputDirectory"
                $process = Start-Process -FilePath $pythonExecutable -ArgumentList $argumentList -PassThru -NoNewWindow
                $handle = $process.Handle
                $process.WaitForExit()
                $exitCode = $process.ExitCode
                if (-Not ($exitCode -eq 0)) {
                    Write-Host " Run failed! Exited with error code $exitCode." -ForegroundColor Red
                  }
            }

            
        } else {
            Write-Host "No .tcPOU files found in the input directory."
        }
    } else {
        Write-Host "Input directory not found: $inputDirectory"
    }
Write-Host "Conversion complete" -ForegroundColor Green
} catch {
    Write-Host "Error: $_"
}
