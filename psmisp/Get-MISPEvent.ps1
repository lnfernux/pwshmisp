
<#
.SYNOPSIS
This function retrieves a MISP event.

.DESCRIPTION
The Get-MISPEvent function is used to retrieve a MISP event from a specified MISP instance. It requires authentication headers, MISP URI, MISP organization, MISP event name, and MISP attribute as input parameters.

.PARAMETER AuthHeader
The authentication header to be used for the MISP API request.

.PARAMETER MISPUrl
The URI of the MISP instance.

.PARAMETER MISPOrg
The organization name in MISP.

.PARAMETER MISPEventName
The name of the MISP event to retrieve.

.PARAMETER MISPAttribute
The attribute of the MISP event to retrieve.

.EXAMPLE
$Headers = New-MISPAuthHeader -MISPAuthKey "YOUR_API_KEY"
$MISPUrl = "https://misp.domain"
$MISPOrg = "MyOrg"
$MISPEventName = "Event123"
$MISPAttribute = "Attribute1"

Get-MISPEvent -AuthHeader $Headers -MISPUrl $MISPUrl -MISPOrg $MISPOrg -MISPEventName $MISPEventName -MISPAttribute $MISPAttribute
#>
function Get-MISPEvent {
    param(
      $MISPAuthHeader,
      $MISPUrl,
      $MISPOrg,
      $MISPEventName,
      $MISPAttribute,
      [switch]$SelfSigned
    )
    # Create the endpoint
    $Endpoint = "events/index"
    $MISPUrl = "$MISPUrl/$Endpoint"
    # Create the body of the request
    if($MISPAttribute) {
      Write-Host "Trying to get event with attribute: $($MISPAttribute)"
      $Data = @{
        org = $MISPOrg
        attribute = $MISPAttribute
      }
    } else {
      Write-Host "Trying to get event with title: $($MISPEventName)"
      $Data = @{
        org = $MISPOrg
        eventinfo = $MISPEventName
      }
    }
    if ($SelfSigned) {
      <# Action to perform if the condition is true #>
      $return = Invoke-MISPRestMethod -Headers $MISPAuthHeader -Method "POST" -Body $Data -Uri "$MISPUrl" -SelfSigned
    } else {
      <# Action to perform if the condition is false #>
      $return = Invoke-MISPRestMethod -Headers $MISPAuthHeader -Method "POST" -Body $Data -Uri "$MISPUrl"
    }
    $return = $return.Content | ConvertFrom-Json
    #$returnEvent = $return | Where-Object { $_.info -eq $MISPEventName }
    return $return
  }