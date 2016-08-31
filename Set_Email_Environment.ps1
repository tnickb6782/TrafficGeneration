# must be run as VIRTUAL USER.
# Set Exchange Server address and store credentials for VIRTUAL USER.  
# Only needed once per machine as long as not reverted to snapshot prior to execution as long as user remains the same.

#Allow unsigned scripts to run
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

(new-object -ComObject wscript.shell).Popup("Run as Virtual User, Only run once per machine",0,"Done",0x1) 
$credential = Get-Credential #store credential for future use, must input password once
$credential.Password | ConvertFrom-SecureString | Set-Content C:\Scripts\password.txt #store password in encrypted file for future use