#Start all continuous processes as background job.
#To stop, type 'Get-Job' to find the job ID and 'Stop-Job <ID #>'

(new-object -ComObject wscript.shell).Popup("Start Email and FTP traffic generators.  To stop, type 'Get-Job' to find the job ID and 'Stop-Job <ID #>'",0,"Done",0x1) 
Start-Job -FilePath C:\Scripts\Generate_Email.ps1
Start-Job -FilePath C:\Scripts\Generate-FileTransfer.ps1
