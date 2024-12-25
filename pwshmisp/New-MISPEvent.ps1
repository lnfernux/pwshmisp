<#
.SYNOPSIS
Creates an event in a MISP instance.

.DESCRIPTION
The New-MISPEvent function is used to create an event in a MISP (Malware Information Sharing Platform) instance. It first checks if an event with the same name already exists in the MISP instance. If it does, it simply returns the existing event. If not, it creates a new event with the provided parameters.

.PARAMETER MISPUrl
The URL of the MISP instance.

.PARAMETER MISPAuthHeader
The authentication header for the MISP instance.

.PARAMETER MISPEventPublisher
The publisher of the event.

.PARAMETER MISPTagsId
An array of tag IDs for the event.

.PARAMETER MISPOrg
The organization ID for the event.

.PARAMETER MISPEventName
The name of the event.

.PARAMETER Publish
A switch to indicate whether the event should be published.

.PARAMETER Distribution
The distribution of the event.

.EXAMPLE
New-MISPEvent -MISPUrl "https://misp.example.com" -MISPAuthHeader $AuthHeader -MISPEventPublisher "publisher@example.com" -MISPTagsId @("tag1", "tag2") -MISPOrg 1234 -MISPEventName "Test Event" -Publish $true -Distribution 3 -Attributes @(@{Attribute = "malware"; Type = "string"; Category = "Payload delivery"; Comment = "This is a test attribute"})

This example creates an event with the name "Test Event", published by "publisher@example.com", with the tags "tag1" and "tag2", for the organization with ID 1234, and with a distribution of 3, in the MISP instance at "https://misp.example.com".

#>
function New-MISPEvent {
    PARAM(
      [Parameter(Mandatory = $true)]
      $MISPUrl,
      [Parameter(Mandatory = $true)]
      $MISPAuthHeader,
      $MISPEventPublisher,
      [array]$MISPTagsId,
      $MISPOrg,
      $MISPEventName,
      $Publish = $false,
      $Distribution = 0,
      [array]$Attributes,
      [switch]$SelfSigned
    )
    # Which MISP API Endpoint we are working against
    $Endpoint = "events/add"
    Write-Host "Trying to create event with title: $($MISPEventName)"
  
    # Check if event already exists
    $EventReturn = Get-MISPEvent -MISPUrl $MISPUrl -MISPAuthHeader $MISPAuthHeader -MISPEventName $MISPEventName -MISPOrg $MISPOrg -SelfSigned
    if($EventReturn) {
      Write-Host "Event already exists, returning event"
      # Set eventID to existing event
      $MISPEventID =  $EventReturn.Id
    } else {
      # Continue script
      Write-Host "Event does not exist, creating event $MISPEventName"
      
      # Create body
      if($Publish) {
        $Publish = $true
      } else {
        $Publish = $false
      }
      # Check org id
      $orgs = Get-MISPOrganisations -MISPUrl $MISPurl -MISPAuthHeader $MISPAuthHeader -SelfSigned
      $org = $orgs.Organisation | Where-Object {$_.name -eq $MISPOrg}
      if($org) {
        Write-Host "Organization $($MISPOrg) found with id $($org.id)"
        $MISPOrg = $org.id
      } else {
        Write-Host "Organization not found"
        return
      }
      $Body = @{
        info = "$MISPEventName"
        org_id = $MISPOrg
        published = $Publish
        event_creator_email = $MISPEventPublisher
        distribution = $Distribution
      }
      
      # Invoke the API to create the event
      if($SelfSigned) {
        $return = Invoke-MISPRestMethod -Uri "$MISPUrl/$Endpoint" -Header $MISPAuthHeader -Method Post -Body $Body -SelfSigned
      } else {
        $return = Invoke-MISPRestMethod -Uri "$MISPUrl/$Endpoint" -Header $MISPAuthHeader -Method Post -Body $Body
      }
      
      # Get event id from return
      $MISPEventID = ($return.Content | ConvertFrom-Json).Event.Id
      
      # Add tags to event
      foreach($Tag in $MISPTagsId) {
        New-MISPEventTag -MISPUrl $MISPUrl -MISPAuthHeader $MISPAuthHeader -MISPEventID $MISPEventID -MISPTagId $Tag -SelfSigned
      }
    }
    # Event exists or has been created, now we can add attributes
    if($Attributes) {
      # Format of attributes is a hashtable with the following format: $HashTable = @{Attribute = "value"; Type = "type"; Category = "category"; Comment = "comment"}
      foreach($Attribute in $Attributes) {
        New-MISPEventAttribute -MISPUrl $MISPUrl -MISPAuthHeader $MISPAuthHeader -MISPEventID $MISPEventID -MISPAttribute $Attribute.Attribute -MISPAttributeType $Attribute.Type -MISPAttributeCategory $Attribute.Category -MISPAttributeComment $Attribute.Comment -SelfSigned
      }
    }
    return $MISPEventID
  }