function Get-MISPTags {
    PARAM(
      [Parameter(Mandatory = $true)]
      $MISPUrl,
      [Parameter(Mandatory = $true)]
      $MISPAuthHeader,
      [switch]$SelfSigned
    )
    $Endpoint = "tags"
    $MISPUrl = "$MISPUrl/$Endpoint"
    Write-Host "Trying to get all tags"
    if($SelfSigned) {
      $return = Invoke-MISPRestMethod -Uri $MISPUrl -Headers $MISPAuthHeader -Method GET -SelfSigned
    } else {
      $return = Invoke-MISPRestMethod -Uri $MISPUrl -Headers $MISPAuthHeader -Method GET
    }
    # parse the output from .content
    $return = $return.content | ConvertFrom-Json
    Write-Host "Found $($return.Tag.Count) tags"
    return $return
  }