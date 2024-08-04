#Leal Barrera, Nicolas Student ID: 011150100

Set-Location  SQLSERVER:\\\SQL\SRV19-PRIMARY\SQLEXPRESS


$MYDB = (Get-SqlDatabase -ServerInstance "SRV19-PRIMARY\SQLEXPRESS" | Select-Object Name)
$Target = "ClientDB"
$Found = $MYDB | Where-Object {$_.Name -eq $Target}

if ($Found) {
    try {
        $DropDB = Get-SqlDatabase -ServerInstance "SRV19-PRIMARY\SQLEXPRESS" -Name $Target
        $DropDB.Drop()
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

Invoke-Sqlcmd -Server "SRV19-PRIMARY\SQLEXPRESS"   -Query "CREATE DATABASE ClientDB"

