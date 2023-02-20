##################################
#START Parameters
[CmdletBinding()]
param ()
#END Parameters
##################################

##################################
#START Variables

#This section is for files and paths related to the relative module being launched
$Script:ModuleRootPath = Split-Path $PSScriptRoot -Parent
$Script:ModuleConfigurationDirectoryPath = "$($ModuleRootPath)\configurations"
$Script:ModuleScriptsDirectoryPath = "$($ModuleRootPath)\scripts"
$Script:ModuleDefaultUserProfileFilePath = "$($ModuleConfigurationDirectoryPath)\DefaultUserProfile.ps1"

#This section is for files and paths related to the specific user
$Script:PowerShellProfileRootDirectory = Split-Path -Path $Profile
$Script:PSQLUserProfileDirectoryPath = "$($PowerShellProfileRootDirectory)\PostgreSQL"
$Script:PSQLUserProfileFilePath = "$($PSQLUserProfileDirectoryPath)\UserProfile.json"
#END Variables
##################################

######################################
#START: Verbose Debugging 
If ($PSBoundParameters.Verbose.IsPresent -eq $true)  {
    Write-Verbose -Message "IsCoreCLR: $($IsCoreCLR)"
    Write-Verbose -Message "IsLinux: $($IsLinux)"
    Write-Verbose -Message "IsMacOS: $($IsMacOS)"
    Write-Verbose -Message "IsWindows: $($IsWindows)"
    Write-Verbose -Message "ModuleConfigurationDirectoryPath: $($ModuleConfigurationDirectoryPath)"
    Write-Verbose -Message "ModuleDefaultUserProfileFilePath: $($ModuleDefaultUserProfileFilePath)"
    Write-Verbose -Message "ModuleRootPath: $($ModuleRootPath)"
    Write-Verbose -Message "ModuleScriptsDirectoryPath: $($ModuleScriptsDirectoryPath)"
    Write-Verbose -Message "PowerShellProfileRootDirectory: $($PowerShellProfileRootDirectory)"
    Write-Verbose -Message "PSBoundParameters = $($PSBoundParameters | ConvertTo-Json)"
    Write-Verbose -Message "PSCommandPath = $($PSCommandPath)"
    Write-Verbose -Message "PSQLUserProfileDirectoryPath: $($PSQLUserProfileDirectoryPath)"
    Write-Verbose -Message "PSQLUserProfileFilePath: $($PSQLUserProfileFilePath)"
    Write-Verbose -Message "PSScriptRoot = $($PSScriptRoot)"
    Write-Verbose -Message "PSSenderInfo: $($PSSenderInfo)"
    Write-Verbose -Message "PSVersionTable: $($PSVersionTable | Out-String)"
}
#END: Verbose Debugging 
######################################

