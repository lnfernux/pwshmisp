function Get-MISPAttributeFromEvent {
    PARAM(
        [Parameter(Mandatory = $true)]
        $MISPUrl,
        [Parameter(Mandatory = $true)]
        $MISPAuthHeader,
        [Parameter(Mandatory = $true)]
        $EventId,
        [switch]$SelfSigned
    )
    $Endpoint = "/attributes/restSearch"
    $MISPUrl = "$MISPUrl/$Endpoint"
    Write-Host "Trying to get attributes from event with ID: $($EventId)"
    $Data = @{
      eventid = $EventId
    }
    if($SelfSigned) {
      $return = Invoke-MISPRestMethod -Uri $MISPUrl -Headers $MISPAuthHeader -Method POST -SelfSigned -Body $Data
    } else {
      $return = Invoke-MISPRestMethod -Uri $MISPUrl -Headers $MISPAuthHeader -Method POST -Body $Data
    }
    $return = ($return.content | convertfrom-json).response
    return $return
}