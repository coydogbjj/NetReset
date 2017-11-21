#AMOUNT OF SECONDS TO SLEEP AFTER RESETTING NETWORK CONNECTION
$seconds = "10"

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
$adapters = Get-NetAdapter | Format-List Name | findstr Name
$array = $adapters -replace 'Name : ',''
Write-Host ""
$counter = 1
$array | ForEach-Object{
    write-host $counter $_ -ForegroundColor Yellow
    $counter += 1
}

#USER INPUT TO SELECT DESIRED INTERFACE FROM ARRAY LISTING
Write-Host ""
Write-Host "ENTER INTERFACE NUMBER : " -ForegroundColor Yellow -NoNewline
$nicin = Read-Host
$nic = $array[$nicin - 1]

#FOREVER WHILE LOOP TO MONITOR INTERFACE
while($true){
    clear
    $test = Get-NetAdapter -Name $nic | Format-List Status | findstr Status
    $testarray = $test -replace 'Status : ',''
    if($testarray -ne "Up"){
        Restart-NetAdapter -Name "$nic"
        Start-Sleep -Seconds $seconds
        Write-Host ""
        Write-Host "$NIC IS: " -ForegroundColor Yellow
        write-host Disconnected -ForegroundColor Red
        Get-Date | findstr a >> $logpath\$nic.log.txt
        Start-Sleep -Seconds 2
    }
    else{
        Write-Host ""
        Write-Host "$NIC IS: " -ForegroundColor Yellow
        write-host Connected -ForegroundColor Green
        Start-Sleep -Seconds 2
    }
}
