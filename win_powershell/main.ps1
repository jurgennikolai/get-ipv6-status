
$rootPath = 'C:\directory\of\your\script'
$listSRVs = Get-Content -Path "$rootPath\servers.txt";
$pathCSV = "$rootPath\output.csv";

New-Item -Path $pathCSV -ItemType File -Force -Value "Hostname,Status,Comment`n";

foreach($srv in $listSRVs)
{
    Write-Output "* Host >>> $srv";
    try
    {
        $listStatus = Invoke-Command -ComputerName $srv -ScriptBlock {
            (ipconfig /all) | Select-String "IPv6"
        } -ErrorAction Stop

        $listStatusAsString = $listStatus -join ";"

        Add-Content -Path $pathCSV -Value "$srv,$listStatusAsString,Ok";
    }
    catch
    {
        $errTypeName = $_.Exception.GetType().Name ;
        
        Add-Content -Path $pathCSV -Value "$srv,,$errTypeName";
    }
   
}
