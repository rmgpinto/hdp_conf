$testcases = @(
    [pscustomobject]@{name="TestCaseA1";query="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD"}
)

$day = Get-Date -Format dd-MM
$time = Get-Date -Format HH:mm

foreach ($testcase in $testcases) {
    $QueryScriptBlock = {
        param ($query)
        cd e:
        java -cp ".;C:\hdp\hive-0.14.0.2.2.4.2-0002\lib\*;C:\hdp\tez-0.5.2.2.2.4.2-0002\lib\*;C:\hdp\hadoop-2.6.0.2.2.4.2-0002\share\hadoop\common\*;C:\hdp\hadoop-2.6.0.2.2.4.2-0002\share\hadoop\common\lib\*" HiveJdbcClient "$query" 2>&1 | Out-Null
    }
    Write-Host $("$(Get-Date -Format HH:mm:ss) HDP_TestCases: Starting performance recording of: " + $testcase.name)
    Invoke-Command -ComputerName vide-hadoopm01 {logman start HadoopMon} | Out-Null
    Write-Host $("$(Get-Date -Format HH:mm:ss) HDP_TestCases: Executing query of: " + $testcase.name)
    sqlcmd -S vide-hadoopm01 -Q $("INSERT INTO HadoopPerf.dbo.TestCases (GUID, Name, Day, Time) SELECT TOP 1 GUID, '" + $testcase.name + "', '" + $day + "' as Day, '" + $time + "' as Time FROM HadoopPerf.dbo.DisplayToID ORDER BY LogStartTime desc") | Out-Null
    Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query | Out-Null
    Write-Host $("$(Get-Date -Format HH:mm:ss) HDP_TestCases: Stopping performance recording of: " + $testcase.name)
    Invoke-Command -ComputerName vide-hadoopm01 {logman stop HadoopMon} | Out-Null
}

$2concurrenttestcases = @(
    [pscustomobject]@{name="Concurrent Test Case A1";
                    query1="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query2="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD"}
)

$day = Get-Date -Format dd-MM
$time = Get-Date -Format HH:mm

foreach ($testcase in $testcases) {
    $QueryScriptBlock = {
        param ($query)
        cd e:
        java -cp ".;C:\hdp\hive-0.14.0.2.2.4.2-0002\lib\*;C:\hdp\tez-0.5.2.2.2.4.2-0002\lib\*;C:\hdp\hadoop-2.6.0.2.2.4.2-0002\share\hadoop\common\*;C:\hdp\hadoop-2.6.0.2.2.4.2-0002\share\hadoop\common\lib\*" HiveJdbcClient "$query" 2>&1 | Out-Null
    }
    Write-Host $("$(Get-Date -Format HH:mm:ss) HDP_TestCases: Starting performance recording of: " + $testcase.name)
    Invoke-Command -ComputerName vide-hadoopm01 {logman start HadoopMon} | Out-Null
    Write-Host $("$(Get-Date -Format HH:mm:ss) HDP_TestCases: Executing query of: " + $testcase.name)
    sqlcmd -S vide-hadoopm01 -Q $("INSERT INTO HadoopPerf.dbo.TestCases (GUID, Name, Day, Time) SELECT TOP 1 GUID, '" + $testcase.name + "', '" + $day + "' as Day, '" + $time + "' as Time FROM HadoopPerf.dbo.DisplayToID ORDER BY LogStartTime desc") | Out-Null
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query1 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query2 | Out-Null}
    Write-Host $("$(Get-Date -Format HH:mm:ss) HDP_TestCases: Stopping performance recording of: " + $testcase.name)
    Invoke-Command -ComputerName vide-hadoopm01 {logman stop HadoopMon} | Out-Null
}

