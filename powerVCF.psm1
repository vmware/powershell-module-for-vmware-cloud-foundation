#PowerShell module for VMware Cloud Foundation
#Contributions, Improvements &/or Complete Re-writes Welcome!
#https://github.com/PowerVCF/PowerVCF

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

### Note
#This powershell module should be considered entirely experimental. It is still
#in development & not tested beyond lab scenarios.
#It is recommended you dont use it for any production environment
#without testing extensively!


# Enable communication with self signed certs when using Powershell Core
# If you require all communications to be secure and do not wish to
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
    Connects to the specified SDDC Manager and stores the credentials in a base64 string

    .DESCRIPTION
    The Connect-VCFManager cmdlet connects to the specified SDDC Manager and stores the credentials
	in a base64 string. It is required once per session before running all other cmdlets

    .EXAMPLE
	PS C:\> Connect-VCFManager -fqdn sfo01vcf01.sfo.rainpole.local -username admin -password VMware1!
    This example shows how to connect to SDDC Manager
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
    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")

    # Checking against the sddc-managers API
    $uri = "https://$sddcManager/v1/sddc-managers"
    Try {
            # PS Core has -SkipCertificateCheck implemented, PowerShell 5.x does not
            if ($PSEdition -eq 'Core') {
                $response = Invoke-WebRequest -Method GET -Uri $uri -Headers $headers -SkipCertificateCheck
            }
            else {
                $response = Invoke-WebRequest -Method GET -Uri $uri -Headers $headers
            }
        if ($response.StatusCode -eq 200) {
            Write-Host ""
            Write-Host " Successfully connected to SDDC Manager:" $sddcManager -ForegroundColor Yellow
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
    Connects to the specified SDDC Manager and retrieves a list of hosts.

    .DESCRIPTION
    The Get-VCFHost cmdlet connects to the specified SDDC Manager and retrieves a list of hosts.
	  VCF Hosts are defined by status
	  - ASSIGNED - Hosts that are assigned to a Workload domain
	  - UNASSIGNED_USEABLE - Hosts that are available to be assigned to a Workload Domain
	  - UNASSIGNED_UNUSEABLE - Hosts that are currently not assigned to any domain and can be used
	  for other domain tasks after completion of cleanup operation

    .EXAMPLE
	  PS C:\> Get-VCFHost
    This example shows how to get all hosts regardless of status

	 .EXAMPLE
	 PS C:\> Get-VCFHost -Status ASSIGNED
   This example shows how to get all hosts with a specific status

	 .EXAMPLE
	 PS C:\> Get-VCFHost -id edc4f372-aab5-4906-b6d8-9b96d3113304
   This example shows how to get a host by id

	 .EXAMPLE
	 PS C:\> Get-VCFHost -fqdn sfo01m01esx01.sfo01.rainpole.local
   This example shows how to get a host by fqdn
#>

	param (
        [Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$fqdn,
		[Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$Status,
        [Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$id
    )

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")

    if ($PsBoundParameters.ContainsKey("status")) {
        $uri = "https://$sddcManager/v1/hosts?status=$status"
    }
    if ($PsBoundParameters.ContainsKey("id")) {
        $uri = "https://$sddcManager/v1/hosts/$id"
    }
    if ( -not $PsBoundParameters.ContainsKey("status") -and ( -not $PsBoundParameters.ContainsKey("id"))) {
        $uri = "https://$sddcManager/v1/hosts"
    }
    if ($PsBoundParameters.ContainsKey("fqdn")) {
        $uri = "https://$sddcManager/v1/hosts"
    }

    try {
        if ($PsBoundParameters.ContainsKey("fqdn")) {
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements | Where-Object {$_.fqdn -eq $fqdn}
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
        if ($PsBoundParameters.ContainsKey("status")) {
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
        if ( -not $PsBoundParameters.ContainsKey("status") -and ( -not $PsBoundParameters.ContainsKey("id")) -and ( -not $PsBoundParameters.ContainsKey("fqdn"))) {
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
    }
    catch {
        #Get response from the exception
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFHost

Function Commission-VCFHost {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager and commissions a list of hosts.

    .DESCRIPTION
    The Commission-VCFHost cmdlet connects to the specified SDDC Manager
	  and commissions a list of hosts. Host list spec is provided in a JSON file.

    .EXAMPLE
    PS C:\> Commission-VCFHost -json .\Host\commissionHosts\commissionHostSpec.json
    This example shows how to commission a list of hosts based on the details
    provided in the JSON file.
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
        # Reads the commissionHostsJSON json file contents into the $ConfigJson variable
        $ConfigJson = (Get-Content -Raw $json)
        $headers = @{"Accept" = "application/json"}
        $headers.Add("Authorization", "Basic $base64AuthInfo")

            # Validate the provided JSON input specification file
            $response = Validate-CommissionHostSpec -json $ConfigJson
            # get the task id from the validation function
            $taskId = $response.id
            # keep checking until executionStatus is not IN_PROGRESS
            do {
                $uri = "https://$sddcManager/v1/hosts/validations/$taskId"
                $response = Invoke-RestMethod -Method GET -URI $uri -Headers $headers -ContentType application/json

            } While ($response.executionStatus -eq "IN_PROGRESS")

            # Submit the commissiong job only if the JSON validation task finished with executionStatus=COMPLETED & resultStatus=SUCCEEDED
            if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
                Try {
                    Write-Host ""
                    Write-Host "Task validation completed successfully, invoking host(s) commissiong on SDDC Manager" -ForegroundColor Green
                    $uri = "https://$sddcManager/v1/hosts/"
                    $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
		    return $response
                    Write-Host ""
                }
                Catch {
                    #Get response from the exception
                    ResponseExeception
                }
            }
            else {
                Write-Host ""
                Write-Host "The validation task commpleted the run with the following problems:" -ForegroundColor Yellow
                Write-Host $response.validationChecks.errorResponse.message  -ForegroundColor Yellow
                Write-Host ""
            }
    }
}
Export-ModuleMember -Function Commission-VCFHost

Function Decommission-VCFHost {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager and decommissions a list of hosts.
	  Host list is provided in a JSON file.

    .DESCRIPTION
    The Decommission-VCFHost cmdlet connects to the specified SDDC Manager
	  and decommissions a list of hosts.

    .EXAMPLE
    PS C:\> Decommission-VCFHost -json .\Host\decommissionHostSpec.json
    This example shows how to decommission a set of hosts based on the details
    provided in the JSON file.
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
            ResponseExeception
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
    PS C:\> Get-VCFWorkloadDomain
    This example shows how to get a list of Workload Domains

	.EXAMPLE
    PS C:\> Get-VCFWorkloadDomain -name WLD01
    This example shows how to get a Workload Domain by name

	.EXAMPLE
    PS C:\> Get-VCFWorkloadDomain -id 8423f92e-e4b9-46e7-92f7-befce4755ba2
    This example shows how to get a Workload Domain by id
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

    if ($PsBoundParameters.ContainsKey("id")) {
        $uri = "https://$sddcManager/v1/domains/$id"
    }
    if ($PsBoundParameters.ContainsKey("name")) {
        $uri = "https://$sddcManager/v1/domains"
    }
    if ( -not $PsBoundParameters.ContainsKey("name") -and ( -not $PsBoundParameters.ContainsKey("id"))) {
        $uri = "https://$sddcManager/v1/domains"
    }
    try {
        <# $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response #>
        if ($PsBoundParameters.ContainsKey("name")) {
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements | Where-Object {$_.name -eq $name}
		}
		if ($PsBoundParameters.ContainsKey("id")) {
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response
		}
        if ( -not $PsBoundParameters.ContainsKey("name") -and ( -not $PsBoundParameters.ContainsKey("id"))) {
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements
		}
	}
    catch {
        #Get response from the exception
        ResponseExeception
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
	PS C:\> New-VCFWorkloadDomain -json .\WorkloadDomain\workloadDomainSpec.json
    This example shows how to create a Workload Domain from a json spec
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
			# Validate the provided JSON input specification file
            $response = Validate-WorkloadDomainSpec -json $ConfigJson
            # the validation API does not currently support polling with a task ID
            Sleep 5
            # Submit the job only if the JSON validation task completed with executionStatus=COMPLETED & resultStatus=SUCCEEDED
            if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
				Try {
                    Write-Host ""
                    Write-Host "Task validation completed successfully, invoking Workload Domain Creation on SDDC Manager" -ForegroundColor Green
					$uri = "https://$sddcManager/v1/domains"
					$response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
					Write-Host ""
					}
				catch {
					#Get response from the exception
					ResponseExeception
					}
				}
            else {
                Write-Host ""
                Write-Host "The validation task commpleted the run with the following problems:" -ForegroundColor Yellow
                Write-Host $response.validationChecks.errorResponse.message  -ForegroundColor Yellow
                Write-Host ""
            }
    }
}
Export-ModuleMember -Function New-VCFWorkloadDomain

Function Set-VCFWorkloadDomain {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & marks a workload domain for deletion.

    .DESCRIPTION
    Before a workload domain can be deleted it must first be marked for deletion.
	The Set-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager
	& marks a workload domain for deletion.

    .EXAMPLE
	PS C:\> Set-VCFWorkloadDomain -id fbdcf199-c086-43aa-9071-5d53b5c5b99d
    This example shows how to mark a workload domain for deletion
#>

	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$id
    )

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/domains/$id"
    $body = '{"markForDeletion": true}'
    try {
	    $response = Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $body
	    # This API does not return a response
    }
    catch {
        #Get response from the exception
        ResponseExeception
    }
}
Export-ModuleMember -Function Set-VCFWorkloadDomain

Function Remove-VCFWorkloadDomain {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & deletes a workload domain.

    .DESCRIPTION
    Before a workload domain can be deleted it must first be marked for deletion.
	See Set-VCFWorkloadDomain
	The Remove-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager
	& deletes a workload domain.

    .EXAMPLE
	PS C:\> Remove-VCFWorkloadDomain -id fbdcf199-c086-43aa-9071-5d53b5c5b99d
    This example shows how to delete a workload domain
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
        ResponseExeception
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
    PS C:\> Get-VCFCluster
    This example shows how to get a list of all clusters

	.EXAMPLE
    PS C:\> Get-VCFCluster -name wld01-cl01
    This example shows how to get a cluster by name

	.EXAMPLE
    PS C:\> Get-VCFCluster -id 8423f92e-e4b9-46e7-92f7-befce4755ba2
    This example shows how to get a cluster by id
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

    if ($PsBoundParameters.ContainsKey("id")) {
        $uri = "https://$sddcManager/v1/clusters/$id"
    }
    else {
        $uri = "https://$sddcManager/v1/clusters"
    }
    try {
        if ($PsBoundParameters.ContainsKey("name")) {
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements | Where-Object {$_.name -eq $name}
		}
		if ($PsBoundParameters.ContainsKey("id")) {
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements | Where-Object {$_.id -eq $id}
		}
        if ( -not $PsBoundParameters.ContainsKey("name") -and ( -not $PsBoundParameters.ContainsKey("id"))) {
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements
        }
	}
    catch {
        #Get response from the exception
        ResponseExeception
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
	PS C:\> New-VCFCluster -json .\WorkloadDomain\addClusterSpec.json
    This example shows how to create a cluster in a Workload Domain from a json spec
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
			# Validate the provided JSON input specification file
            $response = Validate-VCFClusterSpec -json $ConfigJson
            # the validation API does not currently support polling with a task ID
            Sleep 5
            # Submit the job only if the JSON validation task finished with executionStatus=COMPLETED & resultStatus=SUCCEEDED
            if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
                Try {
                    Write-Host ""
                    Write-Host "Task validation completed successfully, invoking cluster task on SDDC Manager" -ForegroundColor Green
					$uri = "https://$sddcManager/v1/clusters"
					$response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
					$response.elements
				}
				catch {
					#Get response from the exception
					ResponseExeception
				}
			}
			else {
                Write-Host ""
                Write-Host "The validation task commpleted the run with the following problems:" -ForegroundColor Yellow
                Write-Host $response.validationChecks.errorResponse.message  -ForegroundColor Yellow
                Write-Host ""
            }
    }
}
Export-ModuleMember -Function New-VCFCluster

Function Set-VCFCluster {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & expands or compacts a cluster.

    .DESCRIPTION
	The Set-VCFCluster cmdlet connects to the specified SDDC Manager
	& expands or compacts a cluster by adding or removing a host(s). A cluster
	can also be marked for deletion

    .EXAMPLE
	PS C:\> Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1
	-json .\Cluster\clusterExpansionSpec.json
    This example shows how to expand a cluster by adding a host(s)

	.EXAMPLE
	PS C:\> Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1
	-json .\Cluster\clusterCompactionSpec.json
    This example shows how to compact a cluster by removing a host(s)

	.EXAMPLE
	PS C:\> Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1
	-markForDeletion
    This example shows how to mark a cluster for deletion
#>

	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$id,
		[Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$json,
		[Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [switch]$markForDeletion
    )

    if ($PsBoundParameters.ContainsKey("json")) {
        if (!(Test-Path $json)) {
            Throw "JSON File Not Found"
        }
        else {
            # Read the json file contents into the $ConfigJson variable
            $ConfigJson = (Get-Content $json)
        }
    }
    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
		try {
			if ( -not $PsBoundParameters.ContainsKey("json") -and ( -not $PsBoundParameters.ContainsKey("markForDeletion"))) {
				throw "You must include either -json or -markForDeletion"
			}
			if ($PsBoundParameters.ContainsKey("json")) {
				# Validate the provided JSON input specification file
				$response = Validate-VCFUpdateClusterSpec -clusterid $clusterid -json $ConfigJson
				# the validation API does not currently support polling with a task ID
				Sleep 5
				# Submit the job only if the JSON validation task finished with executionStatus=COMPLETED & resultStatus=SUCCEEDED
				if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
					Try {
						Write-Host ""
						Write-Host "Task validation completed successfully, invoking cluster task on SDDC Manager" -ForegroundColor Green
						$uri = "https://$sddcManager/v1/clusters/$clusterid/"
						$response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
						return $response
						Write-Host ""
					}
					Catch {
						#Get response from the exception
						ResponseExeception
					}
				}
				else {
					Write-Host ""
					Write-Host "The validation task commpleted the run with the following problems:" -ForegroundColor Yellow
					Write-Host $response.validationChecks.errorResponse.message  -ForegroundColor Yellow
					Write-Host ""
				}
		}
			if ($PsBoundParameters.ContainsKey("markForDeletion")) {
				$ConfigJson = '{"markForDeletion": true}'
				$response = Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
			}
		}
		catch {
			#Get response from the exception
			ResponseExeception
		}
}
Export-ModuleMember -Function Set-VCFCluster

Function Remove-VCFCluster {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & deletes a cluster.

    .DESCRIPTION
    Before a cluster can be deleted it must first be marked for deletion. See Set-VCFCluster
	The Remove-VCFCluster cmdlet connects to the specified SDDC Manager & deletes a cluster.

    .EXAMPLE
	PS C:\> Remove-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1
    This example shows how to delete a cluster
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
        ResponseExeception
    }
}
Export-ModuleMember -Function Remove-VCFCluster

######### End Cluster Operations ##########


######### Start Network Pool Operations ##########

Function Get-VCFNetworkPool {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & retrieves a list of Network Pools.

    .DESCRIPTION
    The Get-VCFNetworkPool cmdlet connects to the specified SDDC Manager
	& retrieves a list of Network Pools.

    .EXAMPLE
    PS C:\> Get-VCFNetworkPool
    This example shows how to get a list of all Network Pools

	.EXAMPLE
    PS C:\> Get-VCFNetworkPool -name sfo01-networkpool
    This example shows how to get a Network Pool by name

	.EXAMPLE
    PS C:\> Get-VCFNetworkPool -id 40b0b36d-36d6-454c-814b-ba8bf9b383e3
    This example shows how to get a Network Pool by id
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
        if ($PsBoundParameters.ContainsKey("name")) {
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements | Where-Object {$_.name -eq $name}
        }
	    if ($PsBoundParameters.ContainsKey("id")) {
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements | Where-Object {$_.id -eq $id}
	    }
        if ( -not $PsBoundParameters.ContainsKey("name") -and ( -not $PsBoundParameters.ContainsKey("id"))) {
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements
		}

    }
    catch {
        #Get response from the exception
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFNetworkPool

Function New-VCFNetworkPool {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & creates a new Network Pool.

    .DESCRIPTION
    The New-VCFNetworkPool cmdlet connects to the specified SDDC Manager & creates a new Network Pool.
	Network Pool spec is provided in a JSON file.

    .EXAMPLE
    PS C:\> New-VCFNetworkPool -json .\NetworkPool\createNetworkPoolSpec.json
    This example shows how to create a Network Pool
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
            ResponseExeception
        }
    }
}
Export-ModuleMember -Function New-VCFNetworkPool

Function Remove-VCFNetworkPool {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager & deletes a Network Pool.

    .DESCRIPTION
    The Remove-VCFNetworkPool cmdlet connects to the specified SDDC Manager & deletes a Network Pool.

    .EXAMPLE
    PS C:\> Remove-VCFNetworkPool -id 7ee7c7d2-5251-4bc9-9f91-4ee8d911511f
    This example shows how to get a Network Pool by id
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
        ResponseExeception
    }
}
Export-ModuleMember -Function Remove-VCFNetworkPool

Function Get-VCFNetworkIPPool {
<#
    .SYNOPSIS
    Get a Network of a Network Pool

    .DESCRIPTION
    The Get-VCFNetworkIPPool cmdlet connects to the specified SDDC Manager and retrieves a list of the networks
	  configured for the provided network pool.

    .EXAMPLE
    PS C:\> Get-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52
    This example shows how to get a list of all networks associated to the network pool based on the id provided

    .EXAMPLE
    PS C:\> Get-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkid c2197368-5b7c-4003-80e5-ff9d3caef795
    This example shows how to get a list of details for a specific network associated to the network pool using ids
#>

	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$id,
        [Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$networkid
    )

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    if ($PsBoundParameters.ContainsKey("id")) {
        $uri = "https://$sddcManager/v1/network-pools/$id/networks"
    }
    if ($PsBoundParameters.ContainsKey("id") -and ($PsBoundParameters.ContainsKey("networkid"))) {
        $uri = "https://$sddcManager/v1/network-pools/$id/networks/$networkid"
    }
    try {
        if ($PsBoundParameters.ContainsKey("id")) {
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id") -and ($PsBoundParameters.ContainsKey("networkid"))) {
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
    }
    catch {
        #Get response from the exception
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFNetworkIPPool

Function Add-VCFNetworkIPPool {
<#
    .SYNOPSIS
    Add an IP Pool to the Network of a Network Pool

    .DESCRIPTION
    The Add-VCFNetworkIPPool cmdlet connects to the specified SDDC Manager and adds a new IP Pool to an existing Network within
	a Network Pool.

    .EXAMPLE
    PS C:\> Add-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkid c2197368-5b7c-4003-80e5-ff9d3caef795 -ipStart 192.168.110.61 -ipEnd 192.168.110.64
    This example shows how create a new IP Pool on the existing network for a given Network Pool
#>

	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$id,
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$networkid,
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$ipStart,
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$ipEnd
    )

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/network-pools/$id/networks/$networkid/ip-pools"
    $body = '{"end": "'+$ipEnd+'","start": "'+$ipStart+'"}'
    try {
        $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $body
        $response
    }
    catch {
        #Get response from the exception
        ResponseExeception
    }
}
Export-ModuleMember -Function Add-VCFNetworkIPPool

Function Remove-VCFNetworkIPPool {
<#
    .SYNOPSIS
    Remove an IP Pool from the Network of a Network Pool

    .DESCRIPTION
    The Remove-VCFNetworkIPPool cmdlet connects to the specified SDDC Manager and removes an IP Pool assigned to an existing Network within
	a Network Pool.

    .EXAMPLE
    PS C:\> Remove-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkid c2197368-5b7c-4003-80e5-ff9d3caef795 -ipStart 192.168.110.61 -ipEnd 192.168.110.64
    This example shows how remove an IP Pool on the existing network for a given Network Pool
#>

	param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$id,
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$networkid,
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$ipStart,
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$ipEnd
    )

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/network-pools/$id/networks/$networkid/ip-pools"
    $body = '{"end": "'+$ipEnd+'","start": "'+$ipStart+'"}'
    try {
        $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers -ContentType application/json -body $body
        $response
    }
    catch {
        #Get response from the exception
        ResponseExeception
    }
}
Export-ModuleMember -Function Remove-VCFNetworkIPPool

######### End Network Pool Operations ##########


######### Start License Key Operations ##########

Function Get-VCFLicenseKey {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager and retrieves a list of License keys.

    .DESCRIPTION
    The Get-VCFLicenseKey cmdlet connects to the specified SDDC Manager and retrieves a list of License keys.

    .EXAMPLE
    PS C:\> Get-VCFLicenseKey
    This example shows how to get a list of all License keys

	.EXAMPLE
    PS C:\> Get-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
    This example shows how to get a specified License key

	.EXAMPLE
    PS C:\> Get-VCFLicenseKey -productType "VCENTER,VSAN"
    This example shows how to get a License Key by product type
	Supported Product Types: SDDC_MANAGER,VCENTER,NSXV,VSAN,ESXI,VRA,VROPS,NSXT

	.EXAMPLE
    PS C:\> Get-VCFLicenseKey -status EXPIRED
    This example shows how to get a License by status
	Supported Status Types: EXPIRED,ACTIVE,NEVER_EXPIRES
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
        if ($PsBoundParameters.ContainsKey("key")) {
			$uri = "https://$sddcManager/v1/license-keys/$key"
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response
		}
		if ($PsBoundParameters.ContainsKey("productType")) {
			$uri = "https://$sddcManager/v1/license-keys?productType=$productType"
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements
		}
		if ($PsBoundParameters.ContainsKey("status")) {
			$uri = "https://$sddcManager/v1/license-keys?licenseKeyStatus=$status"
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements
		}
        if ( -not $PsBoundParameters.ContainsKey("key") -and ( -not $PsBoundParameters.ContainsKey("productType")) -and ( -not $PsBoundParameters.ContainsKey("status"))) {
			$uri = "https://$sddcManager/v1/license-keys"
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements
		}

    }
    catch {
        #Get response from the exception
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFLicenseKey

Function New-VCFLicenseKey {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager and adds a new License Key.

    .DESCRIPTION
    The New-VCFLicenseKey cmdlet connects to the specified SDDC Manager and adds a new License Key.

    .EXAMPLE
    PS C:\> New-VCFLicenseKey -json .\LicenseKey\addLicenseKeySpec.json
    This example shows how to add a new License Key
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
            ResponseExeception
        }
    }
}
Export-ModuleMember -Function New-VCFLicenseKey

Function Remove-VCFLicenseKey {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager and deletes a license key.

    .DESCRIPTION
    The Remove-VCFLicenseKey cmdlet connects to the specified SDDC Manager
	  and deletes a License Key. A license Key can only be removed if it is not in use.

    .EXAMPLE
    PS C:\> Remove-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
    This example shows how to delete a License Key
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
        ResponseExeception
    }

}
Export-ModuleMember -Function Remove-VCFLicenseKey