##################################
#START Temporarily import default postrgresql user profile
try {
    Write-Verbose "Setting up PostgreSQL variable"
    $PostgreSQL = [pscustomobject][ordered]@{

        ##################################
        #START AllLoginContexts
        AllLoginContexts = [ordered]@{ }
        #END AllLoginContexts
        ##################################

        ##################################
        #START DefaultLoginContext
        DefaultLoginContext = [ordered]@{ }
        #END DefaultLoginContext
        ##################################

        ##################################
        #START Debug commands you want to make available at the beginning of the function / script
        DebugCommands = {

            $AllVariables = Get-Variable -Scope 1 | Sort-Object -Property Name

            Write-Verbose -Message "ComputerName: $($env:ComputerName)"
            Write-Verbose -Message "InvocationName: $($AllVariables | Where-Object {$_.Name -eq 'MyInvocation'} | Select-Object -ExpandProperty Value | Select-Object -ExpandProperty InvocationName)"
            Write-Verbose -Message "IsCoreCLR: $($IsCoreCLR)"
            Write-Verbose -Message "IsLinux: $($IsLinux)"
            Write-Verbose -Message "IsWindows: $($IsWindows)"
            Write-Verbose -Message "Line: $($AllVariables | Where-Object {$_.Name -eq 'MyInvocation'} | Select-Object -ExpandProperty Value | Select-Object -ExpandProperty Line)"
            Write-Verbose -Message "ProgramFiles: $($env:ProgramFiles)"
            Write-Verbose -Message "ProgramFiles(x86): ${$env:ProgramFiles(x86)}"
            Write-Verbose -Message "PSBoundParameters: $($AllVariables | Where-Object {$_.Name -eq 'PSBoundParameters'} | Select-Object -ExpandProperty Value | ConvertTo-Json)"
            Write-Verbose -Message "PSCommandPath: $($AllVariables | Where-Object {$_.Name -eq 'PSCommandPath'} | Select-Object -ExpandProperty Value)"
            Write-Verbose -Message "PSScriptRoot: $($AllVariables | Where-Object {$_.Name -eq 'PSScriptRoot'} | Select-Object -ExpandProperty Value)"
            Write-Verbose -Message "PSVersionTable: $($PSVersionTable | Out-String)"
            Write-Verbose -Message "USERDNSDOMAIN: $($env:USERDNSDOMAIN)"
            Write-Verbose -Message "UserName: $($env:UserName)"
            Write-Verbose -Message "windir: $($env:windir)"
            Foreach ($Variable in $AllVariables) {
                If ($Variable.Name -like "*Preference") {
                    Write-Verbose -Message "$($Variable.Name): $($Variable.Value)"
                }
            }


            if ($DebugSensitiveValues.IsPresent -eq $true) {
                Write-Verbose -Message "EnvironmentVariables: $(Get-ChildItem env: | Select-Object -Property Name,Value  | ConvertTo-Json)"
            }

        }
        #END Debug commands you want to make available at the beginning of the function / script
        ##################################

        ##################################
        #START EnvironmentVariableNames
        EnvironmentVariableNames = @(
            "PGHOST"
            "PGHOSTADDR"
            "PGPORT"
            "PGDATABASE"
            "PGUSER"
            "PGPASSFILE"
            "PGCHANNELBINDING"
            "PGSERVICE"
            "PGSERVICEFILE"
            "PGOPTIONS"
            "PGAPPNAME"
            "PGSSLMODE"
            "PGREQUIRESSL"
            "PGSSLCOMPRESSION"
            "PGSSLCERT"
            "PGSSLKEY"
            "PGSSLROOTCERT"
            "PGSSLCRL"
            "PGSSLCRLDIR"
            "PGSSLSNI"
            "PGREQUIREPEER"
            "PGSSLMINPROTOCOLVERSION"
            "PGSSLMAXPROTOCOLVERSION"
            "PGGSSENCMODE"
            "PGKRBSRVNAME"
            "PGGSSLIB"
            "PGCONNECT_TIMEOUT"
            "PGCLIENTENCODING"
            "PGTARGETSESSIONATTRS"
            "PGDATESTYLE"
            "PGTZ"
            "PGGEQO"
            "PGSYSCONFDIR"
            "PGLOCALEDIR"
        )
        #END EnvironmentVariableNames
        ##################################

        ##################################
        #START Profile
        Profile = & $($ModuleDefaultUserProfileFilePath)
        #END Profile
        ##################################

        ##################################
        #START The default terminating error action
        TerminatingErrorActionDefault = {
            $FatalMessageObject = @{
                ExceptionMessage = $_.Exception.Message
                MyCommandName = $_.InvocationInfo.MyCommand.Name
                Line = $($_.InvocationInfo.Line).Trim()
                LineNumber = $_.InvocationInfo.ScriptLineNumber
                ScriptName = $_.InvocationInfo.ScriptName
            }
            Throw $($FatalMessageObject | ConvertTo-Json)
        }
        #END The default terminating error action
        ##################################

        ##################################
        #START Variables
        Variables = [ordered]@{
            ModuleRootPath = $ModuleRootPath
            ModuleConfigurationDirectoryPath = $ModuleConfigurationDirectoryPath
            ModuleScriptsDirectoryPath = $ModuleScriptsDirectoryPath
            ModuleDefaultUserProfileFilePath = $ModuleDefaultUserProfileFilePath
            PowerShellProfileRootDirectory = $PowerShellProfileRootDirectory
            PSQLUserProfileDirectoryPath = $PSQLUserProfileDirectoryPath
            PSQLUserProfileFilePath = $PSQLUserProfileFilePath
            PGDumpEXE = $null
            PGDumpAllEXE = $null
            PSQLEXE = $null
            PGRestoreEXE = $null
        }
        #END Variables
        ##################################

    }
}
catch {
    $FatalMessageObject = $null
    $FatalMessageObject = @{
        ExceptionMessage = $_.Exception.Message
        MyCommandName = $_.InvocationInfo.MyCommand.Name
        Line = $($_.InvocationInfo.Line).Trim()
        LineNumber = $_.InvocationInfo.ScriptLineNumber
        ScriptName = $_.InvocationInfo.ScriptName
    }
    Throw $($FatalMessageObject | ConvertTo-Json)
}
#END Temporarily import default postrgresql user profile
##################################

