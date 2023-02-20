#$Creds = Get-Credential 

cls
Remove-Module -Name CloudTruth
Import-Module -Name .\src\CloudTruth.psd1 # -Verbose -ArgumentList $true,$true

cls
Connect-CTAPI -Credentials $Creds 

Get-CTUser -ListAvailable

$AllUsers = Get-CTUser -ListAvailable -Ordering "name" -PageSize 1


Get-CTUser -Id "auth0|63a61af1ff196ff71efbb398" -Verbose -Debug

$Test = Get-CTUser -ListAvailable-LoginContext ([pscustomobject]@{Credentials = $Creds}) -PageSize 1   -Verbose -OutputFormat BasicHtmlWebResponseObject