param([String]$CommitMessage)

$files = @(
    [pscustomobject]@{name="yarn-site.xml";location="hdp\hadoop-2.6.0.2.2.4.2-0002\etc\hadoop\yarn-site.xml"},
    [pscustomobject]@{name="mapred-site.xml";location="hdp\hadoop-2.6.0.2.2.4.2-0002\etc\hadoop\mapred-site.xml"},
    [pscustomobject]@{name="hdfs-site.xml";location="hdp\hadoop-2.6.0.2.2.4.2-0002\etc\hadoop\hdfs-site.xml"},
    [pscustomobject]@{name="core-site.xml";location="hdp\hadoop-2.6.0.2.2.4.2-0002\etc\hadoop\core-site.xml"},
    [pscustomobject]@{name="capacity-scheduler.xml";location="hdp\hadoop-2.6.0.2.2.4.2-0002\etc\hadoop\capacity-scheduler.xml"},
    [pscustomobject]@{name="hive-site.xml";location="hdp\hive-0.14.0.2.2.4.2-0002\conf\hive-site.xml"},
    [pscustomobject]@{name="tez-site.xml";location="hdp\tez-0.5.2.2.2.4.2-0002\conf\tez-site.xml"}
)

$nodes = @(
    "\\vide-hadoopm01",
    "\\vide-hadoopm02",
    "\\vide-hadoopm03",
    "\\vide-hadoops01",
    "\\vide-hadoops02",
    "\\vide-hadoops03"
)

if ([string]::IsNullOrEmpty($CommitMessage)) {
    Write-Host "$(Get-Date -Format HH:mm:ss) HDP_Conf: Please provide commit message."
    exit;
}
else {
    Write-Host "$(Get-Date -Format HH:mm:ss) HDP_Conf: Pushing files to GitHub..."
    git config --global http.proxy http://ep-proxy.bportugal.pt:8080
    git add .
    git commit -m $CommitMessage
    git push
    Write-Host "$(Get-Date -Format HH:mm:ss) HDP_Conf: Stopping Hortonworks cluster..."
    Invoke-Command -computername vide-hadoopm01,vide-hadoopm02,vide-hadoopm03,vide-hadoops01,vide-hadoops02,vide-hadoops03 {c:\hdp\stop_local_hdp_services.cmd}
    Write-Host "$(Get-Date -Format HH:mm:ss) HDP_Conf: Copying files to all cluster nodes"
    foreach ($file in $files) {
        foreach ($node in $nodes) {
            Write-Host $("$(Get-Date -Format HH:mm:ss) HDP_Conf: Propagating " + $file.name + " to " + $node)
            cp $("conf\" + $file.name) $($node + "\c$\" + $file.location)
        }
    }
    Write-Host "$(Get-Date -Format HH:mm:ss) HDP_Conf: Starting Hortonworks cluster..."
    Invoke-Command -computername vide-hadoopm01,vide-hadoopm03 {c:\hdp\start_local_hdp_services.cmd}
    Start-Sleep -s 60
    Invoke-Command -computername vide-hadoopm02 {c:\hdp\start_local_hdp_services.cmd}
    Start-Sleep -s 30
    Invoke-Command -computername vide-hadoops01,vide-hadoops02,vide-hadoops03 {c:\hdp\start_local_hdp_services.cmd}
    Write-Host "$(Get-Date -Format HH:mm:ss) HDP_Conf: All Done."
}
