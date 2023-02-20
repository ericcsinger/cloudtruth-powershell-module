Function Test-CTAPILoginContext {
    [CmdletBinding()]
    <#
        .SYNOPSIS
        This will test a given CloudTruth api login to make sure it works.

        .DESCRIPTION
        This will test a given CloudTruth api login to make sure it works.

        .PARAMETER Credentials
        The user name is ignored, enter the API token in the password field

        .EXAMPLE
        # This will update the existing user profile
        
        $TestCTAPILoginContextSplat = @{
            Credential = $Credentials
            ErrorAction = "Stop"
        }
        Test-CTAPILoginContext @TestCTAPILoginContextSplat
        
    #>

    ##################################
    #START Parameters
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Enter the API token in the password field'
        )]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credentials
    )
    #END Parameters
    ##################################

    ######################################
    #START: begin
    begin {
        try {
            ######################################
            #START: Variables
            $Section = $null
            $Section = "Variables"

            $CommandName = $null
            $CommandName = $($MyInvocation.MyCommand.Name)

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$URIBase"

            $URIBase = $null
            $URIBase = "https://api.cloudtruth.io/api"

            If ($PSBoundParameters.ContainsKey('Debug') -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: URIBase = $($URIBase | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$URIVersion"

            $URIVersion = $null
            $URIVersion = "v1"

            If ($PSBoundParameters.ContainsKey('Debug') -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: URIVersion = $($URIVersion | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$URIPath"

            $URIPath = $null
            $URIPath = "users/current/"

            If ($PSBoundParameters.ContainsKey('Debug') -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: URIPath = $($URIPath | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$URI"

            $URI = $null
            $URI = "$($URIBase)/$($URIVersion)/$($URIPath)"

            If ($PSBoundParameters.ContainsKey('Debug') -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: URI = $($URI | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
            }
            
            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$Method"

            $Method = $null
            $Method = "GET"

            If ($PSBoundParameters.ContainsKey('Debug') -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Method = $($Method | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
            }

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$ContentType"

            $ContentType = $null
            $ContentType = "application/json"

            If ($PSBoundParameters.ContainsKey('Debug') -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: ContentType = $($ContentType | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
            }

            #START: Variables
            ######################################
            
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
        
     }
    #END: begin
    ######################################

    ######################################
    #START: process
    process {
        try {
            ######################################
            #START: Testing Login
            $Section = $null
            $Section = "Test login"

            Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$ResponseSplat"

            $ResponseSplat = $null
            $ResponseSplat = @{
                ContentType = $ContentType
                ErrorAction = "Stop"
                Method = $Method
                Uri = $URI
                Headers = @{
                    Authorization = "Api-Key $($Credentials.GetNetworkCredential().Password)"
                }
            }

            If ($PSBoundParameters.ContainsKey('Debug') -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: ResponseSplat, excluding headers from debug output!!!!!, due to api token"
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: ResponseSplat = $($ResponseSplat | Select-Object -ExcludeProperty Headers | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
            }

            try {
                
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$Response"
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Will execute Invoke-WebRequest, and store results in the `$Response variable, and will use the `$ResponseSplat for the parameters."
                
                $Response = $null
                
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Creating variable `$StatusCode"
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Will store the resulting status code of the `$Response in the `$StatusCode var since a negative response will not populate the `$Response var."
                
                $StatusCode = $null

                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Executing command Invoke-WebRequest"
                
                $Response = Invoke-WebRequest @ResponseSplat

                $StatusCode = $Response.StatusCode
            }
            catch {
                $StatusCode = $_.Exception.Response.StatusCode.value__
            }

            If ($PSBoundParameters.ContainsKey('Debug') -eq $true) {
                Write-Debug -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: StatusCode = $($StatusCode | ConvertTo-Json -Depth 3)" -WarningAction SilentlyContinue
            }
            
            If ($StatusCode -ne 200) {
                Throw "Your api-key is invalid, or something else went wrong.  The HTTP status code we received when making a call to $($URI), was $($StatusCode)"
            }
            Else {
                Write-Verbose -Message "[COMMAND]: $($CommandName), [SECTION]: $($Section), [MESSAGE]: Seems like were were able to login"
                $Response | Select-Object -ExpandProperty Content | ConvertFrom-Json
            }

            #START: Testing Login
            ######################################
            
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }

        
    

    }
    #END: process
    ######################################

    ######################################
    #START: end
    end {

    }
    #END: end
    ######################################
}