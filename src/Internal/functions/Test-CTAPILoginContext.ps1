Function Test-CTAPILoginContext {
    [CmdletBinding()]
    <#
        .SYNOPSIS
        This will test a given CloudTruth api login to make sure it works.

        .DESCRIPTION
        This will test a given CloudTruth api login to make sure it works.

        .EXAMPLE
        # This will update the existing user profile
        
        $TestCTAPILoginContextSplat = @{
            Credential = $Credentials
            ErrorAction = "Stop"
        }
        Test-CTAPILoginContext @TestCTAPILoginContextSplat
        
    #>

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Enter the API token in the password field'
        )]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credentials,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "If you want to display verbose messages for external commands"
        )]
        [ValidateNotNullOrEmpty()]
        [switch]$VerboseMessagesExternalCommand,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "If you want to display debug messages for external commands"
        )]
        [ValidateNotNullOrEmpty()]
        [switch]$DebugMessagesExternalCommand
    )

    begin {
        try {
            $Section = $null
            $Section = "Variables"

            $CommandName = $null
            $CommandName = $($MyInvocation.MyCommand.Name)

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            If ($PSBoundParameters.Debug.IsPresent -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: PSBoundParameters = $($PSBoundParameters | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
            }

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$DebugMessagesInternalCommand"
            $DebugMessagesInternalCommand = $null
            $DebugMessagesInternalCommand = If ($PSBoundParameters.Debug.IsPresent -eq $true) {$true} else {$false}
            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$DebugMessagesInternalCommand = ""$($DebugMessagesInternalCommand)""" 

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$VerboseMessagesInternalCommand"
            $VerboseMessagesInternalCommand = $null
            $VerboseMessagesInternalCommand = If ($PSBoundParameters.Verbose.IsPresent -eq $true) {$true} else {$false}
            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$VerboseMessagesInternalCommand = ""$($VerboseMessagesInternalCommand)""" 

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$PowerShellExternalCommandSplat"
            $PowerShellExternalCommandSplat = $null
            $PowerShellExternalCommandSplat = @{
                Debug = If ($PSBoundParameters.DebugMessagesExternalCommand.IsPresent -eq $true) {$true} else {$false}
                ErrorAction = "Stop"
                Verbose = If ($PSBoundParameters.VerboseMessagesExternalCommand.IsPresent -eq $true) {$true} else {$false}
            }
            if ($PSBoundParameters.Debug.IsPresent -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: PowerShellExternalCommandSplat = $($PowerShellExternalCommandSplat | ConvertTo-Json -Depth 10 @PowerShellExternalCommandSplat)" 
            }

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$Method"
            $Method = $null
            $Method = "GET"
            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$Method = ""`$($Method)""" 

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$Path"
            $Path = $null
            $Path = "users/current/"
            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$Method = ""`$($Path)""" 
            
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"
        }
        catch {
            Throw $PSItem
        }
        
     }

    process {
        try {

            $Section = $null
            $Section = "Test login"

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$InvokeCTAPIRequestSplat"
            $InvokeCTAPIRequestSplat = $null
            $InvokeCTAPIRequestSplat = @{
                Method = $Method
                Path = $Path
                LoginContext = [pscustomobject]@{Credentials = $Credentials}

                Debug = $DebugMessagesInternalCommand
                DebugMessagesExternalCommand = $PowerShellExternalCommandSplat.Debug
                ErrorAction = "Stop"
                Verbose = $VerboseMessagesInternalCommand
                VerboseMessagesExternalCommand = $PowerShellExternalCommandSplat.Verbose
            }
            If ($PSBoundParameters.Debug.IsPresent -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$InvokeCTAPIRequestSplat = $($InvokeCTAPIRequestSplat | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
            }

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$InvokeCTAPIRequest"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Will execute Invoke-CTAPIRequest, and store results in the `$InvokeCTAPIRequest variable."
            
            $InvokeCTAPIRequest = $null
            $InvokeCTAPIRequest = Invoke-CTAPIRequest @InvokeCTAPIRequestSplat

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Test completed without any errors.  Returning result to setup context."
            
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"
        }
        catch {
            Throw $PSItem
        }
    }

    end {
        try {
            $Section = $null
            $Section = "Output"

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Output all `$InvokeCTAPIRequest back"
            $InvokeCTAPIRequest

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"
        }
        catch {
            Throw $PSItem
        }

    }
}