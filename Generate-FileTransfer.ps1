Expand-Archive C:\Scripts\PSFTP.zip -DestinationPath C:\Windows\System32\WindowsPowerShell\v1.0\Modules

Import-Module PSFTP

$username = "Anonymous"
$password = Convertto-securestring "anonymous@anonymous.com" -AsPlainText -Force
$FTPcred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password

#Setup session with External FTP server
Set-FTPConnection -Credentials $FTPcred -Server ftp://speedtest.tele2.net -Session MyTestSession -UsePassive 
$Session = Get-FTPConnection -Session MyTestSession 
$files = Get-FTPChildItem -Session $Session -Path / -Recurse -Depth 2
$date = Get-Date -Format MM-dd-yyyy

#Create directory list of files in External FTP server
foreach ($file in $files) {
    if ($file.Name -like "*.zip") {
        $file.name >> C:\Scripts\FTP\ExternalFilelist-$date.txt
    }
}

#Setup session with External FTP server
Set-FTPConnection -Credentials $FTPcred -Server #InternalServer -Session MyTestSession -UsePassive 
$Session = Get-FTPConnection -Session MyTestSession 
$files = Get-FTPChildItem -Session $Session -Path / -Recurse -Depth 2

#Create directory list of files in External FTP server
foreach ($file in $files) {
    if ($file.Name -like "*.zip") {
        $file.name >> C:\Scripts\FTP\InternalFilelist-$date.txt
    }
}


#FTP Upload/Download and Server choice 
while($true) {
    
    #Choose file to upload or download
    $DownloadExternal = Get-Content C:\Scripts\FTP\ExternalFilelist-$date.txt | Get-Random -Count 1
    $DownloadInternal = Get-Content C:\Scripts\FTP\InternalFilelist-$date.txt | Get-Random -Count 1
    $Upload = Get-ChildItem C:\Scripts\FTP\Upload | Get-Random -Count 1
   
    
    #pick to upload or download:
    #1 = Download external
    #2 = Upload external
    #3 = Download internal
    #4 = Upload internal
    $UpOrDown = Get-Random -Minimum 1 -Maximum 5  
    
    if ($UpOrDown -eq 1 -or $UpOrDown -eq 2) {
        Set-FTPConnection -Credentials $FTPcred -Server /18.213.54.20/ -Session MyTestSession -UsePassive 
        $Session = Get-FTPConnection -Session MyTestSession
        if ($UpOrDown -eq 1){
            Get-FTPItem -Path 18.213.54.20 -LocalPath C:\Scripts\FTP\Download\$DownloadExternal
            $DownloadExternal
        }
        else {
            Add-FTPItem -Path /18.213.54.20/ -LocalPath C:\Scripts\FTP\Upload\$Upload
            $Upload
        }
    }
    else {
        Set-FTPConnection -Credentials $FTPcred -Server #internalServer -Session MyTestSession -UsePassive 
        $Session = Get-FTPConnection -Session MyTestSession
        if ($UpOrDown -eq 3) {
            Get-FTPItem -Path #internalServer -LocalPath C:\Scripts\FTP\Download\$DownloadInternal
            $DownloadInternal
            }
        else {
            Add-FTPItem -Path #internalServer -LocalPath C:\Scripts\FTP\Upload\
            $Upload
        }
    }
    $Wait = Get-Random -Minimum 300 -Maximum 450
    Start-Sleep -Seconds $Wait
}    