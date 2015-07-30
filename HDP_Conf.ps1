[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=1)]
    [boolean]$Restart,
    [Parameter(Mandatory=$True)]
    [string]$Commit,
    [Parameter(Mandatory=$True)]
    [string]$CommitMessage
)

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
    "\\vide-hadoopm01.bdp.pt",
    "\\vide-hadoopm02.bdp.pt",
    "\\vide-hadoopm03.bdp.pt",
    "\\vide-hadoops01.bdp.pt",
    "\\vide-hadoops02.bdp.pt",
    "\\vide-hadoops03.bdp.pt"
)
if ($Commit -eq $True)
{
    Write-Host "$(Get-Date -Format HH:mm:ss) HDP_Conf: Pushing files to GitHub..."
    git add .
    git commit -m $CommitMessage
    git push
}
if ($Restart -eq $True) {
    Write-Host "$(Get-Date -Format HH:mm:ss) HDP_Conf: Stopping Hortonworks cluster..."
    Invoke-Command -computername vide-hadoopm01.bdp.pt,vide-hadoopm02.bdp.pt,vide-hadoopm03.bdp.pt,vide-hadoops01.bdp.pt,vide-hadoops02.bdp.pt,vide-hadoops03.bdp.pt {c:\hdp\stop_local_hdp_services.cmd}
    Write-Host "$(Get-Date -Format HH:mm:ss) HDP_Conf: Copying files to all cluster nodes"
    foreach ($file in $files) {
        foreach ($node in $nodes) {
            Write-Host $("$(Get-Date -Format HH:mm:ss) HDP_Conf: Propagating " + $file.name + " to " + $node)
            cp $("conf\" + $file.name) $($node + "\c$\" + $file.location)
        }
    }
    Write-Host "$(Get-Date -Format HH:mm:ss) HDP_Conf: Starting Hortonworks cluster..."
    Invoke-Command -computername vide-hadoopm01.bdp.pt,vide-hadoopm03.bdp.pt {c:\hdp\start_local_hdp_services.cmd}
    Start-Sleep -s 60
    Invoke-Command -computername vide-hadoopm02.bdp.pt {c:\hdp\start_local_hdp_services.cmd}
    Start-Sleep -s 30
    Invoke-Command -computername vide-hadoops01.bdp.pt,vide-hadoops02.bdp.pt,vide-hadoops03.bdp.pt {c:\hdp\start_local_hdp_services.cmd}
}
Write-Host "$(Get-Date -Format HH:mm:ss) HDP_Conf: All Done."