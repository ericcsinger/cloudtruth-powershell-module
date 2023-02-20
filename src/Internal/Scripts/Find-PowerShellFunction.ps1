
<#PSScriptInfo

.VERSION 0.0.0.0

.GUID 5ee67704-3ce8-4b9b-8196-fe7071e6f056

.AUTHOR Eric C. Singer

.COMPANYNAME

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 tbd 

#> 
#######################################
#START: Parameters
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({Test-Path -Path $_ -PathType "Container"})]
    [string]$Path
)
#END: Parameters
#######################################

#######################################
#START: Variables

$Section = $null
$Section = "Variables"

$CommandName = $null
$CommandName = $($MyInvocation.MyCommand.Name)

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable RegexFunctionNamePattern"

$RegexFunctionNamePattern = $null
$RegexFunctionNamePattern = 'function\s*?\S.*?\s*?\{'

If ($PSBoundParameters.ContainsKey('Debug') -eq $true) {
    Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: RegexFunctionNamePattern = ""$($RegexFunctionNamePattern)"""
}

#END: Variables
#######################################

#######################################
#START: Search for PowerShell Files

$Section = $null
$Section = "Search for PowerShell Files"

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable SearchForPowerShellFilesSplat"
Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating a Splat to search for all PowerShell files"

$SearchForPowerShellFilesSplat = $null
$SearchForPowerShellFilesSplat = @{
    ErrorAction = "Stop"
    File = $true
    Filter = "*.ps1"
    Path = $Path
    PipelineVariable = "FunctionFile"
    Recurse = $true
}

If ($PSBoundParameters.ContainsKey('Debug') -eq $true) {
    Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SearchForPowerShellFiles = $($SearchForPowerShellFilesSplat | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
}

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable SearchForPowerShellFiles"
Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Executing a search for PowerShell files and storing in SearchForPowerShellFiles variable"

$SearchForPowerShellFiles = $null
$SearchForPowerShellFiles = Get-ChildItem @SearchForPowerShellFilesSplat

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable SearchForPowerShellFilesCount"
Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Count how many PowerShell files we found."

$SearchForPowerShellFilesCount = $null
$SearchForPowerShellFilesCount = $SearchForPowerShellFiles | Measure-Object -ErrorAction Stop | Select-Object -ExpandProperty Count

If ($SearchForPowerShellFilesCount -ge 1) {
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: We found a total of ""$($SearchForPowerShellFilesCount)"" PowerShell files"

    If ($PSBoundParameters.ContainsKey('Debug') -eq $true) {
        Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SearchForPowerShellFiles = $($SearchForPowerShellFiles | Select-Object -Property FullName -ErrorAction Stop | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
    }
}
Else {
    Write-Warning -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: We found ""$($SearchForPowerShellFilesCount)"" PowerShell files at path ""$($SearchForPowerShellFilesSplat.Path)"", breaking out of script"
    ; break
}

#END: Search for PowerShell Files
#######################################

#######################################
#START: Get all PowerShellFiles Contents

$Section = $null
$Section = "Get all PowerShellFiles Contents"

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable GetPowerShellFilesContents"
Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: --- STARTING FOREACH through each PowerShell file in the `$SearchForPowerShellFiles variable" 
$GetPowerShellFilesContents = $null
$GetPowerShellFilesContents = Foreach ($PowerShellFile in $SearchForPowerShellFiles) {
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: ### BEGIN LOOP of variable `$SearchForPowerShellFiles" 

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Current PowerShell file ""$($PowerShellFile.FullName)"""

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable GetContentSplat" -Verbose:$EnableVerbose
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating a splat to get the content of the file." -Verbose:$EnableVerbose

    $GetContentSplat = $null
    $GetContentSplat = @{
        Path = $PowerShellFile.FullName
        Raw = $true
        ErrorAction = "Stop"
    }

    If ($PSBoundParameters.ContainsKey('Debug') -eq $true) {
        Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: GetContentSplat = $($GetContentSplat | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
    }

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable GetContentSplat" -Verbose:$EnableVerbose
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Getting the contents of the file ""$($GetContentSplat.Path)""." -Verbose:$EnableVerbose

    $GetContent = $null
    $GetContent = Get-Content @GetContentSplat

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable GetContentCharsCount" -Verbose:$EnableVerbose
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Count how many chars we found." -Verbose:$EnableVerbose

    $GetContentCharsCount = $null
    $GetContentCharsCount = $GetContent | Measure-Object -Character -ErrorAction Stop | Select-Object -ExpandProperty Characters -ErrorAction Stop

    If ($GetContentCharsCount -ge 1) {
        Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: We found a total of ""$($GetContentCharsCount)"" chars in the file"
        Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Outputting object back to `$GetPowerShellFilesContents variable"
        [ordered]@{
            PowerShellFile = $PowerShellFile
            Content = $GetContent
        }
        
    }
    Else {
        Write-Warning -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: We found ""$($GetContentCharsCount)"" chars in file at path ""$($GetContentSplat.Path)"", will not create object for this file"
    }
    
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: ### END LOOP of variable `$SearchForPowerShellFiles" 
}
Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: --- ENDING FOREACH through each PowerShell file in the `$SearchForPowerShellFiles variable" 

#END: Get all PowerShellFiles Contents
#######################################

#######################################
#START: Parse PowerShell Content for Function Pattern

$Section = $null
$Section = "Parse PowerShell Content for Function Pattern"

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable ParsePowerShellFilesContents"
Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: --- STARTING FOREACH through each PowerShell file in the `$GetPowerShellFilesContents variable" 

$ParsePowerShellFilesContents = $null
$ParsePowerShellFilesContents = Foreach ($PowerShellFilesContent in $GetPowerShellFilesContents) {
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: ### BEGIN LOOP of variable `$GetPowerShellFilesContents" 

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable PowerShellFile"
    $PowerShellFile = $null
    $PowerShellFile = $PowerShellFilesContent.PowerShellFile

    If ($PSBoundParameters.ContainsKey('Debug') -eq $true) {
        Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: PowerShellFile = $($PowerShellFile | Select-Object -Property FullName -ErrorAction Stop | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
    }

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable Content"
    $Content = $null
    $Content = $PowerShellFilesContent.Content

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$RegexPatternMatches"
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Evaluating PowerShell file ""$($PowerShellFile.FullName)"" contents with regex pattern ""$($RegexFunctionNamePattern)"""
    
    $RegexPatternMatches = $null
    $RegexPatternMatches = $Content | Select-String -Pattern $RegexFunctionNamePattern -AllMatches -ErrorAction Stop | Select-Object -ExpandProperty Matches -ErrorAction Stop | Select-Object -ExpandProperty Value -ErrorAction Stop

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable RegexPatternMatchesCount" 
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Count how many Regex Patterns we found." 

    $RegexPatternMatchesCount = $null
    $RegexPatternMatchesCount = $RegexPatternMatches | Measure-Object -ErrorAction Stop | Select-Object -ExpandProperty Count -ErrorAction Stop

    If ($RegexPatternMatchesCount -ge 1) {
        Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: We found a total of ""$($RegexPatternMatchesCount)"" regex pattern matches in the file"
        Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Outputting object back to `$ParsePowerShellFilesContents variable"
        [pscustomobject][ordered]@{
            PowerShellFile = $PowerShellFile | Select-Object -Property BaseName,FullName,DirectoryName,Name,Extension -ErrorAction Stop
            FunctionNames = $RegexPatternMatches | ForEach-Object -Process {
                $($PSItem) -replace 'function\s*' -replace '\s* \{'
            }
        }
        
    }
    Else {
        Write-Warning -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: We found ""$($RegexPatternMatchesCount)"" regex pattern matches in file at path ""$($PowerShellFile.FullName)"""
    }
    
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: ### END FOREACH of variable `$GetPowerShellFilesContents" 
}
Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: --- ENDING loop through each PowerShell file in the `$GetPowerShellFilesContents variable" 

#END: Parse PowerShell Content for Function Pattern
#######################################

#######################################
#START: Return Output

$Section = $null
$Section = "Return Output"

$ParsePowerShellFilesContents 

#START: Return Output
#######################################