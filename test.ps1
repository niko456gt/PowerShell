# Leal Barrera, Nicolas. Student ID: 011150100

 

$MYOU =   (Get-ADOrganizationalUnit -Filter * | Select-Object Name)
$TargetOU ="Finance"

$Found = $MYOU | Where-Object {$_.Name -eq $TargetOU}
$OUDN = (Get-ADOrganizationalUnit -Filter "Name -eq 'Finance' ")

if ($Found) {
    try {
        Remove-ADOrganizationalUnit -Identity $OUDN -Recursive -Confirm:$false
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
New-ADOrganizationalUnit -Name "Finance" -Path "DC=consultingfirm, DC=com" -ProtectedFromAccidentalDeletion $false

#------------------------------------------------------------------------------ part 1 


$CSVUser = Import-Csv "C:\Users\LabAdmin\Desktop\Requirements2\financePersonnel.csv"

foreach($User in $CSVUser){
    $FirstName = $User.First_Name
    $LastName = $User.Last_Name
    $SamAcc = $User.samAccount
    try {
        New-ADUser -GivenName $FirstName -Surname $LastName -SamAccountName $samAccount -Path $OUDN 
        
    }
    catch [System.Exception]{
        Write-Host "System error: $($_.Exception.Message)"
    }catch{
        Write-Host "Unable to register user: $FirstName, $LastName ."
    }

}




