# A quicker way to download an image from the web using PowerShell
# Usage: .\curlimg.ps1 -url "https://www.example.com/image.jpg" -output "image.jpg"

# Define the script parameters
param
(
    [string]$url,  # The URL of the image to download
    [string]$output  # The output file to save the image to
)

# If there are not exactly 2 arguments, or if the URL or output file is empty, print usage and exit
if ($PSBoundParameters.Count -ne 2 -or $url -eq "" -or $output -eq "")
{
    Write-Host "Usage: $PSCommandPath <image_url> <output_file>"
    exit 1
}

# Check if the output file already exists
if (Test-Path $output)  # If the output file already exists
{
    $response = Read-Host "The output file '$output' already exists. Do you want to overwrite it? (Y/N)"

    # If the user does not confirm, ask if user wants to download as a renamed file (the same name with a number appended)
    if ($response -ne "Y" -and $response -ne "y")  # If the user does not confirm to overwrite the existing file
    {
        $response = Read-Host "Do you want to download the image as a renamed file? (Y/N)"

        if ($response -eq "Y" -or $response -eq "y")  # If the user confirms to download as a renamed file
        {
            # Extract base name, extension, and initial increment
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($output)  # Get the file name without the extension using .NET
            $extension = [System.IO.Path]::GetExtension($output)  # Get the file extension using .NET
            $i = 0

            # Regex to check if the file name already ends with _<number>
            $regex = [regex] '_(\d+)$'  # Match the pattern _<number> at the end of the string

            # If the base name ends with _<number>, extract it and adjust the base name and increment
            if ($regex.IsMatch($baseName))
            {
                $match = $regex.Match($baseName)  # Get the matched pattern
                $i = [int]$match.Groups[1].Value  # Get the number from the matched pattern
                $baseName = $baseName.Substring(0, $baseName.Length - $match.Value.Length)  # Remove the matched pattern from the base name
            }

            # Find a unique file name
            do
            {
                $newOutput = "${baseName}_$i$extension"  # Construct the new file name with the incremented number
                $i++  # Increment the number
            } while (Test-Path $newOutput)  # Check if the new file name already exists

            $output = $newOutput  # Set the new output file name

            Write-Host "Saving the image as '$output' instead."
        }
        else  # If the user does not want to download as a renamed file, exit without downloading
        {
            Write-Host "Exiting without downloading the image."
            exit 1
        }
    }
    else  # If the user confirms to overwrite the existing file, print a message
    {
        Write-Host "Overwriting the existing file..."
    }
}

# Download the image from the URL to the output file
Invoke-WebRequest -Uri "$url" -OutFile $output

# Check if the download was successful
if ($? -eq $false)  # If the last command failed
{
    # Print an error message and exit with an error code
    Write-Error "Error downloading image from '$url' to '$output'.  Please double check the URL and the output file path and try again."
    exit 1
}

# Print success message
$currentDir = Get-Location  # Get the current directory
Write-Host "`nImage downloaded successfully from '$url' to '$output' in '$currentDir'.`n"

# Exit with success code
exit 0
