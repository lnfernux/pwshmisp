<#
.SYNOPSIS
Invokes a REST method against a MISP (Malware Information Sharing Platform) instance.

.DESCRIPTION
The Invoke-MISPRestMethod function is used to send HTTP requests to a MISP instance. It takes in the necessary parameters such as headers, HTTP method, request body, and URI, and returns the response from the MISP server.

.PARAMETER Headers
The headers to be included in the HTTP request.

.PARAMETER Method
The HTTP method to be used for the request (e.g., GET, POST, PUT, DELETE).

.PARAMETER Body
The body of the HTTP request.

.PARAMETER URI
The URI of the MISP endpoint to send the request to.

.EXAMPLE
$Headers = New-MISPAuthHeader -MISPAuthKey "YOUR_API_KEY"
$URI = "https://misp-instance/events"
$Data = @{
    test = Test
}
Invoke-MISPRestMethod -Headers $Headers -Method GET -Body ($Data | ConvertTo-Json) -Uri $URI

.NOTES
This function requires the Invoke-WebRequest cmdlet, which is available in PowerShell 3.0 and later.
#>
function Invoke-MISPRestMethod {
    param(
      $Headers,
      $Method,
      $Body,
      $URI,
      [switch]$SelfSigned
    )
    try {
      # Run the query against MISP
      if($Body) {
        if($SelfSigned) {
          $Result = Invoke-WebRequest -Headers $Headers -Method $Method -Body ($Body | ConvertTo-Json) -Uri $URI -SkipCertificateCheck
        } else {
          $Result = Invoke-WebRequest -Headers $Headers -Method $Method -Body ($Body | ConvertTo-Json) -Uri $URI
        }
      } else {
        if($SelfSigned) {
          $Result = Invoke-WebRequest -Headers $Headers -Method $Method -Uri $URI -SkipCertificateCheck
        } else {
          $Result = Invoke-WebRequest -Headers $Headers -Method $Method -Uri $URI
        }
      }
    }
    catch {
      $errorReturn = $_ 
      if($errorReturn.ErrorDetails.Message -eq "A similar attribute already exists for this event") {
        Write-Host "Attribute already exists"
      }
      elseif($errorReturn.ErrorDetails.Message -match "RemoteCertificateNameMismatch" -or $errorReturn.ErrorDetails.Messagee -match "RemoteCertificateChainErrors") {
        Write-Host "Error: Certificate error. Please check the certificate of the MISP instance, or use the -SelfSigned switch to skip certificate validation."
      }
      else {
        Write-Host "Error: $($_)"
      }
    }
    return $Result
  }