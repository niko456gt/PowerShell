#Leal Barrera, Nicolas Student ID: 011150100

Set-Location  SQLSERVER:\SQL\SRV19-PRIMARY\SQLEXPRESS



$MYDB = (Get-SqlDatabase -ServerInstance "SRV19-PRIMARY\SQLEXPRESS" | Select-Object Name)

$Target = "ClientDB"
$Found = $MYDB | Where-Object {$_.Name -eq $Target}

if ($Found) {
    try {
        $CurrentSessions = Invoke-Sqlcmd -ServerInstance "SRV19-PRIMARY\SQLEXPRESS" -Query "SELECT session_id, host_name
        FROM sys.dm_exec_sessions
        WHERE host_name =  'SRV19-PRIMARY';"
        foreach ($CurrentSessions in $CurrentSessions.session_id) {
            Invoke-Sqlcmd -ServerInstance "SRV19-PRIMARY\SQLEXPRESS" -Query "KILL $CurrentSessions"
        }
        Invoke-Sqlcmd -Query "DROP DATABASE ClientDB"
        Write-Host "$Target Deleted from server"
    }
    catch [System.Exception]{
        Write-Host "Something went wrong $($_.Exception.Message)"
    }
    catch {
        Write-Host "Somethign went wrong: $_ "
    }
}else {
    Write-Host "$Target does not exist"
}

Write-Host "Creating DB $Target"

Invoke-Sqlcmd -ServerInstance ".\SQLEXPRESS" -Query "CREATE DATABASE ClientDB"
Write-Host "DB Created"
$Create = "CREATE TABLE Client_A_Contacts (
    first_name varchar(50),
    last_name varchar(50),
    city varchar(50),
    county varchar(50),
    zip int,
    office_phone varchar(15),
    mobile varchar(15)
);"

Write-Host "Creating Table..."
Invoke-Sqlcmd  -ServerInstance "SRV19-PRIMARY\SQLEXPRESS" -Database "ClientDB" -Query "$Create"
# first_name,last_name,city,county,zip,officePhone,mobilePhone

Write-Host "Table Created"
Set-Location  "$PSScriptRoot"
$CSVUser = Import-Csv ".\NewClientData.csv"

foreach($User in $CSVUser){   #Create a data structure for all the variables that are going to be loaded to the db
    $FirstName = $User.first_Name
    $LastName = $User.last_Name
    $City = $User.city
    $County = $User.county     
    $Postal = $User.zip
    $Office = $User.officePhone
    $Mobil = $User.mobilePhone

    $data = "INSERT INTO Client_A_Contacts  (first_name, last_name, city, county, zip, office_phone, mobile)
             VALUES ('$FirstName' , '$LastName' , '$City' , '$County' , '$Postal' , '$Office' , '$Mobil');    "

    try {
        Invoke-Sqlcmd -ServerInstance "SRV19-PRIMARY\SQLEXPRESS"  -Database "ClientDB" -Query "$data" 
        # Script is goint to try to add a user if variables exists 
    }
    catch [System.Exception]{
        Write-Host "System error: $($_.Exception.Message)" #Aplly exception handling 
    }catch{
        Write-Host "Unable to register user: $FirstName, $LastName ."
    }

}
Invoke-Sqlcmd -Database ClientDB -ServerInstance.\SQLEXPRESS -Query 'SELECT * FROM dbo.Client_A_Contacts' > .\SqlResults.txt