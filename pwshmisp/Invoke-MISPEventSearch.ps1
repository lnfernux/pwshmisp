
<#
.SYNOPSIS
Performs a search on MISP events based on specified filter criteria.

.DESCRIPTION
The Invoke-MISPEventSearch function sends a search request to the MISP instance using the provided filter criteria. The function constructs the request body from the filter object, sends the request, and processes the response to filter out unwanted tags and organizations.

.PARAMETER AuthHeader
The authorization header required to authenticate with the MISP instance.

.PARAMETER MISPUrl
The base URI of the MISP instance.

.PARAMETER Filter
A JSON string containing the filter criteria for the search. The filter can include parameters such as published status, warning list enforcement, event tags, publish timestamp, organizations, and more. Currently, the function supports the following filter parameters:
- published: 1 or 0
- enforceWarninglist: "True" or "False"
- includeEventTags: "True" or "False"
- last: timestamp (14d default)
- tags: array of tags to include
- not_tags: array of tags to exclude
- org: array of organizations to include
- not_org: array of organizations to exclude
- excludeLocalTags: "True" or "False"

.EXAMPLE
$authHeader = @{
    "Authorization" = "YOUR_API_KEY"
}
$MISPUrl = "https://misp-instance.com"
$filter = '{
    "published": 1,
    "tags": ["tag1", "tag2"],
    "orgs": ["org1"]
}'
Invoke-MISPEventSearch -AuthHeader $authHeader -MISPUrl $MISPUrl -Filter $filter
#>
function Invoke-MISPEventSearch {
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
    $Endpoint = "events/restSearch"
    $MISPUrl = "$MISPUrl/$Endpoint"
    # Create the body of the request - the filter object will contain what we want to search for
    $FilterObject = $Filter | ConvertFrom-Json
    # Create the data object

    # First, is published set to true or false?
    $Published = if($FilterObject.published -eq 1) { $FilterObject.published} else { $false }

    # enforceWarninglist
    $EnforceWarninglist = if($FilterObject.enforceWarninglist -eq "True") { $FilterObject.enforceWarninglist} else { $false }

    # includeEventTags
    $IncludeEventTags = if($FilterObject.includeEventTags -ne $null) { $FilterObject.includeEventTags} else { $null }

    # last
    $PublishTimestamp = if($FilterObject.last -ne $null) { $FilterObject.last} else { $null }

    # Tags
    $Tags = if($FilterObject.tags -ne $null) { $FilterObject.tags} else { $null }

    # Not tags
    $NotTags = if($FilterObject.not_tags -ne $null) { $FilterObject.not_tags} else { $null }

    # Orgs
    $Orgs = if($FilterObject.orgs -ne $null) { $FilterObject.orgs} else { $null }

    # Not orgs
    $NotOrgs = if($FilterObject.not_orgs -ne $null) { $FilterObject.not_org} else { $null }

    # exclude Local Tags
    $ExcludeLocalTags = if($FilterObject.excludeLocalTags -eq "True") { $FilterObject.excludeLocalTags} else { $false }

    # data object
    $Data = @{
      published = $Published
      enforceWarninglist = $EnforceWarninglist
      includeEventTags = $IncludeEventTags
      last = $PublishTimestamp
      event_tags = $Tags
      org = $Orgs
      excludeLocalTags = $ExcludeLocalTags
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
    # Filter out unwanted tags
    if ($NotTags -ne $null) {
        $return = $return | Where-Object {
            $includeEvent = $true
            foreach ($tag in $_.EventTag.Tag) {
                if ($NotTags -contains $tag.Name.Trim()) {
                    $includeEvent = $false
                    break
                }
            }
            $includeEvent
        }
    }
    
    # Filter out unwanted organizations
    if ($NotOrgs -ne $null) {
        $return = $return | Where-Object { $NotOrgs -notcontains $_.Org.Name }
    }
    return $return
  }