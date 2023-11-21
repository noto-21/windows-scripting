Get-Process | 
Where-Object { $_.WS -gt 100MB } | 
Sort-Object WS | 
Select-Object Name, @{Name='MemoryUsageMB'; Expression={($_.WorkingSet / 1MB)}} | 
ConvertTo-Html -Property Name, MemoryUsageMB > MemoryIntensiveProcesses.html