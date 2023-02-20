Function Connect-CTAPI {
    [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess = $true)]
    <#
        .SYNOPSIS
        This will connect to a CloudTruth API and set it as your default context

        .DESCRIPTION
        This will connect to a CloudTruth API and set it as your default context

        .EXAMPLE
        # This will create a credentials object and use them for connecting to the api

        $Creds = Get-credential
        Connect-CTAPI -Credentials $Creds 

        .EXAMPLE
        # This will connect using a secure string

        $Token = Read-Host "Enter your CloudTruth Token" -AsSecureString
        Connect-CTAPI -APIToken $Token

        .EXAMPLE
        # This will connect using an INSECURE clear text password. Not recommended, but enabled for quick tests.

        Connect-CTAPI -APITokenPlainText "MyPlainTextAPIToken"
        
    #>

    param (
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Enter the API token in the password field',
            ParameterSetName = 'Credentials'
        )]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credentials,

        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Enter the API token',
            ParameterSetName = 'APIToken'
        )]
        [ValidateNotNullOrEmpty()]
        [securestring]$APIToken,

        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Enter the API token',
            ParameterSetName = 'APITokenPlainText'
        )]
        [ValidateNotNullOrEmpty()]
        [string]$APITokenPlainText,

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

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"


            $Section = $null
            $Section = "Convert APIToken to credential"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: *** IF PSBoundParameters.ContainsKey ""Credentials"""
            If ($PSBoundParameters.Credentials.IsPresent -eq $true)  {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Credentials already present, will be skipping the next set of IF conditions"
            }
            
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: *** IF PSBoundParameters.ContainsKey ""APITOKEN"""
            If ($PSBoundParameters.APIToken.IsPresent -eq $true)  {
                
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Saving APITOKEN as `$SecurePassword variable"
                $SecurePassword = $null
                $SecurePassword = $APIToken 
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: *** IF PSBoundParameters.ContainsKey ""APITokenPlainText"""
            If ($PSBoundParameters.APITokenPlainText.IsPresent -eq $true)  {
                
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Converting APITokenPlainText to a SecureString and storingin the `$SecurePassword variable"
                $SecurePassword = $null
                $SecurePassword = $APITokenPlainText | ConvertTo-SecureString -AsPlainText -Force
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: *** IF PSBoundParameters.ContainsKey ""APITOKEN"" OR *** IF PSBoundParameters.ContainsKey ""APITokenPlainText"""
            If ($PSBoundParameters.ContainsKey("APIToken") -eq $true -or $PSBoundParameters.ContainsKey("APITokenPlainText") -eq $true)  {
                
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$UserName"
                $UserName = $null
                $UserName = "na"

                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$Credentials"
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating a credentials object from the username and `$SecurePassword variable"
                $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $SecurePassword
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
            $Section = "Create a new context"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$NewCTAPILoginContextSplat"
            $NewCTAPILoginContextSplat = $null
            $NewCTAPILoginContextSplat = [ordered]@{
                Credentials = $Credentials

                Debug = $DebugMessagesInternalCommand
                DebugMessagesExternalCommand = $PowerShellExternalCommandSplat.Debug
                ErrorAction = "Stop"
                Verbose = $VerboseMessagesInternalCommand
                VerboseMessagesExternalCommand = $PowerShellExternalCommandSplat.Verbose
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$NewCTAPILoginContext"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Running command New-CTAPILoginContext with the splat from @NewCTAPILoginContextSplat"
            $NewLoginContext = $null
            $NewLoginContext = New-CTAPILoginContext @NewCTAPILoginContextSplat

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"
            
        }
        catch {
            Throw $PSItem
        }
        
        
    }

    end {

        ######################################
        #START: Output
        try {
            $Section = $null
            $Section = "Output"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Running Get-CTAPILoginContext, to output the default context back"
            Get-CTAPILoginContext

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"
        }
        catch {
            Throw $PSItem
        }
    }
    #END: end
    ######################################
}