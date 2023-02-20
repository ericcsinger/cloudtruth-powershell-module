Function New-CTServiceAccount {
    [CmdletBinding()]
    <#
        .SYNOPSIS
        This will connect to a CloudTruth API and set it as your default context

        .DESCRIPTION
        This will connect to a CloudTruth API and set it as your default context

        .PARAMETER ListAllAvailable
        List all available CloudTruth contexts

        .EXAMPLE
        # This will update the existing user profile
        
    #>

    param (
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'The name of the process or system using the service account.'
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1,128)]
        [string]$Name,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'An optional description of the process or system using the service account.'
        )]
        [string]$Description,

        [Parameter(
            Mandatory = $true,
            HelpMessage = 'The role for the service account'
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Role,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "The CloudTruth API Login context you wish to use"
        )]
        [ValidateNotNullOrEmpty()]
        $LoginContext,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "The format you'd like the command to return the object in."
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("BasicHtmlWebResponseObject","PowerShellCustomObject")]
        $OutputFormat = "PowerShellCustomObject",

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

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating VARIABLE `$Path"
            $Path = $null
            $Path = "serviceaccounts/"
            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$Path = ""$($Path)""" 

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating VARIABLE `$Method"
            $Method = $null
            $Method = "POST"
            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$Method = ""$($Method)""" 

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

        }
        catch {
            Throw $PSItem
        }

    }

    process {
       
        try {

            $Section = $null
            $Section = "Create Default InvokeCTAPIRequestSplat"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating VARIABLE `$InvokeCTAPIRequestSplat"
            $InvokeCTAPIRequestSplat = $null
            $InvokeCTAPIRequestSplat = @{
                Path = $Path
                Method = $Method
                Body = @{
                    name = $Name
                    role = $Role
                }

                Debug = $DebugMessagesInternalCommand
                DebugMessagesExternalCommand = $PowerShellExternalCommandSplat.Debug
                ErrorAction = "Stop"
                Verbose = $VerboseMessagesInternalCommand
                VerboseMessagesExternalCommand = $PowerShellExternalCommandSplat.Verbose
            }
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

            $Section = $null
            $Section = "Description"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"
            
            If ($PSBoundParameters.ContainsKey("Description") -eq $true) {

                 Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Adding description to the request body"
                $InvokeCTAPIRequestSplat.Body.Add('description', $($Description))
            }
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

            $Section = $null
            $Section = "Add CTAPILoginContext"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            If ($PSBoundParameters.CTAPILoginContext.IsPresent -eq $true) {

                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Parameter set CTAPILoginContext detected."

                $InvokeCTAPIRequestSplat.Add("CTAPILoginContext",$LoginContext)
    
            }
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

            $Section = $null
            $Section = "Execute Invoke-CTAPIRequest"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            If ($PSBoundParameters.Debug.IsPresent -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: InvokeCTAPIRequestSplat = $($InvokeCTAPIRequestSplat | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
            }

            $InvokeCTAPIRequest = $null
            $InvokeCTAPIRequest = Invoke-CTAPIRequest @InvokeCTAPIRequestSplat

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

        }
        catch {
            Throw $PSItem
        }
    }

    end {
        $Output = $null

        $Section = $null
        $Section = "Format output"
        Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

        If ($OutputFormat -eq "PowerShellCustomObject") {
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Converting the resulting content to a PowerShell Object"
            $InvokeCTAPIRequestContent = $null
            $InvokeCTAPIRequestContent = $InvokeCTAPIRequest.content | ConvertFrom-Json @PowerShellExternalCommandSplat -Depth 100 -WarningAction SilentlyContinue
        }

        :SwitchOutputFormat Switch ($OutputFormat) {
            {$PSItem -eq  "PowerShellCustomObject"}  {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Output PowerShellTable for parameter set ""$($PSCmdlet.ParameterSetName)"""

                $SecurePassword = $null
                $SecurePassword = $InvokeCTAPIRequestContent.apiKey | ConvertTo-SecureString @PowerShellExternalCommandSplat -AsPlainText -Force

                $Output = [pscustomobject][ordered]@{
                    url = [uri]$InvokeCTAPIRequestContent.url
                    id = $InvokeCTAPIRequestContent.id
                    user = [pscustomobject][ordered]@{
                        url = [uri]$InvokeCTAPIRequestContent.user.url
                        id = $InvokeCTAPIRequestContent.user.id
                        type = $InvokeCTAPIRequestContent.user.type
                        name = $InvokeCTAPIRequestContent.user.name
                        organization_name = $InvokeCTAPIRequestContent.user.organization_name
                        membership_id = $InvokeCTAPIRequestContent.user.membership_id
                        role = $InvokeCTAPIRequestContent.user.role
                        email = $InvokeCTAPIRequestContent.user.email
                        picture_url = [uri]$InvokeCTAPIRequestContent.user.picture_url
                        created_at = Get-Date -Date $($InvokeCTAPIRequestContent.user.created_at)
                        modified_at = If ($null -ne $InvokeCTAPIRequestContent.user.modified_at) {Get-Date -Date $($InvokeCTAPIRequestContent.user.modified_at)} Else {$null}
                    }
                    description = $InvokeCTAPIRequestContent.description
                    created_at = if ($null -ne $($InvokeCTAPIRequestContent.created_at)) {Get-Date -Date $($InvokeCTAPIRequestContent.created_at)} else {$null}
                    modified_at = if ($null -ne $($InvokeCTAPIRequestContent.modified_at)) {Get-Date -Date $($InvokeCTAPIRequestContent.modified_at)} else {$null}
                    last_used_at = if ($null -ne $($InvokeCTAPIRequestContent.last_used_at)) {Get-Date -Date $($InvokeCTAPIRequestContent.last_used_at) } Else {$null}
                    apiKey = $InvokeCTAPIRequestContent.apiKey
                    credential = New-Object System.Management.Automation.PSCredential -ArgumentList $($InvokeCTAPIRequestContent.id), $SecurePassword
                    }

                break SwitchOutputFormat
            }

            {$PSItem -eq  "BasicHtmlWebResponseObject"} {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Output BasicHtmlWebResponseObject for parameter set ""$($PSCmdlet.ParameterSetName)"""
                $Output = $InvokeCTAPIRequest

                break SwitchOutputFormat
            }

            Default {
                Throw "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Outputformat ""$($PSItem)"" or parameter set ""$($PSCmdlet.ParameterSetName)"" is not defined in this switch block."
            }
        }
        Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

        $Section = $null
        $Section = "Output"
        Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"
        
        $Output

        Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"
        
    }

}