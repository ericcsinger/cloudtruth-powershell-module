######################################
#START: Default Profile
[ordered]@{
    #This is the directory of where executables like pg_dump.exe and psql.exe are located
    ExecutablesPath = "$($env:ProgramFiles)\pgAdmin 4\v6\runtime"

    #If you want to set a default PosgreSQL server name
    Server  = $null

    #If you want to set a default PosgreSQL server port
    Port  = "5432"

    #If you want to set a default PosgreSQL database to execute queries from
    Database = "postgres"

    <#This is the data type our functions will return to PowerShell for consumption 
    - 'CSV' 
    - 'HTML'
    - 'Object' *Default, this would be a typical PowerShell object.  We'll actually have PSQL return its results as a CSV and then convert them to an object
    - 'JSON'
    - 'YAML'
    #>
    OutputFormat = 'Object'

}
#END: Default Profile
######################################