######### End License Operations ##########


######### Start Task Operations ##########

Function Get-VCFTask {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager and retrieves a list of tasks.

    .DESCRIPTION
    The Get-VCFTask cmdlet connects to the specified SDDC Manager and retrieves a list of tasks.

    .EXAMPLE
	PS C:\> Get-VCFTask
    This example shows how to get all tasks

	.EXAMPLE
	PS C:\> Get-VCFTask -id 7e1c2eee-3177-4e3b-84db-bfebc83f386a
    This example shows how to get a task by id
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
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFTask

Function Retry-VCFTask {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager and retries a previously failed task.

    .DESCRIPTION
    The Retry-VCFTask cmdlet connects to the specified SDDC Manager and retries a previously
    failed task using the task id.

    .EXAMPLE
	PS C:\> Retry-VCFTask -id 7e1c2eee-3177-4e3b-84db-bfebc83f386a
    This example retries the task based on the task id
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
        ResponseExeception
    }
}
Export-ModuleMember -Function Retry-VCFTask

#### End Task Operations #####


######### Start Credential Operations ##########

Function Get-VCFCredential {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager and retrieves a list of credentials.

    .DESCRIPTION
    The Get-VCFCredential cmdlet connects to the specified SDDC Manager and retrieves a list of
    credentials. A privileged user account is required.

    .EXAMPLE
    PS C:\> Get-VCFCredential -privilegedUsername sec-admin@rainpole.local
	-privilegedPassword VMw@re1!
    This example shows how to get a list of credentials

	.EXAMPLE
    PS C:\> Get-VCFCredential -privilegedUsername sec-admin@rainpole.local
	-privilegedPassword VMw@re1! -resourceName sfo01m01esx01.sfo.rainpole.local
    This example shows how to get the credential for a specific resourceName (FQDN)
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

    if ($PsBoundParameters.ContainsKey("resourceName")) {
        $uri = "https://$sddcManager/v1/credentials?resourceName=$resourceName"
    }
    else {
        $uri = "https://$sddcManager/v1/credentials"
    }
    try {
	    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
	    $response
    }
    catch {
        #Get response from the exception
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFCredential

Function Set-VCFCredential {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager and updates a credential.

    .DESCRIPTION
	The Set-VCFCredential cmdlet connects to the specified SDDC Manager and updates a credential.
    Credentials can be updated with a specified password(s) or rotated using system generated password(s).

    .EXAMPLE
	PS C:\> Set-VCFCredential -json .\Credential\updateCredentialSpec.json
    This example shows how to update a credential using a json spec
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

    if ($PsBoundParameters.ContainsKey("json")) {
        if (!(Test-Path $json)) {
            Throw "JSON File Not Found"
        }
        else {
            # Read the json file contents into the $ConfigJson variable
            $ConfigJson = (Get-Content $json)
        }
    }
    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/credentials"
    try {
        $response = Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
    $response
    }
    catch {
        #Get response from the exception
        ResponseExeception
    }
}
Export-ModuleMember -Function Set-VCFCredential

######### End Credential Operations ##########


######## Start Validation Functions ########

Function Validate-CommissionHostSpec {

	Param (
        [Parameter (Mandatory=$true)]
        [object]$json
    )
    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/hosts/validations"
	$json = $json | ConvertFrom-json
	# Construct the hostCommissionSpecs json format as required by the validation API
	$body = @()
	$body += [pscustomobject]@{
            hostCommissionSpecs = $json
        } | ConvertTo-Json
	# Remove the redundant ETS-supplied .Count property if it exists
	if (Get-TypeData System.Array) {
		Remove-TypeData System.Array
		}
    try {
    $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $body
    return $response
    }
    catch {
        #Get response from the exception
        ResponseExeception
    }
}

Function Validate-WorkloadDomainSpec {

	Param (
        [Parameter (Mandatory=$true)]
        [object]$json
    )

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/domains/validations"
	$json = $json | ConvertFrom-json
	# Construct the domainCreationSpec json format as required by the validation API
	$body = @()
	$body += [pscustomobject]@{
            domainCreationSpec = $json
        } | ConvertTo-Json -Depth 10
	# Remove the redundant ETS-supplied .Count property if it exists
	if (Get-TypeData System.Array) {
		Remove-TypeData System.Array
		}
    try {
        $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $body
	}
    catch {
        #Get response from the exception
        ResponseExeception
    }
}

Function Validate-VCFClusterSpec {

	Param (
        [Parameter (Mandatory=$true)]
        [object]$json
    )

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/clusters/validations"
	$json = $json | ConvertFrom-json
	# Construct the clusterCreationSpec json format as required by the validation API
	$body = @()
	$body += [pscustomobject]@{
            clusterCreationSpec = $json
        } | ConvertTo-Json -Depth 10
	# Remove the redundant ETS-supplied .Count property if it exists
	if (Get-TypeData System.Array) {
		Remove-TypeData System.Array
		}
    try {
        $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $body
	}
    catch {
        #Get response from the exception
        ResponseExeception
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
    $uri = "https://$sddcManager/v1/clusters/$clusterid/validations"
	$json = $json | ConvertFrom-json
	# Construct the clusterUpdateSpec json format as required by the validation API
	$body = @()
	$body += [pscustomobject]@{
            clusterUpdateSpec = $json
        } | ConvertTo-Json -Depth 10
	# Remove the redundant ETS-supplied .Count property if it exists
	if (Get-TypeData System.Array) {
		Remove-TypeData System.Array
		}
    try {
        $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $body
	}
    catch {
        #Get response from the exception
        ResponseExeception
    }
}

######## End Validation Functions ########


######### Start CEIP Operations ##########

Function Get-VCFCeip {
<#
    .SYNOPSIS
    Retrieves the current setting for CEIP of the connected SDDC Manager

    .DESCRIPTION
    TThe Get-VCFCeip cmdlet retrieves the current setting for Customer Experience Improvement Program
    (CEIP) of the connected SDDC Manager.

    .EXAMPLE
	PS C:\> Get-VCFCeip
    This example shows how to get the current setting of CEIP
#>

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/system/ceip"
    try {
		    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
		    $response
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }

}
Export-ModuleMember -Function Get-VCFCeip

Function Set-VCFCeip {
<#
    .SYNOPSIS
    Sets the CEIP status (Enabled/Disabled) of the connected SDDC Manager

    .DESCRIPTION
    The Set-VCFCeip cmdlet configures the status (Enabled/Disabled) for Customer Experience Improvement
    Program (CEIP) of the connected SDDC Manager.

    .EXAMPLE
    PS C:\> Set-VCFCeip -ceipSetting ENABLE
    This example shows how to disable CEIP of the connected SDDC Manager
#>

	Param (
		[Parameter (Mandatory=$true)]
        [string]$ceipSetting
    )

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/system/ceip"
    try {
        if ( -not $PsBoundParameters.ContainsKey("ceipsetting")) {
			throw "You must define ENABLE or DISABLE as an input"
		}
        if ($ceipSetting -eq "ENABLE") {
			$ConfigJson = '{"status": "ENABLE"}'
        }
        if ($ceipSetting -eq "DISABLE") {
			$ConfigJson = '{"status": "DISABLE"}'
        }
        $response = Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
        $response
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Set-VCFCeip

######### End CEIP Operations ##########


######### Start Backup Configuration Operations ##########

Function Get-VCFBackupConfiguration {
<#
    .SYNOPSIS
    Gets the backup configuration of NSX Manager and SDDC Manager

    .DESCRIPTION
     Retrieves the backup configuration details and the status

    .EXAMPLE
    PS C:\> Get-VCFBackupConfiguration
    This example shows the backup configuration
#>

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/system/backup-configuration"
    try {
		    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
		    $response
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFBackupConfiguration

Function Start-VCFBackup {
<#
    .SYNOPSIS
    Start the SDDC Manager backup

    .DESCRIPTION
    The Start-VCFBackup cmdlet invokes the SDDC Manager backup task.

    .EXAMPLE
	PS C:\> Start-VCFBackup
    This example shows how to start the SDDC Manager backup

#>

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    # this body is fixed for SDDC Manager backups. not worth having it stored on file
    $ConfigJson = '
        {
            "elements" : [{
                "resourceType" : "SDDC_MANAGER"
            }]
        }
    '
    $uri = "https://$sddcManager/v1/backups/tasks"
    try {
        $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType "application/json" -body $ConfigJson
        $response
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Start-VCFBackup

######### End Backup Configuration Operations ##########


######### Start Bundle Operations ##########

Function Get-VCFBundle {
<#
    .SYNOPSIS
    Get all Bundles i.e uploaded bundles and also bundles available via depot access

    .DESCRIPTION
    Get all Bundles i.e uploaded bundles and also bundles available via depot access.

    .EXAMPLE
    PS C:\> Get-VCFBundle
    This example gets the list of bundles and all details

	.EXAMPLE
    PS C:\> Get-VCFBundle | Select version,downloadStatus,id
    This example gets the list of bundles and filters on the version, download status and the id only

	.EXAMPLE
    PS C:\> Get-VCFBundle -id 7ef354ab-13a6-4e39-9561-10d2c4de89db
    This example gets the details of a specific bundle by its id

    .EXAMPLE
    PS C:\> Get-VCFBundle | Where {$_.description -Match "vRealize"}
    This example lists all bundles that have vRealize in the description field
#>

	Param (
		[Parameter (Mandatory=$false)]
        [string]$id
    )

    # Check the version of SDDC Manager
    CheckVCFVersion

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")

    if ($PsBoundParameters.ContainsKey("id")) {
        $uri = "https://$sddcManager/v1/bundles/$id"
    }
    else{
        $uri = "https://$sddcManager/v1/bundles"
    }
    try {
        if ($PsBoundParameters.ContainsKey("id")) {
	        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
	        $response
        }
        else{
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
		    $response.elements
        }
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFBundle

Function Request-VCFBundle {
<#
    .SYNOPSIS
    Request a Bundle for downloading from depot

    .DESCRIPTION
    Triggers an immediate download. Only one download can be triggered for a Bundle.

    .EXAMPLE
    PS C:\> Request-VCFBundle -id 7ef354ab-13a6-4e39-9561-10d2c4de89db
    This example requests the immediate download of a bundle based on its id
#>

	Param (
		[Parameter (Mandatory=$true)]
        [string]$id
    )

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/bundles/$id"
    try {
        $body = '{"bundleDownloadSpec": {"downloadNow": true}}'
        $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers	-ContentType application/json -body $body
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Request-VCFBundle

######### End Bundle Operations ##########


######### Start Certificate Configuration Operations ##########

Function Get-VCFCertificateAuthConfiguration {
<#
    .SYNOPSIS
    Get certificate authorities information

    .DESCRIPTION
     Retrieves the certificate authorities information for the connected SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFCertificateAuthConfiguration
    This example shows how to get the certificate authority configuration from the connected SDDC Manager
#>

    # Check the version of SDDC Manager
    CheckVCFVersion

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/certificate-authorities"
    try {
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.elements
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFCertificateAuthConfiguration

Function Set-VCFMicrosoftCA {
<#
    .SYNOPSIS
    Configures a Microsoft Certificate Authority

    .DESCRIPTION
    Configures the Microsoft Certificate Authorty on the connected SDDC Manager

    .EXAMPLE
    PS C:\> Set-VCFMicrosoftCA -serverUrl "https://rainpole.local/certsrv" -username Administrator -password "VMw@re1!" -templateName VMware
    This example shows how to configure a Microsoft certificate authority on the connected SDDC Manager
#>

	Param (
		[Parameter (Mandatory=$true)]
        [string]$serverUrl,
		[Parameter (Mandatory=$true)]
        [string]$username,
		[Parameter (Mandatory=$true)]
        [string]$password,
  		[Parameter (Mandatory=$true)]
        [string]$templateName
    )

    # Check the version of SDDC Manager
    CheckVCFVersion

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/certificate-authorities"
    try {
        if ( -not $PsBoundParameters.ContainsKey("serverUrl") -and ( -not $PsBoundParameters.ContainsKey("username") -and ( -not $PsBoundParameters.ContainsKey("password") -and ( -not $PsBoundParameters.ContainsKey("templateName"))))){
			throw "You must enter the mandatory values"
		}
        $ConfigJson = '{"microsoftCertificateAuthoritySpec": {"secret": "'+$password+'","serverUrl": "'+$serverUrl+'","username": "'+$username+'","templateName": "'+$templateName+'"}}'
        $response = Invoke-RestMethod -Method PUT -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Set-VCFMicrosoftCA

Function Get-VCFCertificateCSRs {
<#
    .SYNOPSIS
    Get available CSR(s)

    .DESCRIPTION
    Gets available CSRs from SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFCertificateCSRs -domainName MGMT | ConvertTo-Json
    This example gets a list of CSRs and displays them in JSON format
#>

	Param (
		[Parameter (Mandatory=$true)]
        [string]$domainName
    )

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/domains/$domainName/csrs"
    try {
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFCertificateCSRs

Function Request-VCFCertificateCSRs {
<#
    .SYNOPSIS
    Generate CSR(s)

    .DESCRIPTION
    Generate CSR(s) for the selected resource(s) in the domain
    - Resource Types (SDDC_MANAGER, PSC, VCENTER, NSX_MANAGER, NSXT_MANAGER, VRA,
      VRLI, VROPS, VRSLCM, VXRAIL_MANAGER

    .EXAMPLE
    PS C:\> Request-VCFCertificateCSRs -domainName MGMT -json .\requestCsrSpec.json
    This example requests the generation of the CSR based on the entries within the requestCsrSpec.json file for resources within
    the domain called MGMT
#>

	Param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$json,
		[Parameter (Mandatory=$true)]
            [string]$domainName
    )

    if (!(Test-Path $json)) {
        throw "JSON File Not Found"
    }
    else {
        # Reads the requestCsrSpec json file contents into the $ConfigJson variable
        $ConfigJson = (Get-Content -Raw $json)
        $headers = @{"Accept" = "application/json"}
        $headers.Add("Authorization", "Basic $base64AuthInfo")
        $uri = "https://$sddcManager/v1/domains/$domainName/csrs"
        try {
            $response = Invoke-RestMethod -Method PUT -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
            $response
        }
        catch {
            # Call the function ResponseExeception which handles execption messages
            ResponseExeception
        }
    }
}
Export-ModuleMember -Function Request-VCFCertificateCSRs

Function Get-VCFCertificate {
<#
    .SYNOPSIS
    Get latest generated certificate(s) in a domain

    .DESCRIPTION
    Get latest generated certificate(s) in a domain

    .EXAMPLE
    PS C:\> Get-VCFCertificate -domainName MGMT
    This example gets a list of certificates that have been generated

    .EXAMPLE
    PS C:\> Get-VCFCertificate -domainName MGMT | ConvertTo-Json
    This example gets a list of certificates and displays them in JSON format
#>

	Param (
		[Parameter (Mandatory=$true)]
        [string]$domainName
    )

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/domains/$domainName/certificates"
    try {
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFCertificate

Function Request-VCFCertificate {
<#
    .SYNOPSIS
    Generate certificate(s) for the selected resource(s) in a domain

    .DESCRIPTION
    Generate certificate(s) for the selected resource(s) in a domain. CA must be configured and CSR must be generated beforehand
    - Resource Types (SDDC_MANAGER, PSC, VCENTER, NSX_MANAGER, NSXT_MANAGER, VRA,
      VRLI, VROPS, VRSLCM, VXRAIL_MANAGER

    .EXAMPLE
    PS C:\> Request-VCFCertificate -domainName MGMT -json .\requestCertificateSpec.json
    This example requests the generation of the Certificates based on the entries within the requestCertificateSpec.json file
    for resources within the domain called MGMT
#>

	Param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$json,
		[Parameter (Mandatory=$true)]
            [string]$domainName
    )

    if (!(Test-Path $json)) {
        throw "JSON File Not Found"
    }
    else {
        # Reads the requestCsrSpec json file contents into the $ConfigJson variable
        $ConfigJson = (Get-Content -Raw $json)
        $headers = @{"Accept" = "application/json"}
        $headers.Add("Authorization", "Basic $base64AuthInfo")
        $uri = "https://$sddcManager/v1/domains/$domainName/certificates"
        try {
            $response = Invoke-RestMethod -Method PUT -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
            $response
        }
        catch {
            # Call the function ResponseExeception which handles execption messages
            ResponseExeception
        }
    }
}
Export-ModuleMember -Function Request-VCFCertificate

Function Set-VCFCertificate {
<#
    .SYNOPSIS
    Replace certificate(s) for the selected resource(s) in a domain

    .DESCRIPTION
    Replace certificate(s) for the selected resource(s) in a domain

    .EXAMPLE
    PS C:\> Set-VCFCertificate -domainName MGMT -json .\updateCertificateSpec.json

    This example replaces the Certificates based on the entries within the requestCertificateSpec.json file
    for resources within the domain called MGMT
#>

	Param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$json,
		[Parameter (Mandatory=$true)]
            [string]$domainName
    )

    if (!(Test-Path $json)) {
        throw "JSON File Not Found"
    }
    else {
        # Reads the updateCertificateSpec json file contents into the $ConfigJson variable
        $ConfigJson = (Get-Content -Raw $json)
        $headers = @{"Accept" = "application/json"}
        $headers.Add("Authorization", "Basic $base64AuthInfo")
        $uri = "https://$sddcManager/v1/domains/$domainName/certificates"
        try {
            $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
            $response
        }
        catch {
            # Call the function ResponseExeception which handles execption messages
            ResponseExeception
        }
    }
}
Export-ModuleMember -Function Set-VCFCertificate

######### End Certificate Configuration Operations ##########


######### Start Depot Configuration Operations ##########

Function Get-VCFDepotCredentials {
<#
    .SYNOPSIS
    Get Depot Settings

    .DESCRIPTION
     Retrieves the configuration for the depot of the connected SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFDepotCredentials
    This example shows credentials that have been configured for the depot.
#>

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/system/settings/depot"
    try {
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFDepotCredentials

Function Set-VCFDepotCredentials {
<#
    .SYNOPSIS
    Update the Depot Settings

    .DESCRIPTION
     Update the configuration for the depot of the connected SDDC Manager

    .EXAMPLE
    PS C:\> Set-VCFDepotCredentials -username "user@yourdomain.com" -password "VMware1!"
    This example sets the credentials that have been configured for the depot.
#>

	Param (
		[Parameter (Mandatory=$true)]
        [string]$username,
		[Parameter (Mandatory=$true)]
        [string]$password
    )

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/system/settings/depot"
    try {

        if ( -not $PsBoundParameters.ContainsKey("username") -and ( -not $PsBoundParameters.ContainsKey("password"))){
			throw "You must enter a username and password"
		}
        $ConfigJson = '{"vmwareAccount": {"username": "'+$username+'","password": "'+$password+'"}}'
        $response = Invoke-RestMethod -Method PUT -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
        $response
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }

}
Export-ModuleMember -Function Set-VCFDepotCredentials

######### End Depot Configuration Operations ##########


######### Start Foundation Component Operations ##########

Function Get-VCFManager {
<#
    .SYNOPSIS
    Get a list of SDDC Managers

    .DESCRIPTION
     Retrieves the details for SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFManager
    This example shows how to retrieve a list of SDDC Managers

    .EXAMPLE
    PS C:\> Get-VCFManager -id 60d6b676-47ae-4286-b4fd-287a888fb2d0
    This example shows how to return the details for a specific SDDC Manager based on the ID
#>

	Param (
		[Parameter (Mandatory=$false)]
        [string]$id
    )

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")

    if ($PsBoundParameters.ContainsKey("id")) {
        $uri = "https://$sddcManager/v1/sddc-managers/$id"
    }
    else{
        $uri = "https://$sddcManager/v1/sddc-managers"
    }
    try {
        if ($PsBoundParameters.ContainsKey("id")) {
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
        else{
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
	        $response.elements
        }
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFManager

Function Get-VCFService {
<#
    .SYNOPSIS
    Gets a list of running VCF Services

    .DESCRIPTION
     Retrieves the list of services running on the connected SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFService
    This example shows how to get the list of services running on the connected SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFService -id 4e416419-fb82-409c-ae37-32a60ba2cf88
    This example shows how to return the details for a specific service running on the connected SDDC Manager based on the ID
#>

	Param (
		[Parameter (Mandatory=$false)]
        [string]$id
    )

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")

    if ($PsBoundParameters.ContainsKey("id")) {
        $uri = "https://$sddcManager/v1/vcf-services/$id"
    }
    else{
        $uri = "https://$sddcManager/v1/vcf-services"
    }
    try {
        if ($PsBoundParameters.ContainsKey("id")) {
	        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
	        $response
        }
        else{
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
		    $response.elements
        }
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFService

Function Get-VCFvCenter {
<#
    .SYNOPSIS
    Gets a list of vCenter Servers

    .DESCRIPTION
    Retrieves a list of vCenter Servers managed by the connected SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFvCenter
    This example shows how to get the list of vCenter Servers managed by the connected SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFvCenter -id d189a789-dbf2-46c0-a2de-107cde9f7d24
    This example shows how to return the details for a specific vCenter Server managed by the connected SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFvCenter | select fqdn
    This example shows how to get the list of vCenter Servers managed by the connected SDDC Manager but only return the fqdn
#>

	Param (
		[Parameter (Mandatory=$false)]
        [string]$id
    )

    # Check the version of SDDC Manager
    CheckVCFVersion

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")

    if ($PsBoundParameters.ContainsKey("id")) {
        $uri = "https://$sddcManager/v1/vcenters/$id"
    }
    else{
        $uri = "https://$sddcManager/v1/vcenters"
    }
    try {
        if ($PsBoundParameters.ContainsKey("id")) {
	        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
	        $response
        }
        else{
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
		    $response.elements
        }
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFvCenter

Function Get-VCFPSC {
    <#
        .SYNOPSIS
        Gets a list of Platform Services Controller (PSC) Servers

        .DESCRIPTION
        Retrieves a list of Platform Services Controllers (PSC)s managed by the connected SDDC Manager

        .EXAMPLE
        PS C:\> Get-VCFPSC
        This example shows how to get the list of the PSC servers managed by the connected SDDC Manager

        .EXAMPLE
        PS C:\> Get-VCFPSC -id 23832dec-e156-4d2d-89bf-37fb0a47aab5
        This example shows how to return the details for a specific PSC server managed by the connected SDDC Manager

        .EXAMPLE
        PS C:\> Get-VCFPSC | select fqdn
        This example shows how to get the list of PSC Servers managed by the connected SDDC Manager but only return the fqdn
    #>

        Param (
            [Parameter (Mandatory=$false)]
            [string]$id
        )

        # Check the version of SDDC Manager
        CheckVCFVersion

        $headers = @{"Accept" = "application/json"}
        $headers.Add("Authorization", "Basic $base64AuthInfo")

        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/pscs/$id"
        }
        else{
            $uri = "https://$sddcManager/v1/pscs"
        }

        try {
            if ($PsBoundParameters.ContainsKey("id")) {
                $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
                $response
            }
            else{
                $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
                $response.elements
            }
        }
        catch {
            # Call the function ResponseExeception which handles execption messages
            ResponseExeception
        }
    }
Export-ModuleMember -Function Get-VCFPSC

Function Get-VCFnsxvManager {
<#
    .SYNOPSIS
    Gets a list of NSX-v Managers

    .DESCRIPTION
     Retrieves a list of NSX-v Managers managed by the connected SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFnsxvManager
    This example shows how to get the list of NSX-v Managers managed by the connected SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFnsxvManager -id d189a789-dbf2-46c0-a2de-107cde9f7d24
    This example shows how to return the details for a specic NSX-v Manager managed by the connected SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFnsxvManager | select fqdn
    This example shows how to get the list of NSX-v Managers managed by the connected SDDC Manager but only return the fqdn
#>

	Param (
		[Parameter (Mandatory=$false)]
        [string]$id
    )

    # Check the version of SDDC Manager
    CheckVCFVersion

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")

    if ($PsBoundParameters.ContainsKey("id")) {
        $uri = "https://$sddcManager/v1/nsx-managers/$id"
    }
    else{
        $uri = "https://$sddcManager/v1/nsx-managers"
    }
    try {
        if ($PsBoundParameters.ContainsKey("id")) {
	        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
	        $response
        }
        else{
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
		    $response.elements
        }
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFnsxvManager

Function Get-VCFnsxtCluster {
<#
    .SYNOPSIS
    Gets a list of NSX-T Clusters

    .DESCRIPTION
    Retrieves a list of NSX-T Clusters managed by the connected SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFnsxtCluster
    This example shows how to get the list of NSX-T Clusters managed by the connected SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFnsxtCluster -id d189a789-dbf2-46c0-a2de-107cde9f7d24
    This example shows how to return the details for a specic NSX-T Clusters managed by the connected SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFnsxtCluster | select fqdn
    This example shows how to get the list of NSX-T Clusters managed by the connected SDDC Manager but only return the fqdn
#>

	Param (
		[Parameter (Mandatory=$false)]
        [string]$id
    )

    # Check the version of SDDC Manager
    CheckVCFVersion

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")

    if ($PsBoundParameters.ContainsKey("id")) {
        $uri = "https://$sddcManager/v1/nsxt-clusters/$id"
    }
    else{
        $uri = "https://$sddcManager/v1/nsxt-clusters"
    }
    try {
        if ($PsBoundParameters.ContainsKey("id")) {
	        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
	        $response
        }
        else{
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
		    $response.elements
        }
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFnsxtCluster

Function Get-VCFvRLI {
<#
    .SYNOPSIS
    Get the existing vRealize Log Insight Details

    .DESCRIPTION
    Gets the complete information about the existing vRealize Log Insight deployment.

    .EXAMPLE
    PS C:\> Get-VCFvRLI
    This example list all details concerning the vRealize Log Insight Cluster

    .EXAMPLE
    PS C:\> Get-VCFvRLI | Select nodes | ConvertTo-Json
    This example lists the node details of the cluster and outputs them in JSON format
#>

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/vrli"
    try {
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFvRLI

######### End Foundation Component Operations ##########

######### Start vRealize Suite Operations ##########
Function Get-VCFvRSLCM {
<#
    .SYNOPSIS
    Get the existing vRealize Suite Lifecycle Manager

    .DESCRIPTION
    Gets the complete information about the existing vRealize Suite Lifecycle Manager.

    .EXAMPLE
    PS C:\> Get-VCFvRSLCM
    This example list all details concerning the vRealize Suite Lifecycle Manager

#>

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/vrslcm"
    try {
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFvRSLCM

Function Get-VCFvRSLCMEnvironment {
<#
    .SYNOPSIS
    Get vRealize Suite Lifecycle Manager environments
    .DESCRIPTION
    Gets all the vRealize products and the corresponding vRealize Suite Lifecycle Manager environments that are managed by VMware Cloud Foundation.

    .EXAMPLE
    PS C:\> Get-VCFvRSLCMEnvironment
    This example list all vRealize Suite Lifecycle Manager environments

#>

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/vrslcm/environments"
    try {
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFvRSLCMEnvironment

Function Get-VCFvROPs {
<#
    .SYNOPSIS
    Get the existing vRealize Operations Manager

    .DESCRIPTION
    Gets the complete information about the existing vRealize Operations Manager.

    .EXAMPLE
    PS C:\> Get-VCFvROPs
    This example list all details concerning the vRealize Operations Manager

    .EXAMPLE
    PS C:\> Get-VCFvROPs -getIntegratedDomains
    Retrieves all the existing workload domains and their connection status with vRealize Operations.

    .EXAMPLE
    PS C:\> Get-VCFvROPs -nodes
    Retrieves all the vRealize Operations Manager nodes.
#>

	param (
			[Parameter (Mandatory=$false)]
				[ValidateNotNullOrEmpty()]
				[switch]$getIntegratedDomains,
            [Parameter (Mandatory=$false)]
				[ValidateNotNullOrEmpty()]
				[switch]$nodes
		)

    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")

	if ($PsBoundParameters.ContainsKey("nodes")) {
        $uri = "https://$sddcmanager/v1/vrops/nodes"
    }
    if ($PsBoundParameters.ContainsKey("getIntegratedDomains")) {
        $uri = "https://$sddcmanager/v1/vrops/domains"
    }
    else{
        $uri = "https://$sddcManager/v1/vropses"
		}
    try {
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response
    }
    catch {
        # Call the function ResponseExeception which handles execption messages
        ResponseExeception
    }
}
Export-ModuleMember -Function Get-VCFvROPs


######### End vRealize Suite Operations ##########

######### Start Federation Management ##########

Function Get-SDDCFederation {
<#
    .SYNOPSIS
    Get information on existing Federation

    .DESCRIPTION
    Gets the complete information about the existing SDDC Federation.

    .EXAMPLE
    PS C:\> Get-Federation
    This example list all details concerning the SDDC Federation

#>
# Get VCF Version
CheckVCFVersion
    
$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/sddc-federation"
try {
    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
    $response
    }
catch {
    # Call the function ResponseExeception which handles execption messages
    ResponseExeception
    }
}
   
Export-ModuleMember -function Get-SDDCFederation

Function Get-SDDCFederationMembers {
<#
    .SYNOPSIS
    A function that gets information on all members in the SDDC Federation

    .DESCRIPTION
    Gets the complete information about the existing SDDC Federation members.

    .EXAMPLE
    PS C:\> Get-FederationMembers
    This example lists all details concerning the SDDC Federation members.

#>
# Get VCF Version
CheckVCFVersion
    
$headers = @{"Accept" = "application/json"}
$headers.Add("Authorization", "Basic $base64AuthInfo")
$uri = "https://$sddcManager/v1/sddc-federation/members"
try {
    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
    if ($response.federationName -eq $null) {
        Throw "Failed to get members, no Federation found."
    }
    else { 
        $response
    }
}
catch {
    # Call the function ResponseExeception which handles execption messages
    ResponseExeception
    }
}   
Export-ModuleMember -function Get-SDDCFederationMembers

######### Start Federation Management ##########

Function ResponseExeception {
    #Get response from the exception
    $response = $_.exception.response
    if ($response) {
        Write-Host ""
        Write-Host "Oops something went wrong, please check your API call" -ForegroundColor Red -BackgroundColor Black
        Write-Host ""
        $responseStream = $_.exception.response.GetResponseStream()
        $reader = New-Object system.io.streamreader($responseStream)
        $responseBody = $reader.readtoend()
        $ErrorString = "Exception occured calling invoke-restmethod. $($response.StatusCode.value__) : $($response.StatusDescription) : Response Body: $($responseBody)"
        throw $ErrorString
        Write-Host ""
    }
    else {
        throw $_
    }
}

Function CheckVCFVersion {
    [string]$getvcfVersion = Get-VCFManager | Select version
    $vcfVersion = $getvcfVersion.substring(10,3)
    if ($vcfVersion -lt "3.9") {
        Write-Host ""
        Write-Host "This cmdlet is only supported in VCF 3.9 or later" -ForegroundColor Magenta
        Write-Host ""
        break
    }
}
