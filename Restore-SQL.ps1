#Leal Barrera, Nicolas Student ID: 011150100


$ServerName = "SRV19-PRIMARY\SQLEXPRESS"
$Connection = New-Object System.Data.SqlClient.SqlConnection("Server=$ServerName;Integrated Security=True;")
$Connection.Open()

Invoke-Sqlcmd -ServerInstance $ServerName -Query "SELECT name FROM sys.databases"


$Connection.Close()


