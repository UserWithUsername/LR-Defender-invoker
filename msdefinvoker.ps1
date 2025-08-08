<#
.SYNOPSIS
    This script let you invoke RAW script which you type in command parameter in Microsoft Defender Live Response.

.AUTHOR
    @usrwithusername
    https://x.com/usrwithusername
    https://github.com/UserWithUsername

.VERSION
    0.0.1

#>

param (
    [Parameter(Mandatory = $true)]
    [string]$commandIn
)

try {
    function Restore-Command($commandIn) {
        $mapping = @{
            '#D#'  = '$'
            '#LP#' = '('
            '#RP#' = ')'
            '#S#'  = ';'
            '#B#'  = '!'
            '#P#'  = '|'
            '#Q#'  = '"'
        }

        foreach ($key in $mapping.Keys) {
            $commandIn = $commandIn -creplace [regex]::Escape($key), $mapping[$key]
        }
        Write-Host "[ DEBUG ] Restored command: $commandIn"
        return $commandIn
    }
    
    $sanitizedCommand = Restore-Command $commandIn
    Write-Host "Executing command: $sanitizedCommand"
    $output = Invoke-Expression $sanitizedCommand
    Write-Host $output
    Write-Host "[ OK ] Execution complete."
}
catch {
    Write-Host "[ WARNING ] Error: $($_.Exception.Message)"
}
