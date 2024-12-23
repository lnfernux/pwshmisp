$pwshmisp  = @(Get-ChildItem -Path $PSScriptRoot\pwshmisp\*.ps1 -ErrorAction SilentlyContinue)
foreach ($import in @($pwshmisp))
{
    try
    {
        . $import.FullName
    }
    catch
    {
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }
    
}