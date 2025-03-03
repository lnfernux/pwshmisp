
function Invoke-MISPAttributeSearch {
    param(
      [Parameter(Mandatory = $true)]
      $MISPAuthHeader,
      [Parameter(Mandatory = $true)]
      $MISPUrl,
      [Parameter(Mandatory = $true)]
      $Filter,
      [switch]$SelfSigned
    )
    # Create the endpoint
    $Endpoint = "attributes/restSearch"
    $MISPUrl = "$MISPUrl/$Endpoint"
    # Create the body of the request - the filter object will contain what we want to search for
    $FilterObject = $Filter | ConvertFrom-Json
    # Create the data object

    # First, is published set to true or false?
    $Published = if($FilterObject.published -eq 1) { $FilterObject.published} else { $false }

    # last
    $Last = if($FilterObject.last -ne $null) { $FilterObject.last} else { $null }

    # Tags
    $Tags = if($FilterObject.tags -ne $null) { $FilterObject.tags} else { $null }

    # eventId
    $EventId = if($FilterObject.eventid -ne $null) { $FilterObject.eventId} else { $null }

    # sharing group
    $SharingGroup = if($FilterObject.sharingGroup -ne $null) { $FilterObject.sharingGroup} else { $null }

    # category
    $Category = if($FilterObject.category -ne $null) { $FilterObject.category} else { $null }

    # type
    $Type = if($FilterObject.type -ne $null) { $FilterObject.type} else { $null }

    # value
    $Value = if($FilterObject.value -ne $null) { $FilterObject.value} else { $null }

    # Page
    $Page = if($FilterObject.page -ne $null) { $FilterObject.page} else { $null }

    # Limit
    $Limit = if($FilterObject.limit -ne $null) { $FilterObject.limit} else { $null }

    # Enforce warninglist
    $enforceWarningslist = if($FilterObject.enforceWarninglist -ne $null) { $FilterObject.enforceWarninglist} else { $null }

    # data object
    $Data = @{
      published = $Published
      last = $Last
      tags = $Tags
      value = $Value
      category = $Category
      type = $Type
      eventid = $EventId
      sharinggroup = $SharingGroup
      page = $Page
      limit = $Limit
      enforceWarninglist = $enforceWarningslist
    }
    if($SelfSigned) {
      $return = Invoke-MISPRestMethod -Headers $MISPAuthHeader -Method "POST" -Body $Data -Uri "$MISPUrl" -SelfSigned
    } else {
      $return = Invoke-MISPRestMethod -Headers $MISPAuthHeader -Method "POST" -Body $Data -Uri "$MISPUrl"
    }
    # check if return is empty
    $return = $return.content | ConvertFrom-Json
    if($return -eq $null) {
      Write-Host "No events found"
      return
    }
    return $return
}