$6concurrenttestcases = @(
    [pscustomobject]@{name="Concurrent Test Case A1";
                    query1="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query2="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query3="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query4="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query5="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query6="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD"}
)

$day = Get-Date -Format dd-MM
$time = Get-Date -Format HH:mm

foreach ($testcase in $testcases) {
    $QueryScriptBlock = {
        param ($query)
        cd e:
        java -cp ".;C:\hdp\hive-0.14.0.2.2.4.2-0002\lib\*;C:\hdp\tez-0.5.2.2.2.4.2-0002\lib\*;C:\hdp\hadoop-2.6.0.2.2.4.2-0002\share\hadoop\common\*;C:\hdp\hadoop-2.6.0.2.2.4.2-0002\share\hadoop\common\lib\*" HiveJdbcClient "$query" 2>&1 | Out-Null
    }
    Write-Host $("$(Get-Date -Format HH:mm:ss) HDP_TestCases: Starting performance recording of: " + $testcase.name)
    Invoke-Command -ComputerName vide-hadoopm01 {logman start HadoopMon} | Out-Null
    Write-Host $("$(Get-Date -Format HH:mm:ss) HDP_TestCases: Executing query of: " + $testcase.name)
    sqlcmd -S vide-hadoopm01 -Q $("INSERT INTO HadoopPerf.dbo.TestCases (GUID, Name, Day, Time) SELECT TOP 1 GUID, '" + $testcase.name + "', '" + $day + "' as Day, '" + $time + "' as Time FROM HadoopPerf.dbo.DisplayToID ORDER BY LogStartTime desc") | Out-Null
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query1 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query2 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query3 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query4 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query5 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query6 | Out-Null}
    Write-Host $("$(Get-Date -Format HH:mm:ss) HDP_TestCases: Stopping performance recording of: " + $testcase.name)
    Invoke-Command -ComputerName vide-hadoopm01 {logman stop HadoopMon} | Out-Null
}

$11concurrenttestcases = @(
    [pscustomobject]@{name="Concurrent Test Case A1";
                    query1="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query2="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query3="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query4="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query5="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query6="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query7="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query8="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query9="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query10="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD";
                    query11="SELECT FNNCL_RFRNC_PRD, SUM(OTSTNDNG_NMNL_AMNT) FROM ANACREDIT.F_FNNCL GROUP BY FNNCL_RFRNC_PRD"}
)

$day = Get-Date -Format dd-MM
$time = Get-Date -Format HH:mm

foreach ($testcase in $testcases) {
    $QueryScriptBlock = {
        param ($query)
        cd e:
        java -cp ".;C:\hdp\hive-0.14.0.2.2.4.2-0002\lib\*;C:\hdp\tez-0.5.2.2.2.4.2-0002\lib\*;C:\hdp\hadoop-2.6.0.2.2.4.2-0002\share\hadoop\common\*;C:\hdp\hadoop-2.6.0.2.2.4.2-0002\share\hadoop\common\lib\*" HiveJdbcClient "$query" 2>&1 | Out-Null
    }
    Write-Host $("$(Get-Date -Format HH:mm:ss) HDP_TestCases: Starting performance recording of: " + $testcase.name)
    Invoke-Command -ComputerName vide-hadoopm01 {logman start HadoopMon} | Out-Null
    Write-Host $("$(Get-Date -Format HH:mm:ss) HDP_TestCases: Executing query of: " + $testcase.name)
    sqlcmd -S vide-hadoopm01 -Q $("INSERT INTO HadoopPerf.dbo.TestCases (GUID, Name, Day, Time) SELECT TOP 1 GUID, '" + $testcase.name + "', '" + $day + "' as Day, '" + $time + "' as Time FROM HadoopPerf.dbo.DisplayToID ORDER BY LogStartTime desc") | Out-Null
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query1 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query2 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query3 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query4 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query5 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query6 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query7 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query8 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query9 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query10 | Out-Null}
    Start-Job {Invoke-Command -ComputerName vide-hadoopm01 -ScriptBlock $QueryScriptBlock -ArgumentList $testcase.query11 | Out-Null}
    Write-Host $("$(Get-Date -Format HH:mm:ss) HDP_TestCases: Stopping performance recording of: " + $testcase.name)
    Invoke-Command -ComputerName vide-hadoopm01 {logman stop HadoopMon} | Out-Null
}
