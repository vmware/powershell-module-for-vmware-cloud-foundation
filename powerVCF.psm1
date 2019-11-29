#   PowerShell module for VMware Cloud Foundation
#
#   Author: Brian O'Connnell
#   VMware HCIBU Staff Architect
#   broconnell@vmware.com
#   @lifeOfBrianOC
#
#   Version 1.0
#
#   Contributions, Improvements &/or Complete Re-writes Welcome!
#
#   List of contributors:
#
#   Giuliano Bertello
#   Dell EMC Sr. Principal Engineer
#   giuliano.bertello@gmail.com / @GiulianoBerteo / https://blog.bertello.org
#
#   https://github.com/PowerVCF/PowerVCF

#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
#   SOFTWARE.

#   Note:
#   This powershell module should be considered entirely experimental. It is still 
#   in development & not tested beyond lab scenarios.
#   It is recommended you dont use it for any production environment without testing 
#   extensively!
#   Tested against VMware Cloud Foundation 3.8


# Enable communication with self signed certs when using Powershell Core
# If you require all communications to be secure & do not wish to 
# allow communication with self signed certs remove lines 31-52 before 
# importing the module

if ($PSEdition -eq 'Core') {
$PSDefaultParameterValues.Add("Invoke-RestMethod:SkipCertificateCheck",$true)
}

