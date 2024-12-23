
<#
.SYNOPSIS
This function retrieves a MISP event.

.DESCRIPTION
The Get-MISPEvents function is used to retrieve all MISP events from a specified MISP instance. It requires authentication headers, MISP URI, MISP organization, MISP event name, and MISP attribute as input parameters.

.PARAMETER AuthHeader
The authentication header to be used for the MISP API request.

.PARAMETER MISPUrl
The URI of the MISP instance.

.PARAMETER MISPOrg
The organization name in MISP.

.EXAMPLE
$Headers = New-MISPAuthHeader -MISPAuthKey "YOUR_API_KEY"
$MISPUrl = "https://misp.domain"
$MISPOrg = "MyOrg"
$MISPEventName = "Event123"
$MISPAttribute = "Attribute1"

Get-MISPEvent -AuthHeader $Headers -MISPUrl $MISPUrl
#>
function Get-MISPEvents {
    param(
      $MISPAuthHeader,
      $MISPUrl,
      [switch]$SelfSigned
    )
    # Set the endpoint
    Write-Host "Getting all events from MISP"
    $Endpoint = "events/index"
    $MISPUrl = "$MISPUrl/$Endpoint"
    try {
      if ($SelfSigned) {
        <# Action to perform if the condition is true #>
        $return = Invoke-MISPRestMethod -Headers $MISPAuthHeader -Method "GET" -Uri "$MISPUrl" -SelfSigned
      } else {
        <# Action to perform if the condition is false #>
        $return = Invoke-MISPRestMethod -Headers $MISPAuthHeader -Method "GET" -Uri "$MISPUrl"
      }
        $return = $return.content | ConvertFrom-Json
    }
    catch {
      <#Do this if a terminating exception happens#>
      Write-Host "Error: $($_)"
    }
    Write-Host "Found $($return.Count) events"
    return $return
  }