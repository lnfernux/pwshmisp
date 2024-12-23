function Get-MISPTagByName {
    PARAM(
      $MISPUrl,
      $MISPAuthHeader,
      $Tag,
      [switch]$SelfSigned
    )
    $Endpoint = "tags/search/$Tag"
    $MISPUrl = "$MISPUrl/$Endpoint"
    Write-Host "Trying to get ID for tag: $($Tag)"
    if($SelfSigned) {
      $return = Invoke-MISPRestMethod -Uri $MISPUrl -Headers $MISPAuthHeader -Method Get -SelfSigned
    } else {
      $return = Invoke-MISPRestMethod -Uri $MISPUrl -Headers $MISPAuthHeader -Method Get
    }
    $return = ($return.content | convertfrom-json)
    Write-Host "Tag ID for $($Tag) is $($return.id)"
    return $return
  }