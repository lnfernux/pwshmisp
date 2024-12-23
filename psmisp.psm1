$psmisp  = @(Get-ChildItem -Path $PSScriptRoot\psmisp\*.ps1 -ErrorAction SilentlyContinue)
foreach ($import in @($psmisp))
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