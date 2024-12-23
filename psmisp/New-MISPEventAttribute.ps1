<#
.SYNOPSIS
Adds an attribute to an existing event in a MISP instance.

.DESCRIPTION
The Add-MISPEventAttribute function is used to add an attribute to an existing event in a MISP (Malware Information Sharing Platform) instance. It constructs the URL for the MISP API endpoint, creates a hashtable for the body of the request, and then invokes a REST method to add the attribute to the event in the MISP instance.

.PARAMETER MISPUrl
The URL of the MISP instance.

.PARAMETER MISPAuthHeader
The authentication header for the MISP instance.

.PARAMETER MISPEventID
The ID of the event to which the attribute should be added.

.PARAMETER MISPAttribute
The attribute to be added.

.PARAMETER MISPAttributeType
The type of the attribute to be added.

.PARAMETER MISPAttributeCategory
The category of the attribute to be added.

.PARAMETER MISPAttributeComment
A comment for the attribute to be added.

.EXAMPLE
Add-MISPEventAttribute -MISPUrl "https://misp.example.com" -MISPAuthHeader $AuthHeader -MISPEventID 1234 -MISPAttribute "malware" -MISPAttributeType "string" -MISPAttributeCategory "Payload delivery" -MISPAttributeComment "This is a test attribute"

This example adds an attribute with the value "malware", type "string", category "Payload delivery", and comment "This is a test attribute" to the event with ID 1234 in the MISP instance at "https://misp.example.com".
#>
function New-MISPEventAttribute {
    PARAM(
      $MISPUrl,
      $MISPAuthHeader,
      $MISPEventID,
      $MISPAttribute,
      $MISPAttributeType,
      $MISPAttributeCategory,
      $MISPAttributeComment,
      [switch]$SelfSigned
    )
    # Which MISP API Endpoint we are working against
    $Endpoint = "attributes/add/$MISPEventID"
    
    <#
    ### Valid categories ###
    "Internal reference" "Targeting data" "Antivirus detection" "Payload delivery" "Artifacts dropped" "Payload installation" "Persistence mechanism" "Network activity" "Payload type" "Attribution" "External analysis" "Financial fraud" "Support Tool" "Social network" "Person" "Other"
    
    ### Valid types ###
    "md5" "sha1" "sha256" "filename" "pdb" "filename|md5" "filename|sha1" "filename|sha256" "ip-src" "ip-dst" "hostname" "domain" "domain|ip" "email" "email-src" "eppn" "email-dst" "email-subject" "email-attachment" "email-body" "float" "git-commit-id" "url" "http-method" "user-agent" "ja3-fingerprint-md5" "jarm-fingerprint" "favicon-mmh3" "hassh-md5" "hasshserver-md5" "regkey" "regkey|value" "AS" "snort" "bro" "zeek" "community-id" "pattern-in-file" "pattern-in-traffic" "pattern-in-memory" "pattern-filename" "pgp-public-key" "pgp-private-key" "yara" "stix2-pattern" "sigma" "gene" "kusto-query" "mime-type" "identity-card-number" "cookie" "vulnerability" "cpe" "weakness" "attachment" "malware-sample" "link" "comment" "text" "hex" "other" "named pipe" "mutex" "process-state" "target-user" "target-email" "target-machine" "target-org" "target-location" "target-external" "btc" "dash" "xmr" "iban" "bic" "bank-account-nr" "aba-rtn" "bin" "cc-number" "prtn" "phone-number" "threat-actor" "campaign-name" "campaign-id" "malware-type" "uri" "authentihash" "vhash" "ssdeep" "imphash" "telfhash" "pehash" "impfuzzy" "sha224" "sha384" "sha512" "sha512/224" "sha512/256" "sha3-224" "sha3-256" "sha3-384" "sha3-512" "tlsh" "cdhash" "filename|authentihash" "filename|vhash" "filename|ssdeep" "filename|imphash" "filename|impfuzzy" "filename|pehash" "filename|sha224" "filename|sha384" "filename|sha512" "filename|sha512/224" "filename|sha512/256" "filename|sha3-224" "filename|sha3-256" "filename|sha3-384" "filename|sha3-512" "filename|tlsh" "windows-scheduled-task" "windows-service-name" "windows-service-displayname" "whois-registrant-email" "whois-registrant-phone" "whois-registrant-name" "whois-registrant-org" "whois-registrar" "whois-creation-date" "x509-fingerprint-sha1" "x509-fingerprint-md5" "x509-fingerprint-sha256" "dns-soa-email" "size-in-bytes" "counter" "datetime" "port" "ip-dst|port" "ip-src|port" "hostname|port" "mac-address" "mac-eui-64" "email-dst-display-name" "email-src-display-name" "email-header" "email-reply-to" "email-x-mailer" "email-mime-boundary" "email-thread-index" "email-message-id" "github-username" "github-repository" "github-organisation" "jabber-id" "twitter-id" "dkim" "dkim-signature" "first-name" "middle-name" "last-name" "full-name" "date-of-birth" "place-of-birth" "gender" "passport-number" "passport-country" "passport-expiration" "redress-number" "nationality" "visa-number" "issue-date-of-the-visa" "primary-residence" "country-of-residence" "special-service-request" "frequent-flyer-number" "travel-details" "payment-details" "place-port-of-original-embarkation" "place-port-of-clearance" "place-port-of-onward-foreign-destination" "passenger-name-record-locator-number" "mobile-application-id" "chrome-extension-id" "cortex" "boolean" "anonymised"
    #>

    # Create the body of the request
    $MISPUrl = "$MISPUrl/$Endpoint"
    $Body = @{
      value = $MISPAttribute
      type = $MISPAttributeType
      category = $MISPAttributeCategory
      comment = $MISPAttributeComment
      event_id = $MISPEventID
    }
  
    # Invoke the REST method
    Write-Host "Trying to add attribute $MISPAttribute to event $MISPEventID"
    if($SelfSigned) {
      $return = Invoke-MISPRestMethod -Uri $MISPUrl -Headers $MISPAuthHeader -Method Post -Body $Body -SelfSigned
    } else {
      $return = Invoke-MISPRestMethod -Uri $MISPUrl -Headers $MISPAuthHeader -Method Post -Body $Body
    }
    return $return
  }