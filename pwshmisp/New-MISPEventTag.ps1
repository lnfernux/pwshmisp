
<#
.SYNOPSIS
Adds a tag to a MISP event.

.DESCRIPTION
This function adds a tag to a MISP event specified by the MISPEventID. It uses the MISP API to perform the operation.

.PARAMETER MISPUrl
The URL of the MISP instance.

.PARAMETER MISPAuthHeader
The authentication header for accessing the MISP API.

.PARAMETER MISPEventID
The ID of the MISP event to which the tag should be added.

.PARAMETER MISPTagId
The ID of the tag to be added to the MISP event.

.PARAMETER LocalOnly
Specifies whether the tag should be added locally only. If this switch is used, the tag will not be synced with other MISP instances.

.EXAMPLE
Add-MISPEventTag -MISPUrl "https://misp.example.com" -MISPAuthHeader "Bearer ABC123" -MISPEventID 12345 -MISPTagId 6789

This example adds the tag with ID 6789 to the MISP event with ID 12345.

#>
function New-MISPEventTag {
    PARAM(
      $MISPUrl,
      $MISPAuthHeader,
      $MISPEventID,
      $MISPTagId,
      [switch]$LocalOnly,
      [switch]$SelfSigned
    )
    # Which MISP API Endpoint we are working against
    $Endpoint = "events/addTag/$MISPEventID/$MISPTagId"
  
    # Create the body of the request
    $MISPUrl = "$MISPUrl/$Endpoint"
  
    # Check local only, add local only if true
    if($LocalOnly) {
      $MISPUrl = $MISPUrl+"/local:1"
    }
  
    # Invoke the REST method
    Write-Host "Trying to add tag $MISPTagId to event $MISPEventID"
    if($SelfSigned) {
      $return = Invoke-MISPRestMethod -Uri $MISPUrl -Headers $MISPAuthHeader -Method Post -SelfSigned
    } else {
      $return = Invoke-MISPRestMethod -Uri $MISPUrl -Headers $MISPAuthHeader -Method Post
    }
    return $return
  }