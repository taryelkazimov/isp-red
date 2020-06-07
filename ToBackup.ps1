do {$res = Test-Connection -BufferSize 32 -Count 1 -TargetName 8.8.8.8 -Quiet; 
    if ($res -eq $true)
        {
            Write-Host "Primary ISP is UP"
        } 
    else 
        {
            Write-Host "Primary ISP is DOWN!!! Swithcing to Backup ISP"
            Start-Sleep 5

            $primaryInterface = "/etc/sysconfig/network-scripts/ifcfg-ens192"
            $backupInterface = "/etc/sysconfig/network-scripts/ifcfg-ens37"

            $primaryInterfaceName = "ens192"
            $backupInterfaceName = "ens37"

            $primaryGW = "GATEWAY=10.0.1.241"
            $backupGw = "GATEWAY=10.0.4.242"

            $removeGateway = Get-Content $primaryInterface | Select-String -Pattern "GATEWAY" -NotMatch
	    $removeGateway | Set-Content $primaryInterface 
		
	    Add-Content -Path $backupInterface -Value $backupGw

	    ifdown $primaryInterface && ifup $primaryInterface
            ifdown $backupInterface  && ifup $backupInterface
        }; 
start-sleep 2
} 
While ($res -eq $true)