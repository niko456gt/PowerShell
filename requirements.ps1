#  Leal Barrera, Nicolas Student ID: 011150100


$mainMenu = "Main menu:
----------
1) List files using a regex
2) List files & Save in file
3) CPU & Memory Usage
4) List running Processes
5) EXIT"
# Created a User friendly menu with all the available options.








Write-Host "You select option $UserOption!" # Confirm the user selections.




#Script is going to be inside a infinte loop until Customer press option 5 which will finish the script
while ($True) {
    Write-Host $mainMenu
    $UserOption = Read-Host "Please select a valid option from the menu by typing the number, then enter" # Promt the user to select one of the available options 

    switch ($UserOption){  #Start the Switch statement with the user selection
        1{
            Get-ChildItem -Path $PSScriptRoot -Filter "*.log"  #Use the regex to find the requested extension files
            $LogDate =  Get-Date
            $LogDate = $LogDate.ToString("yyyy-MM-dd HH:mm:ss")
            $LogFiles = Get-ChildItem -Path $PSScriptRoot -Filter "*.txt" 
            $LogFiles = $LogFiles -join ", " 
            $LogWriter = "$LogDate : $LogFiles " # Create a variable that handles all the information that need to be logged 
            Add-Content -Path $PSScriptRoot\DailyLog.txt -Value $LogWriter  # Append the log variablel into the dailylog file
            
        }
        2{
            Get-ChildItem -Path $PSScriptRoot | Sort-Object Name   | Format-Table Name  # Get child item brings all the files of the selected path, then it get sorted by name and formated 
            Get-ChildItem -Path $PSScriptRoot | Sort-Object Name   | Format-Table Name | Out-File -FilePath "$PSScriptRoot\C916contents.txt" # Direct the output into the desired file
            Write-Host "Informatio saved to file C916contents.txt"
    
        }
        3{
            Write-Host "option 3 statement"
            Get-Counter "\Memory\available MBytes" # Use of the cmdl to get the usage of memory
            Get-Counter "\Processor(_Total)\% Processor Time" # same cmdl to get the processor avg usage 
        }
        4{
            try{ # apply a error handling for system out of memory 
                Get-Process | Select-Object  -Property Name,VirtualMemorySize64 |Sort-Object -Property VirtualMemorySize64 -Descending | Out-GridView # Get a Grid view of the running processes sorted as required
                Write-Host "Printed!"
            } catch [system.OutOfMemoryException] {
                write-host "The system run out of memory "

            }catch{
                Write-Host "An unexpected error occurred: $($_.Exception.Message)"
            }
        }
        5{
            Write-Host "EXITING " 

             
        }
        default{
            Write-Host "Invalid option, please try again"# make only the options mentioned the available ones, other options get discarted
        }
    }
    if($UserOption -eq "5"){
        break # If customer press option 5 exit the script
    }

    
    
}
