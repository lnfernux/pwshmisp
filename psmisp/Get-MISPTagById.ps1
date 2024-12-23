function Get-MISPTagById {
    PARAM(
      $MISPUrl,
      $MISPAuthHeader,
      $Id,
      [switch]$SelfSigned
    )
    $Endpoint = "tags/view/$Id"
    $MISPUrl = "$MISPUrl/$Endpoint"
    Write-Host "Trying to get tag with ID: $($Id)"
    if($SelfSigned) {
      $return = Invoke-MISPRestMethod -Uri $MISPUrl -Headers $MISPAuthHeader -Method GET -SelfSigned
    } else {
      $return = Invoke-MISPRestMethod -Uri $MISPUrl -Headers $MISPAuthHeader -Method GET
    }
    $return = ($return.content | convertfrom-json)
    Write-Host "Tag with ID $($Id) is $($return.name)"
    return $return
  }