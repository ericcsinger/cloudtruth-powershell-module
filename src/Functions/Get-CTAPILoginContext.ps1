Function Get-CTAPILoginContext {
    [CmdletBinding()]
    <#
        .SYNOPSIS
        This will connect to a CloudTruth API and set it as your default context

        .DESCRIPTION
        This will connect to a CloudTruth API and set it as your default context

        .PARAMETER ListAvailable
        List all available CloudTruth contexts

        .EXAMPLE
        # This will update the existing user profile
        
    #>

    ##################################
    #START Parameters
    param (
        [Parameter(
            Mandatory = $false,
            HelpMessage = 'List all available CloudTruth contexts'
        )]
        [switch]$ListAvailable
        
    )
    #END Parameters
    ##################################

    ######################################
    #START: begin
    begin {

    }
    #END: begin
    ######################################

    ######################################
    #START: process
    process {
       ######################################
        #START: Which context(s) to list

        $AllCTContexts = $null
        $AllCTContexts = $CloudTruth.APILoginContext.Default
        
        If ($PSBoundParameters.ContainsKey("ListAvailable") -eq $true)  {
            $AllCTContextKeys = $null
            $AllCTContextKeys = $CloudTruth.APILoginContext.All.Keys

            $AllCTContexts = $null
            $AllCTContexts = foreach ($CTContextKey in $AllCTContextKeys) {
                [pscustomobject]$CloudTruth.APILoginContext.All.$($CTContextKey)
            }
        }
        
        #START: Which context(s) to list
        ######################################
        
    }
    #END: process
    ######################################

    ######################################
    #START: end
    end {

        ######################################
        #START: Output

        $AllCTContexts | Select-Object -ExcludeProperty Credentials

        #START: Output
        ######################################
    }
    #END: end
    ######################################
}