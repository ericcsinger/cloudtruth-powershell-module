Function Invoke-CTAPIRequest {
    [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess = $true)]
    <#
        .SYNOPSIS
        This will connect to a CloudTruth API and set it as your default context

        .DESCRIPTION
        This will connect to a CloudTruth API and set it as your default context

        .PARAMETER Credentials
        The user name is ignored

        .EXAMPLE
        # This will create a credentials object and use them for connecting to the api

    #>

    param (
        [Parameter(
            Mandatory = $false,
            HelpMessage = "If a body of any sort is required"
        )]
        [ValidateNotNullOrEmpty()]
        $Body = $null,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "If a special content type is needed"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$ContentType = "application/json",

        [Parameter(
            Mandatory = $false,
            HelpMessage = "The CloudTruth API Login context you wish to use"
        )]
        [ValidateNotNullOrEmpty()]
        $LoginContext = $CloudTruth.APILoginContext.Default,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Any special headers the HTTP request requires"
        )]
        [ValidateNotNullOrEmpty()]
        $Headers = $null,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "The HTTP method the API call requires"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Method,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "The API path you'd like to call"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

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
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            $CommandName = $null
            $CommandName = $($MyInvocation.MyCommand.Name)

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
            
            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$APIToken"
            $AllResults = $null
            $AllResults = [System.Collections.ArrayList]@()

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$AuthorizationHeaderValue"
            $AuthorizationHeaderValue = $null
            $AuthorizationHeaderValue = "Api-Key $($LoginContext.Credentials.GetNetworkCredential().Password)" 

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$URIBase"
            $URIBase = $null
            $URIBase = "https://api.cloudtruth.io/api/v1"
            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: URIBase = ""$($URIBase)""" 

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

        }
        catch {
            Throw $PSItem
        }
    }

    process {
        try {
            $Section = $null
            $Section = "Create base ResponseSplat"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$ResponseSplat"
            $ResponseSplat = $null
            $ResponseSplat = @{
                ContentType = $ContentType
                Method = $Method
                Uri = "$($URIBase)/$($Path)"
            }

            If ($null -ne $Headers) {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Headers were NOT null, ADDED them to the `$ResponseSplat"
                $ResponseSplat.Add("Headers",$Headers)
            }
            Else {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Headers WERE null, skipped adding them to the `$ResponseSplat"
            }

            If ($null -ne $Body) {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Body was NOT null, ADDED them to the `$ResponseSplat"
                $ResponseSplat.Add("Body",$($Body | ConvertTo-Json @PowerShellExternalCommandSplat) )
            }
            Else {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Body WAS null, skipped adding them to the `$ResponseSplat"
            }

            If ($PSBoundParameters.Debug.IsPresent -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: ResponseSplat = $($ResponseSplat | ConvertTo-Json -Depth 3 @PowerShellExternalCommandSplat)"
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

            $Section = $null
            $Section = "Add Authorization headers to the ResponseSplat"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            If ($ResponseSplat.Keys -contains 'Headers') {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$ResponseSplat.Keys contains 'Headers'"
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: *** IF `$ResponseSplat.Headers.Keys -contains 'Authorization''"

                If ($ResponseSplat.Headers.Keys -contains 'Authorization') {
                    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$ResponseSplat.Headers.Keys contains 'Authorization'"
                    $ResponseSplat.Headers.Authorization = $AuthorizationHeaderValue
                }
                Else {
                    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$ResponseSplat.Headers.Keys MISSING 'Authorization', ADDING"
                    $ResponseSplat.Headers.Add("Authorization",$AuthorizationHeaderValue)
                }
            }
            Else {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$ResponseSplat.Keys MISSING 'Headers', ADDING"
                $ResponseSplat.Add("Headers", @{Authorization = $AuthorizationHeaderValue})
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

            $Section = $null
            $Section = "Execute first ResponseSplat"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"
 
            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$Response"
            $Response = $null

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$StatusCode"
            $StatusCode = $null
            
            try {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Executing command Invoke-WebRequest"
                
                $Response = Invoke-WebRequest @ResponseSplat @PowerShellExternalCommandSplat
                $StatusCode = $Response.StatusCode
            }
            catch {
                $StatusCode = $_.Exception.Response.StatusCode.value__
            }
            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$StatusCode = ""$($StatusCode)"""
            
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

            $Section = $null
            $Section = "Results of first ResponseSplat"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            :SwitchStatusCode Switch ($StatusCode) {
                {$PSItem -lt 399} {
                    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Command executed with a success, adding results to `$AllResults variable"
                    [void]($AllResults.Add($Response))
                    break SwitchStatusCode
                }

                {$PSItem -ge 399 -and $PSItem -lt 429} {
                    Throw "Something went wrong with your request.  The HTTP status code we received when making a call to ""$($ResponseSplat.Uri)"", was ""$($StatusCode)"""
                    break SwitchStatusCode
                }

                {$PSItem -eq 429} {
                    Write-Warning -Message "The HTTP status code we received when making a call to ""$($ResponseSplat.Uri)"", was ""$($StatusCode)"". This typically indicates you're being throttled.  Try adding a delay per request."
                    break SwitchStatusCode
                }

                {$PSItem -gt 429 -and $PSItem -lt 500} {
                    Throw "Something went wrong with your request.  The HTTP status code we received when making a call to ""$($ResponseSplat.Uri)"", was ""$($StatusCode)"""
                    break SwitchStatusCode
                }

                {$PSItem -ge 500 } {
                    Throw "Something is wrong on the server side (not you).  The HTTP status code we received when making a call to ""$($ResponseSplat.Uri)"", was ""$($StatusCode)"""
                    break SwitchStatusCode
                }
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

            $Section = $null
            $Section = "Determine Pagination Need"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]:  Creating variable `$LastResponse"
            $LastResponse = $null
            $LastResponse = $Response | Select-Object @PowerShellExternalCommandSplat -ExpandProperty Content | ConvertFrom-Json @PowerShellExternalCommandSplat -Depth 100 -WarningAction SilentlyContinue

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]:  Creating variable `$PaginationSupportedRequest"
            $PaginationSupportedRequest = $false
            If ($LastResponse.PSobject.Properties.Name -contains "next") {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: This IS the type of request which supports pagination"
                $PaginationSupportedRequest = $true
            }
            Else {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: This is NOT the type of request which supports pagination"
            }

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]:  Creating variable `$PaginationNeeded"
            $PaginationNeeded = $false
            If ($PaginationSupportedRequest -eq $true) {
                If ([string]::IsNullOrWhiteSpace($LastResponse.next) -eq $false) {
                    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: This response has MORE data and needs pagination"
                    $PaginationNeeded = $true
                }
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"

            $Section = $null
            $Section = "Paginate if needed"
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION STARTED"

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]:  Creating variable `$PaginationLoopCounter"
            $PaginationLoopCounter = 0

            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]:  STARTING WHILE STATEMENT, (`$PaginationNeeded -eq `$true)"
            While ($PaginationNeeded -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]:  STARTING WHILE LOOP for, (`$PaginationNeeded -eq `$true)"

                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Pagination loop count = ""$($PaginationLoopCounter)"""

                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$Response"
                $Response = $null

                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$StatusCode"
                $StatusCode = $null

                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Updating variable `$ResponseSplat.Uri"
                $ResponseSplat.Uri = $LastResponse.next
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$ResponseSplat.Uri = ""$($ResponseSplat.Uri)"""

                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Making our next pagination call to URI  ""$($ResponseSplat.Uri)"""
                
                try {
                    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Executing command Invoke-WebRequest"
                    
                    $Response = Invoke-WebRequest @ResponseSplat @PowerShellExternalCommandSplat
                    $StatusCode = $Response.StatusCode
                }
                catch {
                    $StatusCode = $_.Exception.Response.StatusCode.value__
                }
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$StatusCode = ""$($StatusCode)"""

                :SwitchStatusCode Switch ($StatusCode) {
                    {$PSItem -lt 399} {
                        Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Command executed with a success, adding results to `$AllResults variable"
                        [void]($AllResults.Add($Response))
                        break SwitchStatusCode
                    }
    
                    {$PSItem -ge 399 -and $PSItem -lt 429} {
                        Throw "Something went wrong with your request.  The HTTP status code we received when making a call to ""$($ResponseSplat.Uri)"", was ""$($StatusCode)"""
                        break SwitchStatusCode
                    }
    
                    {$PSItem -eq 429} {
                        Write-Warning -Message "The HTTP status code we received when making a call to ""$($ResponseSplat.Uri)"", was ""$($StatusCode)"". This typically indicates you're being throttled.  Try adding a delay per request."
                        break SwitchStatusCode
                    }
    
                    {$PSItem -gt 429 -and $PSItem -lt 500} {
                        Throw "Something went wrong with your request.  The HTTP status code we received when making a call to ""$($ResponseSplat.Uri)"", was ""$($StatusCode)"""
                        break SwitchStatusCode
                    }
    
                    {$PSItem -ge 500 } {
                        Throw "Something is wrong on the server side (not you).  The HTTP status code we received when making a call to ""$($ResponseSplat.Uri)"", was ""$($StatusCode)"""
                        break SwitchStatusCode
                    }
                }

                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$LastResponse"
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Determining if additional pagination will be needed"
                $LastResponse = $null
                $LastResponse = $Response | Select-Object -ExpandProperty Content | ConvertFrom-Json -Depth 100 -WarningAction SilentlyContinue -ErrorAction Stop

                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$PaginationNeeded"
                $PaginationNeeded = $false
                If ([string]::IsNullOrWhiteSpace($LastResponse.next) -eq $false) {
                    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: There IS additional pagination is needed"
                    $PaginationNeeded = $true
                }
                Else {
                    Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: There is NOT additional pagination is needed"
                }

                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Incrementing variable `$PaginationLoopCounter"
                $PaginationLoopCounter++
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: `$PaginationLoopCounter = ""$($PaginationLoopCounter)"""

                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]:  ENDING WHILE LOOP for, (`$PaginationNeeded -eq `$true)"
            }
            Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]:  ENDING WHILE STATEMENT, (`$PaginationNeeded -eq `$true)"

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

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Output all results back"
            $AllResults

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: SECTION ENDED"
        }
        catch {
            Throw $PSItem
        }
    }

}