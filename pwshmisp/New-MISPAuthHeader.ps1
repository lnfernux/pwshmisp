<#
.SYNOPSIS
Creates an authentication header for MISP API.

.DESCRIPTION
The New-MISPAuthHeader function creates an authentication header for interacting with the MISP API. It takes an authentication key as input and returns a hashtable with the authentication header.

.PARAMETER MISPAuthKey
The authentication key to be used for the MISP API.

.EXAMPLE
$MISPHeader = New-MISPAuthHeader -MISPAuthKey "YOUR_API_KEY"
#>
function New-MISPAuthHeader {
    param(
      $MISPAuthKey
    )
    $Headers = @{
      Authorization = $MISPAuthKey
      Accept = 'application/json'
      'Content-Type' = 'application/json'
    }
    return $Headers
  }