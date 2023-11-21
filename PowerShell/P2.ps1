Get-Service | 
Where-Object { $_.Status -eq "Stopped" } | 
Sort-Object DisplayName | 
Select-Object DisplayName, Status, ServiceName | 
ConvertTo-Csv -NoTypeInformation > StoppedServices.csv