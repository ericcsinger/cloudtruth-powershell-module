Function Get-CTServiceAccount {
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
            HelpMessage = 'List all available CloudTruth Users',
            ParameterSetName = "ListAllAvailable"
        )]
        [switch]$ListAllAvailable,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Which field to use when ordering the results.',
            ParameterSetName = "ListAllAvailable"
        )]
        [string]$Ordering,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'A page number within the paginated result set.',
            ParameterSetName = "ListAllAvailable"
        )]
        [int]$Page,

        [Parameter(
            Mandatory = $false,
            HelpMessage = 'Number of results to return per page.',
            ParameterSetName = "ListAllAvailable"
        )]
        [int]$PageSize,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'The unique identifier of a user.',
            ParameterSetName = "Id"
        )]
        [string]$Id,

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
            $Method = "Get"
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
                Path = $null
                Method = $Method

                Debug = $DebugMessagesInternalCommand
                DebugMessagesExternalCommand = $PowerShellExternalCommandSplat.Debug
                ErrorAction = "Stop"
                Verbose = $VerboseMessagesInternalCommand
                VerboseMessagesExternalCommand = $PowerShellExternalCommandSplat.Verbose
            }
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

            $Section = $null
            $Section = "ListAllAvailable"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"
            
            If ($PSBoundParameters.ListAllAvailable.IsPresent -eq $true) {

                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Parameter set ListAllAvailable detected."
                
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating VARIABLE `$QueryParameters."
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: All query parameters will be stored in an array.  If the array is not empty, it will be joined an added to the path at the end."
                $QueryParameters = $null
                $QueryParameters = [System.Collections.ArrayList]@()

                
                If ($PSBoundParameters.Ordering.IsPresent -eq $true) {
                    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Query Parameter Ordering detected."
                    $QueryParameters.Add("ordering=$($Ordering)")
                }
                
                If ($PSBoundParameters.Page.IsPresent -eq $true) {
                    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Query Parameter Page detected."
                    $QueryParameters.Add("page=$($Page)")
                }

                If ($PSBoundParameters.PageSize.IsPresent -eq $true) {
                    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Query Parameter PageSize detected."
                    $QueryParameters.Add("page_size=$($PageSize)")
                }

                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating VARIABLE `$QueryParametersCount."
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Counting how many query parameters we found."
                $QueryParametersCount = $null
                $QueryParametersCount = $QueryParameters | Measure-Object | Select-Object -ExpandProperty Count
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$QueryParametersCount = ""$($QueryParametersCount)"""

                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Changing path to desired user."
                
                $InvokeCTAPIRequestSplat.Path = "$($Path)"

                If ($QueryParametersCount -ge 1) {
                    
                    Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating VARIABLE `$Query."
                    $Query = $null
                    $Query = $QueryParameters -join '&'

                    $InvokeCTAPIRequestSplat.Path = "$($Path)?$($Query)"
                }

            }
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

            $Section = $null
            $Section = "Id"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            If ($PSCmdlet.ParameterSetName -eq 'Id') {

                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Parameter set Id detected."
                
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Changing path to desired user Id."
                
                $InvokeCTAPIRequestSplat.Path = "$($Path)$($Id)/"
    
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
            {$PSItem -eq  "PowerShellCustomObject" -and $PSCmdlet.ParameterSetName -eq 'Id'}  {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Output PowerShellTable for parameter set ""$($PSCmdlet.ParameterSetName)"""

                $Output = [pscustomobject][ordered]@{
                    created_at = Get-Date -Date $($InvokeCTAPIRequestContent.created_at)
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
                    modified_at = if ($null -ne $($InvokeCTAPIRequestContent.modified_at)) {Get-Date -Date $($InvokeCTAPIRequestContent.modified_at)} else {$null}
                    name = $InvokeCTAPIRequestContent.name
                    last_used_at = if ($null -ne $($InvokeCTAPIRequestContent.last_used_at)) {Get-Date -Date $($InvokeCTAPIRequestContent.last_used_at) } Else {$null}
                    url = [uri]$InvokeCTAPIRequestContent.url
                    }

                break SwitchOutputFormat
            }

            {$PSItem -eq  "PowerShellCustomObject" -and $PSCmdlet.ParameterSetName -eq 'ListAllAvailable'} {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Output PowerShellTable for parameter set ""$($PSCmdlet.ParameterSetName)"""

                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: START FOREACH `$Result in `$InvokeCTAPIRequestContent.Result"
                $Output = Foreach ($Result in $InvokeCTAPIRequestContent.Results) {
                    Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: START LOOP `$Result"

                    [pscustomobject][ordered]@{
                        created_at = Get-Date -Date $($Result.created_at)
                        id = $Result.id
                        user = [pscustomobject][ordered]@{
                            url = [uri]$Result.user.url
                            id = $Result.user.id
                            type = $Result.user.type
                            name = $Result.user.name
                            organization_name = $Result.user.organization_name
                            membership_id = $Result.user.membership_id
                            role = $Result.user.role
                            email = $Result.user.email
                            picture_url = [uri]$Result.user.picture_url
                            created_at = Get-Date -Date $($Result.user.created_at)
                            modified_at = If ($null -ne $Result.user.modified_at) {Get-Date -Date $($Result.user.modified_at)} Else {$null}
                        }
                        description = $Result.description
                        modified_at = if ($null -ne $($Result.modified_at)) {Get-Date -Date $($Result.modified_at)} else {$null}
                        name = $Result.name
                        last_used_at = if ($null -ne $($Result.last_used_at)) {Get-Date -Date $($Result.last_used_at) } Else {$null}
                        url = [uri]$Result.url
                        }
                    Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: END LOOP `$Result"
                }
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: END FOREACH `$Result in `$InvokeCTAPIRequestContent.Result"

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