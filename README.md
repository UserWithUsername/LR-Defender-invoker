# Microsoft Defender LiveResponse RAW script invoker

## Background

Microsoft Defender LiveResponse allows you to run Windows PowerShell scripts which you have to first upload and than run. Also there are some predefined commands but sometimes it's not enough. Main purpose to create this project was to be able to test parts of scripts to make sure it's generating desired output (sometimes LiveResponse console showing PSObject not same way parsed as on desktop version).

## Get started

In order to use it, you have to upload script into your Microsoft Defender LiveResponse library (without providing any parameter) and than invoke it with custom command / script.

## How it works

By default, you are not allowed to type in LiveResponse console characters like: ; & | ! $ ( )
As you see, these are pretty common ones that is hard to live without. Also there is an issue when you want to place double quote inside already quoted parameter. In order to workaround this, this script replacing not allowed characters with other placeholders like:
```
        $mapping = @{
            '#D#'  = '$'
            '#LP#' = '('
            '#RP#' = ')'
            '#S#'  = ';'
            '#B#'  = '!'
            '#P#'  = '|'
            '#Q#'  = '"'
        }
```
## Usage

You have to run it from LiveResponse console and provide single parameter which is your script / cmdlet. The command which is your single parameter must have at beginning double and single quote and at the end single and dobule quote. Examples
```
Before modification: $PSVersionTable.PSVersion
C:\> run msdefinvoker.ps1 "'#D#PSVersionTable.PSVersion'"
Output: 5.1.20348.3932

Before modification: Get-Date | Select-Object DateTime
C:\> run msdefinvoker.ps1 "'Get-Date #P# Select-Object DateTime'"
Output: @{DateTime=Friday, August 8, 2025 7:51:42 PM}

Before modification: $env:APPDATA
C:\> run msdefinvoker.ps1 "'#D#env:APPData'"
Output: C:\Windows\system32\config\systemprofile\AppData\Roaming

Before modification: Get-Process | ForEach-Object { Write-Host "Process '$($_.ProcessName)' (ID: $($_.Id)) is using $("{0:N2}" -f ($_.WorkingSet / 1MB)) MB of memory." }
C:\> run msdefinvoker.ps1 "'Get-Process #P# ForEach-Object { Write-Host #Q#Process ''#D##LP##D#_.ProcessName#RP#'' #LP#ID: #D##LP##D#_.Id#RP##RP# is using #D##LP##Q#{0:N2}#Q# -f #LP##D#_.WorkingSet / 1MB #RP##RP# MB of memory.#Q# }'"
Output:
Process 'svchost' (ID: 6984) is using 12.40 MB of memory.
Process 'System' (ID: 4) is using 0.11 MB of memory.
Process 'taskhostw' (ID: 5392) is using 14.45 MB of memory
...
```
## Precaution words

Make sure that you always following best practices for scripts executions in Microsoft Defender LiveResponse.
