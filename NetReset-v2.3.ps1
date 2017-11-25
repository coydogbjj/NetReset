#DESIRED LOG PATH // THIS WILL BE CREATED IF IT DOES NOT EXIST
$logpath = "C:\NetReset\log"

#CREATE LOG DIRECTORY
If(!(test-path $logpath))
{
New-Item -ItemType Directory -Force -Path $logpath
Write-Host ""
Write-Host "LOG DIRECTORY CREATED" -ForegroundColor Green
}
else{
    Write-Host ""
    Write-Host "LOG DIRECTORY EXISTS" -ForegroundColor Green
}

#PUT LIST OF INTERFACES INTO ARRAY
$adapters = (Get-NetAdapter).name
Write-Host ""
$counter = 1
$adapters | ForEach-Object{
    write-host $counter $_ -ForegroundColor Yellow
    $counter += 1
}

#USER INPUT TO SELECT DESIRED INTERFACE FROM ARRAY LISTING
Write-Host ""
Write-Host "ENTER INTERFACE NUMBER : " -ForegroundColor Yellow -NoNewline
$nicin = Read-Host
$nic = $adapters[$nicin - 1]

#FOREVER WHILE LOOP TO MONITOR INTERFACE
while($true){
    clear
    $test = (Get-NetAdapter -Name "$nic").Status
    if($test -ne "Up"){
        Restart-NetAdapter -Name "$nic"
        Start-Sleep -Seconds 10
        Write-Host ""
        Write-Host "$NIC IS: " -ForegroundColor Yellow -NoNewline
        write-host Disconnected -ForegroundColor Red
        Get-Date | findstr a >> $logpath\$nic.log.txt
        Start-Sleep -Seconds 2
    }
    else{
        Write-Host ""
        Write-Host "$NIC IS: " -ForegroundColor Yellow -NoNewline
        write-host Connected -ForegroundColor Green
        Start-Sleep -Seconds 2
    }
}