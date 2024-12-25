# PSMISP Module

This module works as a powershell wrapper for the [MISP OpenAPI](https://www.misp-project.org/openapi/). It allows you to interact with MISP instances using powershell. 

## Usage

All commands require a `Header` parameter, which is created using the `New-MISPAuthHeader` function. Subsequent commands all use the `Invoke-MISPRestMethod` function to interact with the MISP API.

### New-MISPAuthHeader

```powershell
$AuthHeader = New-MISPAuthHeader -MISPAuthKey "YOUR_API_KEY"
``` 

### Invoke-MISPRestMethod

Example of getting all events from a MISP instance:

The body takes a Powershell-object variable as input - it will convert it to json in the function.

```powershell
$URI = "https://misp-instance/events"
Invoke-MISPRestMethod -Headers $AuthHeader -Method GET -Body $Data -Uri $URI
```

Example of querying for a specific event tag:

```powershell
$URI = "https://misp-instance/events/index"
$Data = @"
{
"tags": [
    "infextest"
]
}
"@
$output = Invoke-MISPRestMethod -Headers $MISPAuthHeader -Method POST -Body ($Data | ConvertFrom-Json) -Uri $URI -SelfSigned
```

Prints something like this:

```text
$output.Content | ConvertFrom-Json

id                  : 1775
org_id              : 1
date                : 2024-12-23
info                : Test TEST
uuid                : 967ea7d3-x-x-x-928a377497fa
published           : False
analysis            : 0
attribute_count     : 1
orgc_id             : 1
timestamp           : 1734954863
distribution        : 0
sharing_group_id    : 0
proposal_email_lock : False
locked              : False
threat_level_id     : 2
last   : 0
sighting_timestamp  : 0
disable_correlation : False
extends_uuid        : 
protected           : 
Org                 : @{id=1; name=ORGNAME; uuid=987c32b5-x-x-x-a1dee70fe473}
Orgc                : @{id=1; name=ORGNAME; uuid=987c32b5-x-x-x-a1dee70fe473}
EventTag            : {@{id=7957; event_id=1775; tag_id=2014; local=False; relationship_type=; Tag=}}
```

## Wrapper-functions

Some wrapper commands have been created to make it easier to interact with the MISP API. These are:

### Get-MISPEvent

This function allows you to get a specific event from a MISP instance. It requires you to supply the `MISPUrl`, `MISPOrg` and `MISPEventName` parameters. The `MISPAttribute` parameter is optional and allows you to filter on a single attribute of the event, in case there are multiple matches for the `MISPEventName`.

```powershell
Get-MISPEvent -MISPAuthHeader $AuthHeader -MISPUrl $MISPUrl -MISPOrg $MISPOrg -MISPEventName $MISPEventName -MISPAttribute $MISPAttribute
```

### Get-MISPTags

This function allows you to get all tags from a MISP instance. It requires you to supply the `MISPUrl` parameter.

```powershell
Get-MISPTags -MISPAuthHeader $AuthHeader -MISPUrl $MISPUrl
```

### Get-MISPTagByName

Allows you to search for a single tag by name. Important to note that if there are spaces in the tag name, you need to replace them with a `+` sign, and any special charactes must be URL encoded.

```powershell
Get-MISPTagByName -MISPAuthHeader $AuthHeader -MISPUrl $MISPUrl -Tag $TagName
```

### Get-MISPTagById

Returns a tag based on the tag ID.

```powershell
Get-MISPTagById -MISPAuthHeader $AuthHeader -MISPUrl $MISPUrl -Id $TagId
```

### Invoke-MISPEventSearch

This is a helper function for the `psmisp2sentinel`-project. It allows you to search for events based on a filter, which is a json file containing the search parameters. The function requires the `MISPUrl` and `AuthHeader` parameters.

Currently, the filter supports some of the main search parameters in the MISP API. The following is an example of a filter file:

```json
{
    "published": 1,
    "tags": [
        "tlp:green"
    ],
    "not_tags": [
        "tlp:amber"
    ],
    "enforceWarninglist": true,
    "includeEventTags": true,
    "last": "14d",
    "orgs": [
        "org1",
        "org2"
    ],"not_orgs": [
        "org3"
    ],
    "excludeLocalTags": true
}
```

```powershell	
$filter = Get-Content -Path "filter.json"
Invoke-MISPEventSearch -AuthHeader $authHeader -MISPUrl $MISPUrl -Filter $filter
```

### New-MISPEvent

This function allows you to create a new event in a MISP instance.

```powershell
$returnMispEvent = New-MISPEvent -MISPUrl $MISPUrl -MISPAuthHeader $MISPAuthHeader -MISPEventPublisher "ikke_stresse@misp.local " -MISPTagsId @("1108", "1137") -MISPOrg ORGNAME -MISPEventName "Test Event 5555" -Distribution 3 -Attributes @(@{Attribute = "malware"; Type = "text"; Category = "Payload delivery"; Comment = "This is a test attribute"}) -SelfSigned
```

### New-MISPEventAttribute

This function allows you to create a new attribute for an event in a MISP instance.

```powershell
Add-MISPEventAttribute -MISPUrl "https://misp.example.com" -MISPAuthHeader $AuthHeader -MISPEventID 1234 -MISPAttribute "malware" -MISPAttributeType "string" -MISPAttributeCategory "Payload delivery" -MISPAttributeComment "This is a test attribute"
```

### New-MISPEventTag

This function allows you to add a tag to an event in a MISP instance.

```powershell
Add-MISPEventTag -MISPUrl "https://misp.example.com" -MISPAuthHeader $AuthHeader -MISPEventID 12345 -MISPTagId 6789
```

If you want the tag to be local only, you can use the `-LocalOnly` switch.

### New-MISPTag

This function allows you to create a new tag in a MISP instance.

```powershell
$response = New-MISPTag -Name "infextest2" -Colour "#ffffff" -Exportable $true -MISPUrl $MISPUrl -MISPAuthHeader $MISPauthHeader -OrgId 1 -UserId 2 -SelfSigned -LocalOnly $true
```

### Get-MISPAttributeFromEvent 

This function allows you to get all attributes from a specific event in a MISP instance.

```powershell
$Attributes = Get-MISPAttributeFromEvent -MISPUrl $MISPUrl -MISPAuthHeader $MISPAuthHeader -EventID 2015 -SelfSigned
Trying to get attributes from event with ID: 2015
$Attributes[0]

id                  : 312469
event_id            : 1780
object_id           : 0
object_relation     : 
category            : Payload delivery
type                : text
value1              : malware
value2              : 
to_ids              : False
uuid                : d29f1e3a-d8ac-4a7c-b148-3bec5ed25a45
timestamp           : 1734961044
distribution        : 5
sharing_group_id    : 0
comment             : This is a test attribute
deleted             : False
disable_correlation : False
first_seen          : 
last_seen           : 
value               : malware
```

### Invoke-MISPAttributeSearch

This function allows you to search for attributes in a MISP instance. It requires a filter as input.

```powershell
$filter = @"
{
    "value": "malware",
    "published" : 1,
    "last": "1d"
}
"@
$return = Invoke-MISPAttributeSearch -MISPUrl $mispurl -MISPAuthHeader $MISPAuthHeader -Filter $filter -SelfSigned
$return.Attribute

id                  : 312468
event_id            : 1779
object_id           : 0
object_relation     : 
category            : Payload delivery
type                : text
to_ids              : False
uuid                : fcca162e-8e92-48c0-8f6c-239447f6d749
timestamp           : 1735149314
distribution        : 5
sharing_group_id    : 0
comment             : This is a test attribute
deleted             : False
disable_correlation : False
first_seen          : 
last_seen           : 
value               : malware
Event               : @{org_id=1; distribution=3; publish_timestamp=1735149604; id=1779; info=Test Event 5555; orgc_id=1; uuid=77813240-0436-4418-ac2c-66ae4261e3d2}
```

## Known issues

Error handling is not quite there. Also some of the functions are not fully tested yet, like the `$filter` parameters in general.

## Future improvements

- [ ] Add more wrapper functions for the MISP API
- [ ] Add more error handling
- [ ] Add more logging and verbose output
- [ ] Add more documentation

## Contributing

If you want to contribute to this project, please create a pull request with your changes.
