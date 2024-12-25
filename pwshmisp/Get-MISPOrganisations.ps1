<#
.SYNOPSIS
Retrieves a list of organisations from the MISP instance.

.DESCRIPTION
The Get-MISPOrganisations function connects to a MISP (Malware Information Sharing Platform) instance and retrieves a list of organisations. This can be useful for managing and viewing the organisations that are part of the MISP instance.

.EXAMPLE
PS C:\> Get-MISPOrganisations
This command retrieves and displays the list of organisations from the MISP instance.

.PARAMETER None
This function does not take any parameters.

.OUTPUTS
System.Object
The function returns a list of organisations from the MISP instance.

#>
function Get-MISPOrganisations {
    param( 
        [Parameter(Mandatory = $true)]
        $MISPUrl,
        [Parameter(Mandatory = $true)]
        $MISPAuthHeader,
        [switch]$SelfSigned
    )
    # Set the endpoint
    Write-Host "Getting all organisations from MISP"
    $Endpoint = "organisations"
    $MISPUrl = "$MISPUrl/$Endpoint"
    try {
        if ($SelfSigned) {
            $return = Invoke-MISPRestMethod -Headers $MISPAuthHeader -Method "GET" -Uri "$MISPUrl" -SelfSigned
        } else {
            $return = Invoke-MISPRestMethod -Headers $MISPAuthHeader -Method "GET" -Uri "$MISPUrl"
        }
    }
    catch {
        Write-Host "Error: $($_)"
    }
    $return = $return.Content | ConvertFrom-Json
    Write-Host "Found $($return.Count) organisations"
    return $return
}