if ($PSEdition -eq 'Desktop') {
# Enable communication with self signed certs when using Windows Powershell
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertificatePolicy : ICertificatePolicy {
        public TrustAllCertificatePolicy() {}
		public bool CheckValidationResult(
            ServicePoint sPoint, X509Certificate certificate,
            WebRequest wRequest, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertificatePolicy
}

####  Do not modify anything below this line. All user variables are in the accompanying JSON files #####

Function Connect-VCFManager {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & stores the credentials in a base64 string
	
    .DESCRIPTION
    The Connect-VCFManager cmdlet connects to the specified SDDC Manager & stores the credentials 
	in a base64 string. It is required once per session before running all other cmdlets

    .EXAMPLE
	PS C:\> This example shows how to connect to SDDC Manager
	
	PS C:\> Connect-VCFManager -fqdn sfo01vcf01.sfo01.rainpole.local -username admin -password VMware1!

    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$fqdn,
		[Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$username,
		[Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$password
    )
	
    if ( -not $PsBoundParameters.ContainsKey("username") -or ( -not $PsBoundParameters.ContainsKey("username"))) 
        {
            # Request Credentials
            $creds = Get-Credential
            $username = $creds.UserName.ToString()
            $password = $creds.GetNetworkCredential().password
        }

    $Global:sddcManager = $fqdn

    # Create Basic Authentication Encoded Credentials
    $Global:base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))

    # validate credentials by executing an API call
    $headers = @{“Accept” = “application/json”}
    $headers.Add(“Authorization”, “Basic $base64AuthInfo”)

    # Checking against the sddc-managers API
    $uri = “https://$sddcManager/v1/sddc-managers”
    Try {
            $response = Invoke-WebRequest -Method GET -Uri $uri -Headers $headers
            if ($response.StatusCode -eq 200) {
                Write-Host ""
                Write-Host “ Successully connected to SDDC Manager:" $sddcManager -ForegroundColor Yellow
                Write-Host ""
            }
        }
    Catch {
            Write-Host ""
            Write-Host "" $_.Exception.Message -ForegroundColor Red
            Write-Host " Credentials provided did not return a valid API response (expected 200). Retry Connect-VCFManager cmdlet" -ForegroundColor Red
            Write-Host
        }		
				} 	
Export-ModuleMember -function Connect-VCFManager

######### Start Host Operations ##########

Function Get-VCFHost {
    <#
    .SYNOPSIS
    Connects to the specified SDDC Manager & retrieves a list of hosts.

    .DESCRIPTION
    The Get-VCFHost cmdlet connects to the specified SDDC Manager & retrieves a list of hosts.  
	VCF Hosts are defined by status
	ASSIGNED - Hosts that are assigned to a Workload domain
	UNASSIGNED_USEABLE - Hosts that are availbale to be assigned to a Workload Domain
	UNASSIGNED_UNUSEABLE - Hosts that are currently not assigned to any domain and can be used 
	for other domain tasks after completion of cleanup operation

    .EXAMPLE
	PS C:\> This example shows how to get all hosts regardless of status
	
	PS C:\> Get-VCFHost
	
	.EXAMPLE
	PS C:\> This example shows how to get all hosts with a specific status
	
	PS C:\> Get-VCFHost -Status ASSIGNED
	
	
	.EXAMPLE
	PS C:\> This example shows how to get a host by id
	
	PS C:\> Get-VCFHost -id edc4f372-aab5-4906-b6d8-9b96d3113304
	
	.EXAMPLE
	PS C:\> This example shows how to get a host by fqdn
	
	PS C:\> Get-VCFHost -fqdn sfo01m01esx01.sfo01.rainpole.local
    #>
	
	param (
        [Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$fqdn,

        [Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$status,
        
        [Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$id
    )
    
    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    
    # checking parameters passed
    if ($PsBoundParameters.ContainsKey("status")) {
        $uri = "https://$sddcManager/v1/hosts?status=$status"
    }
    if ($PsBoundParameters.ContainsKey("id")) {
        $uri = "https://$sddcManager/v1/hosts/$id"
    }
    if (-not $PsBoundParameters.ContainsKey("status") -and (-not $PsBoundParameters.ContainsKey("id"))) {
        $uri = "https://$sddcManager/v1/hosts"
    }
    if ($PsBoundParameters.ContainsKey("fqdn")) {
        $uri = "https://$sddcManager/v1/hosts"
    }
    
    Try {
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
    }
    Catch {
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
    }
    # depending on the parameter, output formatting is different
    if ($PsBoundParameters.ContainsKey("fqdn")) { $response.elements | Where-Object {$_.fqdn -eq $fqdn}  }
    
    if ($PsBoundParameters.ContainsKey("id")) 	{ $response }

    if ($PsBoundParameters.ContainsKey("status")) { $response.elements }
    
    if ( -not $PsBoundParameters.ContainsKey("status") -and ( -not $PsBoundParameters.ContainsKey("id")) -and ( -not $PsBoundParameters.ContainsKey("fqdn"))) {
        $response.elements
    }
}
Export-ModuleMember -Function Get-VCFHost

Function Commission-VCFHost {

    <#
    .SYNOPSIS
    Connects to the specified SDDC Manager & commissions a list of hosts.
	

    .DESCRIPTION
    The Commission-VCFHost cmdlet connects to the specified SDDC Manager 
	& commissions a list of hosts.
	Host list spec is provided in a JSON file.	

    .EXAMPLE
    PS C:\> This example shows how to commission a list of hosts
	
	PS C:\> Commission-VCFHost -hostsSpecs .\Host\commissionHosts\commissionHostSpec.json

    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$hostsSpecs
    )
	
    if (!(Test-Path $hostsSpecs)) {

        throw "JSON File Not Found"
    
    }

    else {    
        # Reads the commissionHostsJSON json file contents into the $ConfigJson variable
        $ConfigJson = (Get-Content -Raw $hostsSpecs)
        $headers = @{"Accept" = "application/json"}
        $headers.Add("Authorization", "Basic $base64AuthInfo")
        $uri = "https://$sddcManager/v1/hosts/"
    try {
        # Validate the provided JSON spec
        $response = Validate-CommissionHostSpec -json $ConfigJson
        # Submit the request if the JSON soec is valid
        $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
        $response
                    
    }
    catch {
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
                $responseStream = $_.exception.response.GetResponseStream()
                $reader = New-Object system.io.streamreader($responseStream)
                $responseBody = $reader.readtoend()
                $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
                throw $ErrorString
            }
            else { 
                throw $_ 
            }

        }
    }
}
Export-ModuleMember -Function Commission-VCFHost

Function Decommission-VCFHost {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & decommissions a list of hosts.
	Host list is provided in a JSON file.

    .DESCRIPTION
    The Decommission-VCFHost cmdlet connects to the specified SDDC Manager 
	& decommissions a list of hosts.
	

    .EXAMPLE
    PS C:\> This example shows how to decommission a set of hosts
	
	PS C:\> Decommission-VCFHost -json ".\Host\decommissionHostSpec.json"

    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$json 
    )

if (!(Test-Path $json)) {
throw "JSON File Not Found"
}
else {	
    # Reads the json file contents into the $ConfigJson variable
    $ConfigJson = (Get-Content -Raw $json)
	$headers = @{"Accept" = "application/json"}
	$headers.Add("Authorization", "Basic $base64AuthInfo")
	$uri = "https://$sddcManager/v1/hosts"
	
try { 
			$response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
			$response
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
         if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
			$responseBody
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }	
}
	}
Export-ModuleMember -Function Decommission-VCFHost

#TODO: Add Posh-SSH Support
Function Cleanup-VCFHosts {
# Print Instructions to screen
Write-Output "Not Implemented as a function yet as it requires SSH access to SDDC Manager"
Write-Output "SSH to $sddcManager"
Write-Output "Run /opt/vmware/sddc-support/sos --cleanup-host ALL"

				} 
######### End Host Operations ##########


######### Start Workload Domain Operations ##########

Function Get-VCFWorkloadDomain {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & retrieves a list of workload domains.
	

    .DESCRIPTION
    The Get-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager 
	& retrieves a list of workload domains.
	

    .EXAMPLE
    PS C:\> This example shows how to get a list of Workload Domains
	
	PS C:\> Get-VCFWorkloadDomain
	
	.EXAMPLE
    PS C:\> This example shows how to get a Workload Domain by name
	
	PS C:\> Get-VCFWorkloadDomain -name WLD01
	
	.EXAMPLE
    PS C:\> This example shows how to get a Workload Domain by id
	
	PS C:\> Get-VCFWorkloadDomain -id 8423f92e-e4b9-46e7-92f7-befce4755ba2


    #>
	
	param (
        [Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$name,
		[Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$id
    )

$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")

if ($PsBoundParameters.ContainsKey("id"))
{
$uri = "https://$sddcManager/v1/domains/$id"
}
if ($PsBoundParameters.ContainsKey("name"))
{
$uri = "https://$sddcManager/v1/domains"
}
if ( -not $PsBoundParameters.ContainsKey("name") -and ( -not $PsBoundParameters.ContainsKey("id")))
{
$uri = "https://$sddcManager/v1/domains"
}
try { 
			
			<# $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response #>
			if ($PsBoundParameters.ContainsKey("name"))
			{
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements | Where-Object {$_.name -eq $name}
			}
			if ($PsBoundParameters.ContainsKey("id")) 
			{
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response
			}
			if ( -not $PsBoundParameters.ContainsKey("name") -and ( -not $PsBoundParameters.ContainsKey("id")))
			{
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements
			}
			
       
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
}
Export-ModuleMember -Function Get-VCFWorkloadDomain

Function New-VCFWorkloadDomain {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & creates a workload domain.
	

    .DESCRIPTION
    The New-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager 
	& creates a workload domain. 
	

    .EXAMPLE
	PS C:\> This example shows how to create a Workload Domain from a json spec
	
	PS C:\> New-VCFWorkloadDomain -json .\WorkloadDomain\workloadDomainSpec.json


    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$json 
    )

if (!(Test-Path $json)) {
Throw "JSON File Not Found"
}
else {
# Read the json file contents into the $ConfigJson variable
$ConfigJson = (Get-Content $json)

$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/domains"
try { 
			# Validate the provided spec
			$response = Validate-WorkloadDomainSpec -json $ConfigJson
			# Submit the request once spec is valid
			$response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
			$response
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
}
}
Export-ModuleMember -Function New-VCFWorkloadDomain

Function Update-VCFWorkloadDomain {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & marks a workload domain for deletion.
	

    .DESCRIPTION
    Before a workload domain can be deleted it must first be marked for deletion.
	The Update-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager 
	& marks a workload domain for deletion. 
	

    .EXAMPLE
	PS C:\> This example shows how to mark a workload domain for deletion
	
	PS C:\> Update-VCFWorkloadDomain -id fbdcf199-c086-43aa-9071-5d53b5c5b99d


    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$id 
    )

$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/domains/$id"
$body = '{
	"markForDeletion": true
}'
try { 
			$response = Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $body
			# This API does not return a response
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
}
Export-ModuleMember -Function Update-VCFWorkloadDomain

Function Remove-VCFWorkloadDomain {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & deletes a workload domain.
	

    .DESCRIPTION
    Before a workload domain can be deleted it must first be marked for deletion.
	See Update-VCFWorkloadDomain
	The Remove-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager 
	& deletes a workload domain. 
	

    .EXAMPLE
	PS C:\> This example shows how to delete a workload domain
	
	PS C:\> Remove-VCFWorkloadDomain -id fbdcf199-c086-43aa-9071-5d53b5c5b99d


    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$id 
    )

$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/domains/$id"

try { 
			$response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
			$response
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
}
Export-ModuleMember -Function Remove-VCFWorkloadDomain

######### End Workload Domain Operations ##########

######### Start Cluster Operations ##########

Function Get-VCFCluster {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & retrieves a list of clusters.
	

    .DESCRIPTION
    The Get-VCFCluster cmdlet connects to the specified SDDC Manager 
	& retrieves a list of clusters.
	

    .EXAMPLE
    PS C:\> This example shows how to get a list of all clusters
	
	PS C:\> Get-VCFCluster
	
	.EXAMPLE
    PS C:\> This example shows how to get a cluster by name
	
	PS C:\> Get-VCFCluster -name wld01-cl01
	
	.EXAMPLE
    PS C:\> This example shows how to get a cluster by id
	
	PS C:\> Get-VCFCluster -id 8423f92e-e4b9-46e7-92f7-befce4755ba2


    #>
	
	param (
        [Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$name,
		[Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$id
    )

$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")

if ($PsBoundParameters.ContainsKey("id"))
{
$uri = "https://$sddcManager/v1/clusters/$id"
}
else
{
$uri = "https://$sddcManager/v1/clusters"
}
try { 
			if ($PsBoundParameters.ContainsKey("name"))
			{
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements | Where-Object {$_.name -eq $name}
			}
			if ($PsBoundParameters.ContainsKey("id"))
			{
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements | Where-Object {$_.id -eq $id}
			}
            if ( -not $PsBoundParameters.ContainsKey("name") -and ( -not $PsBoundParameters.ContainsKey("id")))
			{
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements
       
    }
	}
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
}
Export-ModuleMember -Function Get-VCFCluster

Function New-VCFCluster {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & creates cluster.
	

    .DESCRIPTION
    The New-VCFCluster cmdlet connects to the specified SDDC Manager 
	& creates a cluster in a specified workload domains. 
	

    .EXAMPLE
	PS C:\> This example shows how to create a cluster in a Workload Domain from a json spec
	
	PS C:\> New-VCFCluster -json .\WorkloadDomain\addClusterSpec.json


    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$json 
    )

if (!(Test-Path $json)) {
Throw "JSON File Not Found"
}
else {
# Read the json file contents into the $ConfigJson variable
$ConfigJson = (Get-Content $json)
$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/clusters"
try { 
			# Validate the provided spec
			$response = Validate-VCFClusterSpec -json $ConfigJson
			# Submit the request once spec is valid
			$response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
			$response.elements
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
}
}
Export-ModuleMember -Function New-VCFCluster

Function Update-VCFCluster {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & expands or compacts a cluster.
	

    .DESCRIPTION
	The Update-VCFCluster cmdlet connects to the specified SDDC Manager 
	& expands or compacts a cluster by adding or removing a host(s). A cluster
	can also be marked for deletion
	

    .EXAMPLE
	PS C:\> This example shows how to expand a cluster by adding a host(s)
	
	PS C:\> Update-VCFCluster -clusterid a511b625-8eb8-417e-85f0-5b47ebb4c0f1 
	-json .\Cluster\clusterExpansionSpec.json
	
	.EXAMPLE
	PS C:\> This example shows how to compact a cluster by removing a host(s)
	
	PS C:\> Update-VCFCluster -clusterid a511b625-8eb8-417e-85f0-5b47ebb4c0f1 
	-json .\Cluster\clusterCompactionSpec.json
	
	.EXAMPLE
	PS C:\> This example shows how to mark a cluster for deletion
	
	PS C:\> Update-VCFCluster -clusterid a511b625-8eb8-417e-85f0-5b47ebb4c0f1 
	-markForDeletion $true


    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$clusterid,
		[Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$json,
		[Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [bool]$markForDeletion
    )

if ($PsBoundParameters.ContainsKey("json"))
			{
if (!(Test-Path $json)) {
Throw "JSON File Not Found"
}
else {
# Read the json file contents into the $ConfigJson variable
$ConfigJson = (Get-Content $json)
} }
$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/clusters/$clusterid/"
try { 
			if ( -not $PsBoundParameters.ContainsKey("json") -and ( -not $PsBoundParameters.ContainsKey("markForDeletion")))
			{
			throw "You must include either -json or -markForDeletion"
			}
			if ($PsBoundParameters.ContainsKey("json"))
			{
			# Validate the json spec
			$response = Validate-VCFUpdateClusterSpec -clusterid $clusterid -json $ConfigJson
			}
			if ($PsBoundParameters.ContainsKey("markForDeletion"))
			{
			$ConfigJson = '{
	"markForDeletion": true
}'
			}
			$response = Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
			#TODO: Parse the response
			#$response.elements
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
}
Export-ModuleMember -Function Update-VCFCluster

Function Remove-VCFCluster {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & deletes a cluster.
	

    .DESCRIPTION
    Before a cluster can be deleted it must first be marked for deletion.
	See Update-VCFCluster
	The Remove-VCFCluster cmdlet connects to the specified SDDC Manager 
	& deletes a cluster. 
	

    .EXAMPLE
	PS C:\> This example shows how to delete a cluster
	
	PS C:\> Remove-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1


    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$id 
    )

$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/clusters/$id"

try { 
			$response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
			#TODO: Parse the response
			#$response.elements
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
}
Export-ModuleMember -Function Remove-VCFCluster

######### End Cluster Operations ##########

######### Start Network Pool Operations ##########

Function Get-VCFNetworkPool {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & retrieves a list of Network Poola.
	

    .DESCRIPTION
    The Get-VCFNetworkPool cmdlet connects to the specified SDDC Manager 
	& retrieves a list of Network Pools. 
	

    .EXAMPLE
    PS C:\> This example shows how to get a list of all Network Pools
	
	PS C:\> Get-VCFNetworkPool
	
	.EXAMPLE
    PS C:\> This example shows how to get a Network Pool by name
	
	PS C:\> Get-VCFNetworkPool -name sfo01-networkpool
	
	.EXAMPLE
    PS C:\> This example shows how to get a Network Pool by id
	
	PS C:\> Get-VCFNetworkPool -id 40b0b36d-36d6-454c-814b-ba8bf9b383e3
	
	


    #>
	
	param (
        [Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$name,
		[Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$id
    )

$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/network-pools"
try { 
            if ($PsBoundParameters.ContainsKey("name"))
			{
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements | Where-Object {$_.name -eq $name}
			}
			if ($PsBoundParameters.ContainsKey("id"))
			{
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements | Where-Object {$_.id -eq $id}
			}
            if ( -not $PsBoundParameters.ContainsKey("name") -and ( -not $PsBoundParameters.ContainsKey("id")))
			{
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements
			}
        
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
	}
Export-ModuleMember -Function Get-VCFNetworkPool

Function New-VCFNetworkPool {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & creates a new Network Pool.
	

    .DESCRIPTION
    The New-VCFNetworkPool cmdlet connects to the specified SDDC Manager 
	& creates a new Network Pool. 
	Network Pool spec is provided in a JSON file.
	

    .EXAMPLE
    PS C:\> This example shows how to create a Network Pool
	
	PS C:\> New-VCFNetworkPool -json .\NetworkPool\createNetworkPoolSpec.json

    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$json 
    )
	
if (!(Test-Path $json)) {
Throw "JSON File Not Found"
}
else {
# Read the json file contents into the $ConfigJson variable
$ConfigJson = (Get-Content $json)
$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/network-pools"
try { 
			$response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
			# This API does not return a response body. Sending GET to validate the Network Pool creation was successful
			$validate = $ConfigJson | ConvertFrom-Json
			$poolName = $validate.name
			Get-VCFNetworkPool -name $poolName
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
	}
							}
Export-ModuleMember -Function New-VCFNetworkPool


Function Remove-VCFNetworkPool {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & deletes a Network Pool.
	

    .DESCRIPTION
    The Remove-VCFNetworkPool cmdlet connects to the specified SDDC Manager 
	& deletes a Network Pool. 
	

    .EXAMPLE
    PS C:\> This example shows how to get a Network Pool by name
	
	PS C:\> Remove-VCFNetworkPool -id "7ee7c7d2-5251-4bc9-9f91-4ee8d911511f"
	


    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$id
    )
	
$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/network-pools/$id"

try { 
            # This API does not return a response
			$response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }

}
Export-ModuleMember -Function Remove-VCFNetworkPool

######### End Network Pool Operations ##########

######### Start License Key Operations ##########

Function Get-VCFLicenseKey {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & retrieves a list of License keys.
	

    .DESCRIPTION
    The Get-VCFLicenseKey cmdlet connects to the specified SDDC Manager 
	& retrieves a list of License keys. 
	

    .EXAMPLE
    PS C:\> This example shows how to get a list of all License keys
	
	PS C:\> Get-VCFLicenseKey
	
	.EXAMPLE
    PS C:\> This example shows how to get a specified License key
	
	PS C:\> Get-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
	
	.EXAMPLE
    PS C:\> This example shows how to get a License Key by product type
	Supported Product Types: SDDC_MANAGER,VCENTER,NSXV,VSAN,ESXI,VRA,VROPS,NSXT
	
	PS C:\> Get-VCFLicenseKey -productType "VCENTER,VSAN"
	
	.EXAMPLE
    PS C:\> This example shows how to get a License by status
	Supported Status Types: EXPIRED,ACTIVE,NEVER_EXPIRES
	
	PS C:\> Get-VCFLicenseKey -status EXPIRED
	

    #>
	
	param (
        [Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$key,
		[Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$productType,
		[Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$status
    )

$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
try { 
            if ($PsBoundParameters.ContainsKey("key"))
			{
			$uri = "https://$sddcManager/v1/license-keys/$key"
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response
			}
			if ($PsBoundParameters.ContainsKey("productType"))
			{
			$uri = "https://$sddcManager/v1/license-keys?productType=$productType"
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements
			}
			if ($PsBoundParameters.ContainsKey("status"))
			{
			$uri = "https://$sddcManager/v1/license-keys?licenseKeyStatus=$status"
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements
			}
            if ( -not $PsBoundParameters.ContainsKey("key") -and ( -not $PsBoundParameters.ContainsKey("productType")) -and ( -not $PsBoundParameters.ContainsKey("status")))
			{
			$uri = "https://$sddcManager/v1/license-keys"
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements
			}
        
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
	}
Export-ModuleMember -Function Get-VCFLicenseKey

Function New-VCFLicenseKey {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & adds a new License Key.
	

    .DESCRIPTION
    The New-VCFLicenseKey cmdlet connects to the specified SDDC Manager 
	& adds a new License Key. 
	

    .EXAMPLE
    PS C:\> This example shows how to add a new License Key
	
	PS C:\> New-VCFLicenseKey -json .\LicenseKey\addLicenseKeySpec.json

    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$json 
    )
	
if (!(Test-Path $json)) {
Throw "JSON File Not Found"
}
else {
# Read the createNetworkPool json file contents into the $ConfigJson variable
$ConfigJson = (Get-Content $json)
$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/license-keys"
try { 
			$response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $ConfigJson			
			# This API does not return a response body. Sending GET to validate the License Key creation was successful
			$license = $ConfigJson | ConvertFrom-Json
			$licenseKey = $license.key
			Get-VCFLicenseKey -key $licenseKey
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
	}
							}
Export-ModuleMember -Function New-VCFLicenseKey

Function Remove-VCFLicenseKey {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & deletes a license key.
	

    .DESCRIPTION
    The Remove-VCFLicenseKey cmdlet connects to the specified SDDC Manager 
	& deletes a License Key. A license Key can only be removed if it is not in use.
	

    .EXAMPLE
    PS C:\> This example shows how to delete a License Key
	
	PS C:\> Remove-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
	


    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$key
    )
	
$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/license-keys/$key"

try { 
            # This API does not return a response
			$response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }

}
Export-ModuleMember -Function Remove-VCFLicenseKey

######### End License Operations ##########


######### Start Task Operations ##########

Function Get-VCFTask {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & retrieves a list of tasks.
	

    .DESCRIPTION
    The Get-VCFTask cmdlet connects to the specified SDDC Manager 
	& retrieves a list of tasks. 
	

    .EXAMPLE
	PS C:\> This example shows how to get all tasks
	
	PS C:\> Get-VCFTask
	
	.EXAMPLE
	PS C:\> This example shows how to get a task by id
	
	PS C:\> Get-VCFTask -id 7e1c2eee-3177-4e3b-84db-bfebc83f386a 


    #>
	
	param (
        [Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$id
    )

$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")


if ($PsBoundParameters.ContainsKey("id")) {
$uri = "https://$sddcManager/v1/tasks/$id"
$uri
}
if ( -not $PsBoundParameters.ContainsKey("id")) {
$uri = "https://$sddcManager/v1/tasks/"
}

try { 
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response
        
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
	}
Export-ModuleMember -Function Get-VCFTask

Function Retry-VCFTask {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & retries a previously failed task.
	

    .DESCRIPTION
    The Retry-VCFTask cmdlet connects to the specified SDDC Manager 
	& retries a previously failed task using the task id.
	

    .EXAMPLE
	Retry-VCFTask -taskid 7e1c2eee-3177-4e3b-84db-bfebc83f386a


    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$id
    )

$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/tasks/$id"

try { 
            $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers
			
        
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response | Format-List -Force
		$response
        <# if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        }  #>
        

    }
	}
Export-ModuleMember -Function Retry-VCFTask
	
#### End Task Operations #####

######### Start Credential Operations ##########

Function Get-VCFCredential {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & retrieves a list of credentials.
	

    .DESCRIPTION
    The Get-VCFCredential cmdlet connects to the specified SDDC Manager 
	& retrieves a list of credentials. A privileged user account is required.
	

    .EXAMPLE
    PS C:\> This example shows how to get a list of credentials
	
	PS C:\> Get-VCFCredential -privilegedUsername sec-admin@rainpole.local 
	-privilegedPassword VMw@re1!
	
	.EXAMPLE
    PS C:\> This example shows how to get the credential for a specific resourceName (FQDN)
	
	PS C:\> Get-VCFCredential -privilegedUsername sec-admin@rainpole.local 
	-privilegedPassword VMw@re1! -resourceName sfo01m01esx01.sfo01.rainpole.local


    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$privilegedUsername,
		[Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$privilegedPassword,
		[Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$resourceName
    )

$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$headers.Add("privileged-username", "$privilegedUsername")
$headers.Add("privileged-password", "$privilegedPassword")

if ($PsBoundParameters.ContainsKey("resourceName"))
{
$uri = "https://$sddcManager/v1/credentials?resourceName=$resourceName"
}
else
{
$uri = "https://$sddcManager/v1/credentials"
}
try { 
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response
       
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
}
Export-ModuleMember -Function Get-VCFCredential

Function Update-VCFCredential {

<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & updates a credential.
	

    .DESCRIPTION
	The Update-VCFCredential cmdlet connects to the specified SDDC Manager 
	& updates a credential. Credentials can be updated with a specified password(s)
	or rotated using system generated password(s).
	

    .EXAMPLE
	PS C:\> This example shows how to update a credential using a json spec
	
	PS C:\> Update-VCFCredential -json .\Credential\updateCredentialSpec.json


    #>
	
	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$privilegedUsername,
		[Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$privilegedPassword,
		[Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$json
    )

if ($PsBoundParameters.ContainsKey("json"))
			{
if (!(Test-Path $json)) {
Throw "JSON File Not Found"
}
else {
# Read the json file contents into the $ConfigJson variable
$ConfigJson = (Get-Content $json)
} }
$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/credentials"
try { 
			$response = Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
			$response
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }
}
Export-ModuleMember -Function Update-VCFCredential	

######### End Credential Operations ##########

########
########
# Validation Functions

Function Validate-CommissionHostSpec {

	Param (
        [Parameter (Mandatory=$true)]
        [string]$json
    )
	
$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/hosts/validations/commissions"

try { 
            $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $json
			
        
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }	
}

Function Validate-WorkloadDomainSpec {

	Param (
        [Parameter (Mandatory=$true)]
        [object]$json
    )
	

$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/domains/validations/creations"

try { 
            $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $json
			
        
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }	
}

Function Validate-VCFClusterSpec {

	Param (
        [Parameter (Mandatory=$true)]
        [object]$json
    )
	
$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/clusters/validations/creations"

try { 
            $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $json
			
        
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }	
}

Function Validate-VCFUpdateClusterSpec {

	Param (
        [Parameter (Mandatory=$true)]
        [object]$clusterid,
		[Parameter (Mandatory=$true)]
        [object]$json
    )
	
$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/clusters/$clusterid/validations/updates"

try { 
            $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $json
			
        
    }
    catch {
        
        #Get response from the exception
        $response = $_.exception.response
        if ($response) {  
            $responseStream = $_.exception.response.GetResponseStream()
            $reader = New-Object system.io.streamreader($responseStream)
            $responseBody = $reader.readtoend()
            $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
            throw $ErrorString
        }
        else { 
            throw $_ 
        } 
        

    }	
}
