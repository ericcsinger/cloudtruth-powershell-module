Function New-CTAPILoginContext {
    [CmdletBinding()]
    <#
        .SYNOPSIS
        This create a new api login context object

        .DESCRIPTION
        This create a new api login context object.  

        .EXAMPLE
        # This create a simple login context by utilizing a splat.  

        $NewCTAPILoginContextSplat = [ordered]@{
            Credentials = $Credentials
            ErrorAction = "Stop"
        }
        New-CTAPILoginContext @NewCTAPILoginContextSplat

    #>

    param (
        [Parameter(
            Mandatory = $true,
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
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: PowerShellExternalCommandSplat = $($PowerShellExternalCommandSplat | ConvertTo-Json @PowerShellExternalCommandSplat -Depth 10)" 
            }

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

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$TestCTAPILoginContextSplat"
            $TestCTAPILoginContextSplat = $null
            $TestCTAPILoginContextSplat = @{
                Credential = $Credentials

                Debug = $DebugMessagesInternalCommand
                DebugMessagesExternalCommand = $PowerShellExternalCommandSplat.Debug
                ErrorAction = "Stop"
                Verbose = $VerboseMessagesInternalCommand
                VerboseMessagesExternalCommand = $PowerShellExternalCommandSplat.Verbose
            }
            if ($PSBoundParameters.Debug.IsPresent -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$TestCTAPILoginContextSplat = $($TestCTAPILoginContextSplat | ConvertTo-Json @PowerShellExternalCommandSplat -Depth 2)" -WarningAction SilentlyContinue
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$TestCTAPILoginContext"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Running command Test-CTAPILoginContext with splat `$TestCTAPILoginContextSplat and storing results in variable `$TestCTAPILoginContext"
            
            $TestLoginContext = $null
            $TestLoginContext = Test-CTAPILoginContext @TestCTAPILoginContextSplat

            If ($PSBoundParameters.Debug.IsPresent -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$TestLoginContext = $($TestLoginContext | Select-Object -Property StatusCode, Content | ConvertTo-Json @PowerShellExternalCommandSplat -Depth 2)" -WarningAction SilentlyContinue
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

            $Section = $null
            $Section = "Create New Login Context"

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$TestLoginContextContent"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Converting `$TestLoginContext content to a PowerShell Object"
            $TestLoginContextContent = $null
            $TestLoginContextContent = $TestLoginContext.Content | ConvertFrom-Json @PowerShellExternalCommandSplat -Depth 100 -WarningAction SilentlyContinue
            

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$LoginContext"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Variable will be used to store login information for subsequent commands"
            
            $LoginContext = $null
            $LoginContext = [pscustomobject][ordered]@{
                CreatedAt = Get-Date -Date "$($TestLoginContextContent.created_at)"
                Credentials = $Credentials
                Email = $TestLoginContextContent.email
                Id = $TestLoginContextContent.id
                MembershipId = $TestLoginContextContent.membership_id
                Name = $TestLoginContextContent.name
                OrganizationName = $TestLoginContextContent.organization_name
                PictureURL = $TestLoginContextContent.picture_url
                Role = $TestLoginContextContent.role
            }
            
            If ($PSBoundParameters.Debug.IsPresent -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$LoginContext = $($LoginContext | Select-Object -ExcludeProperty Credentials -ErrorAction Stop | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

            $Section = $null
            $Section = "Setup Login"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Checking if the CloudTruth variable contains this API login context already."
            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: *** IF CloudTruth.LoginContext.All.ContainsKey ""CTAPILoginContext.Id"""
            If ($CloudTruth.APILoginContext.All.Keys -notcontains "$($LoginContext.Id)") {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Login does not exist already, attempting to add"
                $CloudTruth.APILoginContext.All.Add($($LoginContext.Id), $LoginContext)
            }
            else {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Login DOES EXIST already, attempting to overwrite"
                $CloudTruth.APILoginContext.All."$($LoginContext.Id)" = $LoginContext
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Login overwritten"
            }

            If ($null -ne $CloudTruth.APILoginContext.Default) {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Attempting to clear the default login contexts"
                $CloudTruth.APILoginContext.Default = $null
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Setting this login context as the new default"
            $CloudTruth.APILoginContext.Default = $LoginContext

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

        }
        catch {            
            Throw $PSItem
        }
    }

    end {

    }
}