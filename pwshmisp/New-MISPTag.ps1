<#
.SYNOPSIS
    Creates a new MISP tag.

.DESCRIPTION
    The New-MISPTag function sends a POST request to the MISP API to create a new tag with the specified parameters.

.PARAMETER Name
    The name of the tag.

.PARAMETER Colour
    The colour of the tag in hexadecimal format.

.PARAMETER Exportable
    Indicates whether the tag is exportable.

.PARAMETER OrgId
    The ID of the organization creating the tag.

.PARAMETER UserId
    The ID of the user creating the tag.

.PARAMETER HideTag
    Indicates whether the tag should be hidden.

.PARAMETER NumericalValue
    The numerical value associated with the tag.

.PARAMETER IsGalaxy
    Indicates whether the tag is a galaxy.

.PARAMETER IsCustomGalaxy
    Indicates whether the tag is a custom galaxy.

.PARAMETER Inherited
    Indicates whether the tag is inherited.

.PARAMETER MISPUrl
    The base URL of the MISP instance.

.PARAMETER MISPAuthHeader
    The authorization header for the MISP API.

.PARAMETER SelfSigned
    Indicates whether to allow self-signed certificates.

.RETURNS
    The response from the MISP API.

.EXAMPLE
    $response = New-MISPTag -Name "tlp:white" -Colour "#ffffff" -Exportable $true -OrgId "12345" -UserId "12345" -HideTag $false -NumericalValue 12345 -IsGalaxy $true -IsCustomGalaxy $true -Inherited 1 -MISPUrl "https://misp.local" -MISPAuthHeader $authHeader -SelfSigned

.NOTES
    This function requires the Invoke-MISPRestMethod function to be defined elsewhere in your script or module.
#>
function New-MISPTag 
{
    param (
        [string]$Name,
        [string]$Colour,
        [bool]$Exportable = $true,
        [string]$OrgId,
        [string]$UserId,
        [bool]$HideTag = $false,
        [int]$NumericalValue,
        [bool]$IsGalaxy = $true,
        [bool]$IsCustomGalaxy = $true,
        [int]$Inherited = 1,
        [bool]$LocalOnly = $false,
        $MISPUrl,
        $MISPAuthHeader,
        [switch]$SelfSigned
    )
    # Create the payload, allow for null values
    $payload = @{
            name = $Name
            colour = $Colour
            exportable = $Exportable
            org_id = $OrgId
            user_id = $UserId
            hide_tag = $HideTag
            numerical_value = $NumericalValue
            is_galaxy = $IsGalaxy
            is_custom_galaxy = $IsCustomGalaxy
            inherited = $Inherited
            local_only = $LocalOnly
    } 

    if ($SelfSigned) {
        <# Action to perform if the condition is true #>
        $response = Invoke-MISPRestMethod -Headers $MISPAuthHeader -Method "POST" -Body $payload -Uri "$MISPUrl/tags/add" -SelfSigned
    } else {
        <# Action to perform if the condition is false #>
        $response = Invoke-MISPRestMethod -Headers $MISPAuthHeader -Method "POST" -Body $jsonPayload -Uri "$MISPUrl/tags/add"
    }
    $response = $response.content | ConvertFrom-Json
    Write-Host "Created tag $($Name) with ID $($response.Tag.Id)"
    return $response
}