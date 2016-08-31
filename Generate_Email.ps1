# Generate Email to all users listed in the AccoutList.txt file.  All files pertaining to this should be in the c:\Scripts directory.
# Email generator
# Loop runs continuously, only executes between the hours of 8AM and 5 PM.
# Leave this Powershell session running

(new-object -ComObject wscript.shell).Popup("Start sending emails? This will run indefinitely until stopped (CTRL+C)",0,"Done",0x1)
$emails_sent = 0
$PSEmailServer = 'cybertropolis.city.nw' #cybertropolis exchange serve
$password = Get-Content C:\Scripts\password.txt | ConvertTo-SecureString
$credential = New-Object System.Management.Automation.PSCredential $env:USERDOMAIN/$env:USERNAME ,$password
while($true)
{
    # Only run during work hours
    if ((get-date).hour -ge 8 -and (get-date).hour -lt 17) { 
        
    #Picks a random "To" address to send the email
    $ToAddress = Get-Content "C:\Scripts\AccountList.txt" | Get-Random -Count 1 #build list of accounts, could be replaced with a Get-ADUser command
    
    #Picks a random subject line
    $Subject = Get-Content "C:\Scripts\SubjectList.txt" | Get-Random -Count 1 #build list of subjects, random word list or something
    
    #Picks random body content
    $Body = Get-Content "C:\Scripts\BodyList.txt" | Get-Random -Count 1 #parse email body lists
    
    #Picks a random attachment to add to the email.  Need to identify the storage location for the documents
    $attachment = Get-ChildItem C:\Scripts\Attachments | Get-Random -Count 1
    $Num = Get-Random -Minimum 1 -Maximum 8
    
    #Picks a backoff period before sending a new email between 5 and 12 minutes
    $Wait = Get-Random -Minimum 300 -Maximum 420
    
    if ($Num -eq 1) {
        # Selects 1 in 7 emails to add an attachment
        Start-Sleep -Seconds $Wait
        #Picks a random attachment to add to the email.  Need to identify the storage location for the documents
        $attachment = Get-ChildItem C:\Scripts\Attachments | Get-Random -Count 1
        Send-MailMessage -Port 587 -Credential $credential -UseSsl -From $env:USERNAME+'@'+$PSEmailServer -To $ToAddress -Subject $Subject -Body $Body -Attachments $attachment
        }
    else {
        # The rest of emails will not contain an attachment
        Start-Sleep -Seconds $Wait
        Send-MailMessage -Port 587 -Credential $credential -UseSsl -From $env:USERNAME+'@'+$PSEmailServer -To $ToAddress -Subject $Subject -Body $Body
        }
    
    # Track number of emails sent
    $emails_sent+=1
    $emails_sent
    }
    Else {
    # Wait 15 minutes before trying again
    Start-Sleep -Seconds 900
    }
}