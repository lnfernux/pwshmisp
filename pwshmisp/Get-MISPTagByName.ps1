function Get-MISPTagByName {
    PARAM(
      [Parameter(Mandatory = $true)]
      $MISPUrl,
      [Parameter(Mandatory = $true)]
      $MISPAuthHeader,
      [Parameter(Mandatory = $true)]
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
    Write-Host "Tag ID for $($Tag) is $($return.Tag.id)"
    return $return
  }