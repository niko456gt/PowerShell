$OUName = "OU=Finance, DC=consultingfirm, DC=com"

 

$MYOU =   (Get-ADOrganizationalUnit -Filter * | Select-Object Name)
$TargetOU ="Finance"

$Found = $MYOU | Where-Object {$_.Name -eq $TargetOU}
$OUDN = (Get-ADOrganizationalUnit -Filter "Name -eq 'Finance' ")

if ($Found) {
    try {
        Remove-ADOrganizationalUnit -Identity $OUDN -Recursive
    }
    catch [System.DirectoryServices.DirectoryServicesPermission] {
        Write-Error " Not enought permissions to execute deletion"
    }
    catch {
        Write-Host "Something went wrong : $_"
    }
    Write-Host "The Ou Finance was deleted succesfully"
    
}else {
    Write-Host "$TargetOU does not exist"
}


Write-Host " Creating OU Finance"




