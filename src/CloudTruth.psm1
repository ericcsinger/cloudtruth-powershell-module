#######################################
#START: Parameters
[CmdletBinding()]
param (
    [Parameter(Mandatory = $false, Position = 0)]
    [bool]$EnableVerbose = $false,

    [Parameter(Mandatory = $false, Position = 1)]
    [bool]$EnableDebug = $false
)
#END: Parameters
#######################################

#######################################
#START: Variables
$Section = $null
$Section = "Variables"

$CommandName = $null
$CommandName = $($MyInvocation.MyCommand.Name)

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable CloudTruth" -Verbose:$EnableVerbose
$CloudTruth = $null
$CloudTruth = [ordered]@{
    DebuggingCommands = [ordered]@{}
    APILoginContext = [ordered]@{
        All = [ordered]@{}
        Default = [ordered]@{}
    }
    Internal = [ordered]@{
        Directory = "$($PSScriptRoot)\Internal"
        Configurations = [ordered]@{
            Directory = "$($PSScriptRoot)\Internal\Configurations"
            Files = [ordered]@{
                DefaultUserSettings = [ordered]@{name = "DefaultUserSettings"; Path = "$($PSScriptRoot)\Internal\Configurations\DefaultUserSettings.json"}
            }
        }
        Functions = [ordered]@{
            Directory = "$($PSScriptRoot)\Internal\Functions"
        }
        Scripts = [ordered]@{
            Directory = "$($PSScriptRoot)\Internal\Scripts"
            Files = [ordered]@{
                "Find-PowerShellFunction" = [ordered]@{name = "Find-PowerShellFunction"; Path = "$($PSScriptRoot)\Internal\Scripts\Find-PowerShellFunction.ps1"}
            }
        }
    }
    Public = [ordered]@{
        Directory = "$($PSScriptRoot)"
        Functions = [ordered]@{
            Directory = "$($PSScriptRoot)\Functions"
        }
    }
    UserProfile = [ordered]@{
        Directory = "$(Split-Path -Path $PROFILE)"
        CloudTruth = [ordered]@{
            Directory = "$(Split-Path -Path $PROFILE)\CloudTruth"
            Files = [ordered]@{
                Settings = [ordered]@{name = "Settings"; Path = "$(Split-Path -Path $PROFILE)\CloudTruth\Settings.json"}
            }
        }
    }
}
If ($EnableDebug -eq $true) {
    Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: CloudTruth = $($CloudTruth | ConvertTo-Json -Depth 3)" -Debug:$EnableDebug -WarningAction SilentlyContinue
}

#END: Variables
#######################################

#######################################
#START: Load Internal functions
$Section = $null
$Section = "Load Internal functions"

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$FindFunctionsSplat" -Verbose:$EnableVerbose
Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: This splat is used for the find-functions script" -Verbose:$EnableVerbose

$FindFunctionsSplat = $null
$FindFunctionsSplat = @{
    Debug = $EnableDebug
    ErrorAction = "Stop"
    Path = $CloudTruth.Internal.Functions.Directory
    Verbose = $EnableVerbose
}

If ($EnableDebug -eq $true) {
    Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$FindFunctionsSplat = $($FindFunctionsSplat | ConvertTo-Json -Depth 3)" -Debug:$EnableDebug -WarningAction SilentlyContinue
}

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$FindFunctions" -Verbose:$EnableVerbose
Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Looking for all functions at path ""$($FindFunctionsSplat.Path)"" and storing them in the variable `$FindFunctions" -Verbose:$EnableVerbose

$FindFunctions = $null
$FindFunctions = & $CloudTruth.Internal.Scripts.Files."Find-PowerShellFunction".Path @FindFunctionsSplat

If ($EnableDebug -eq $true) {
    Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$FindFunctions = $($FindFunctions | ConvertTo-Json -Depth 3)" -Debug:$EnableDebug -WarningAction SilentlyContinue
}

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$FindFunctionsCount" -Verbose:$EnableVerbose
Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Count how many PowerShell files found" -Verbose:$EnableVerbose

$FindFunctionsCount = $null
$FindFunctionsCount = $FindFunctions | Measure-Object -ErrorAction Stop | Select-Object -ExpandProperty Count -ErrorAction Stop -Verbose:$EnableVerbose

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: We found a total of ""$($FindFunctionsCount)"" PowerShell files" -Verbose:$EnableVerbose

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: --- STARTING FOREACH through each PowerShell file in the `$FindFunctions variable" -Verbose:$EnableVerbose