##################################
#START Test if profile directory, if not create it
try {
    Write-Verbose -Message "Testing if user profile directory ""$($PSQLUserProfileDirectoryPath)"" exists"
    If ((Test-Path -Path $PSQLUserProfileDirectoryPath -PathType 'Container' -ErrorAction Stop) -eq $false) {
        Write-Verbose -Message "User profile directory ""$($PSQLUserProfileDirectoryPath)"" missing, attempting to create"
        [void](New-Item -Path $PSQLUserProfileDirectoryPath -ItemType Directory)
    }
}
catch {
    & $PostgreSQL.TerminatingErrorActionDefault
}
#END Test if profile directory, if not create it
##################################

##################################
#START Setup Profile for user
try {
    ##################################
    #START Create if missing
    Write-Verbose -Message "Testing if user profile file ""$($PSQLUserProfileFilePath)"" exists"
    If ((Test-Path -Path $PSQLUserProfileFilePath -PathType 'Leaf') -eq $false) {
        Write-Verbose -Message "User profile file ""$($PSQLUserProfileFilePath)"" missing, attempting to copy from ""$($ModuleDefaultUserProfileFilePath)"""
        [void]($PostgreSQL.Profile | ConvertTo-Json -Depth 100 | Out-File -FilePath $PSQLUserProfileFilePath)
    }
    #END Create if missing
    ##################################

    ##################################
    #START Import Users default profiles
    Write-Verbose -Message "Importing user profile file from path ""$($PSQLUserProfileFilePath)"" into temp var"
    $Script:PSQLUserProfileObjectTemp = Get-Content -Path $PSQLUserProfileFilePath  | ConvertFrom-Json -Depth 100 -AsHashtable
    #END Import Users default profiles
    ##################################

    ##################################
    #START Compare the default user profile vs. current
    Write-Verbose -Message "Comparing user profile file to the default user profile"
    If ($PSBoundParameters.Verbose.IsPresent -eq $true)  {
        Write-Verbose -Message "PostgreSQL.Profile: $($PostgreSQL.Profile | ConvertTo-Json)"
        Write-Verbose -Message "PSQLUserProfileObjectTemp: $($PSQLUserProfileObjectTemp | ConvertTo-Json)"
    }
    $Script:PSQLAllComparedProfileSettings = Compare-HashTable -ReferenceObject $PostgreSQL.Profile -DifferenceObject $PSQLUserProfileObjectTemp
    #END Compare the default user profile vs. current
    ##################################

    ##################################
    #START Loop through any missing keys and add them
    Write-Verbose "Any missing keys in the profile, we're gong to add"
    Foreach ($Script:PSQLComparedProfileSetting in $PSQLAllComparedProfileSettings)  {
        Write-Verbose "Evaluating key: $($PSQLComparedProfileSetting.Key)"
        :SwitchPSQLComparedProfileSetting switch ($PSQLComparedProfileSetting) {
            {$PSItem.ReferenceKeyExists -eq $false} { 
                Write-Verbose "Missing key: $($PSQLComparedProfileSetting.Key)"
                $PostgreSQL.Profile.Add($($PSQLComparedProfileSetting.Key), $PSQLUserProfileObjectTemp.$($PSQLComparedProfileSetting.Key)) ; break SwitchPSQLComparedProfileSetting 
            }
            {$PSItem.ReferenceKeyExists -eq $true -and $PSItem.ValuesMatch -eq $false } { 
                Write-Verbose "Mismatched values for key: $($PSQLComparedProfileSetting.Key)"
                $PostgreSQL.Profile.$($PSQLComparedProfileSetting.Key) = $PSQLUserProfileObjectTemp.$($PSQLComparedProfileSetting.Key) ; break SwitchPSQLComparedProfileSetting 
            }
        }

    }
    #END Loop through any missing keys and add them
    ##################################
    
}
catch {
    & $PostgreSQL.TerminatingErrorActionDefault
}
#END Setup Profile for user
##################################

##################################
#START Update variables based on user profile
try {
    ##################################
    #START Create if missing
    Write-Verbose "Setting variable for user"
    $PostgreSQL.Variables.PGDumpAllEXE = "$($PostgreSQL.Profile.ExecutablesPath)\pg_dumpall.exe"
    $PostgreSQL.Variables.PGDumpEXE = "$($PostgreSQL.Profile.ExecutablesPath)\pg_dump.exe"
    $PostgreSQL.Variables.PGRestoreEXE = "$($PostgreSQL.Profile.ExecutablesPath)\pg_restore.exe"
    $PostgreSQL.Variables.PSQLEXE = "$($PostgreSQL.Profile.ExecutablesPath)\psql.exe"
    #END Create if missing
    ##################################
    
}
catch {
    & $PostgreSQL.TerminatingErrorActionDefault
}
#END Update variables based on user profile
##################################