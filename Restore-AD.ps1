# Leal Barrera, Nicolas. Student ID: 011150100

 

$MYOU =   (Get-ADOrganizationalUnit -Filter * | Select-Object Name) #Look for a OU with fqdn
$TargetOU ="Finance" # the ou objective

$Found = $MYOU | Where-Object {$_.Name -eq $TargetOU} # if there is a objetive ou procede to deletion
$OUDN = (Get-ADOrganizationalUnit -Filter "Name -eq 'Finance' ") #save in variable the fqdn

if ($Found) { #create if for the deletion of the ou if existing, else tell customer it did not exist and procede 
    try {
        Remove-ADOrganizationalUnit -Identity $OUDN -Recursive -Confirm:$false
    }
    catch [System.DirectoryServices.DirectoryServicesPermission] {
        Write-Error " Not enought permissions to execute deletion"
    }
    catch {
        Write-Host "Something went wrong : $_"
    }
    Write-Host "The OU Finance was deleted succesfully"
    
}else {
    Write-Host "$TargetOU does not exist"
}


Write-Host " Creating OU Finance"
New-ADOrganizationalUnit -Name "Finance" -Path "DC=consultingfirm, DC=com" -ProtectedFromAccidentalDeletion $false #create OU without human intervention

#------------------------------------------------------------------------------ part 1 


$CSVUser = Import-Csv ".\financePersonnel.csv"  #load the CSV to memory

foreach($User in $CSVUser){   #Create a data structure for all the variables that are going to be loaded to the ldap
    $FirstName = $User.First_Name
    $LastName = $User.Last_Name
    $SamAccount = $User.samAccount
    $DisName = "$FirstName  $LastName"
    $postal = $User.PostalCode
    $Office = $User.OfficePhone
    $Mobil = $User.MobilePhone

    try {
        New-ADUser -GivenName $FirstName -Surname $LastName -SamAccountName $SamAccount -Name $DisName -DisplayName $DisName -PostalCode $postal -OfficePhone $Office -MobilePhone $Mobil  -Path $OUDN 
        # Script is goint to try to add a user if variables exists 
    }
    catch [System.Exception]{
        Write-Host "System error: $($_.Exception.Message)" #Aplly exception handling 
    }catch{
        Write-Host "Unable to register user: $FirstName, $LastName ."
    }

}
Get-ADUser -Filter * -SearchBase "ou=Finance,dc=consultingfirm,dc=com" -Properties DisplayName,PostalCode,OfficePhone,MobilePhone > .\AdResults.txt

#This command is mandatory by rule D-5 of the task 2 