Foreach ($FoundFunction in $FindFunctions) {
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: ### BEGIN LOOP of variable `$FindFunctions" -Verbose:$EnableVerbose

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$PowerShellFile" -Verbose:$EnableVerbose

    $PowerShellFile = $null
    $PowerShellFile = $FoundFunction.PowerShellFile

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$FunctionNames" -Verbose:$EnableVerbose

    $FunctionNames = $null
    $FunctionNames = $FoundFunction.FunctionNames
    
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Running PowerShell File ""$($PowerShellFile.FullName)"" to import the following functions into the module. $($FunctionNames | ConvertTo-Json)" -Verbose:$EnableVerbose
    
    . $($PowerShellFile.FullName)

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: ### END LOOP of variable `$FindFunctions" -Verbose:$EnableVerbose
}

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: --- ENDING FOREACH through each PowerShell file in the `$FindFunctions variable" -Verbose:$EnableVerbose

#END: Load Internal functions
#######################################

#######################################
#START: Load Public functions
$Section = $null
$Section = "Load Public functions"

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$FindFunctionsSplat" -Verbose:$EnableVerbose
Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: This splat is used for the find-functions script" -Verbose:$EnableVerbose

$FindFunctionsSplat = $null
$FindFunctionsSplat = @{
    Debug = $EnableDebug
    ErrorAction = "Stop"
    Path = $CloudTruth.Public.Functions.Directory
    Verbose = $EnableVerbose
}

If ($EnableDebug -eq $true) {
    Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$FindFunctionsSplat = $($FindFunctionsSplat | ConvertTo-Json -Depth 3)" -Debug:$EnableDebug -WarningAction SilentlyContinue
}

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$FindFunctions" -Verbose:$EnableVerbose
Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Looking for all functions at path ""$($FindFunctionsSplat.Path)"" and storing them in the variable `$FindFunctions" -Verbose:$EnableVerbose

$FindFunctions = $null
$FindFunctions = & $CloudTruth.Internal.Scripts.Files."Find-PowerShellFunction".Path @FindFunctionsSplat

If ($EnableDebug -eq $true) {
    Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$FindFunctions = $($FindFunctions | ConvertTo-Json -Depth 3)" -Debug:$EnableDebug -WarningAction SilentlyContinue
}

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$FindFunctionsCount" -Verbose:$EnableVerbose
Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Count how many PowerShell files found" -Verbose:$EnableVerbose

$FindFunctionsCount = $null
$FindFunctionsCount = $FindFunctions | Measure-Object -ErrorAction Stop | Select-Object -ExpandProperty Count -ErrorAction Stop -Verbose:$EnableVerbose

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: We found a total of ""$($FindFunctionsCount)"" PowerShell files" -Verbose:$EnableVerbose

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: --- STARTING FOREACH through each PowerShell file in the `$FindFunctions variable" -Verbose:$EnableVerbose

Foreach ($FoundFunction in $FindFunctions) {
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: ### BEGIN LOOP of variable `$FindFunctions" -Verbose:$EnableVerbose

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$PowerShellFile" -Verbose:$EnableVerbose

    $PowerShellFile = $null
    $PowerShellFile = $FoundFunction.PowerShellFile

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$FunctionNames" -Verbose:$EnableVerbose

    $FunctionNames = $null
    $FunctionNames = $FoundFunction.FunctionNames
    
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Running PowerShell File ""$($PowerShellFile.FullName)"" to import the following functions into the module. $($FunctionNames | ConvertTo-Json)" -Verbose:$EnableVerbose
    
    . $($PowerShellFile.FullName)

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: ### END LOOP of variable `$FindFunctions" -Verbose:$EnableVerbose
}

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: --- ENDING FOREACH through each PowerShell file in the `$FindFunctions variable" -Verbose:$EnableVerbose


Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: --- STARTING FOREACH through each PowerShell file in the `$FindFunctions.FunctionNames variable" -Verbose:$EnableVerbose

Foreach ($FunctionName in $FindFunctions.FunctionNames) {
    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: ### BEGIN LOOP of variable `$FindFunctions.FunctionNames" -Verbose:$EnableVerbose

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Exporting function name $($FunctionName)" -Verbose:$EnableVerbose
    Export-ModuleMember -Function $($FunctionName) -ErrorAction Stop

    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: ### END LOOP of variable `$FindFunctions.FunctionNames" -Verbose:$EnableVerbose
}

Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: --- ENDING FOREACH through each PowerShell file in the `$FindFunctions.FunctionNames variable" -Verbose:$EnableVerbose


#END: Load Public functions
#######################################

