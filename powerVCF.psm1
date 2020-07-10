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

  Param (
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

  if ( -not $PsBoundParameters.ContainsKey("username") -or ( -not $PsBoundParameters.ContainsKey("username"))) {
    # Request Credentials
    $creds = Get-Credential
    $username = $creds.UserName.ToString()
    $password = $creds.GetNetworkCredential().password
  }

  $Global:sddcManager = $fqdn
  $Global:base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password))) # Create Basic Authentication Encoded Credentials

  # Validate credentials by executing an API call
  $headers = @{"Accept" = "application/json"}
  $headers.Add("Authorization", "Basic $base64AuthInfo")
  $uri = "https://$sddcManager/v1/sddc-managers"

  Try {
    # Checking against the sddc-managers API
    # PS Core has -SkipCertificateCheck implemented, PowerShell 5.x does not
    if ($PSEdition -eq 'Core') {
      $response = Invoke-WebRequest -Method GET -Uri $uri -Headers $headers -SkipCertificateCheck
    }
    else {
      $response = Invoke-WebRequest -Method GET -Uri $uri -Headers $headers
    }
    if ($response.StatusCode -eq 200) {
      Write-Host " Successfully connected to SDDC Manager:" $sddcManager -ForegroundColor Yellow
    }
  }
  Catch {
    Write-Host "" $_.Exception.Message -ForegroundColor Red
    Write-Host " Credentials provided did not return a valid API response (expected 200). Retry Connect-VCFManager cmdlet" -ForegroundColor Red
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
  - UNASSIGNED_UNUSEABLE - Hosts that are currently not assigned to any domain and can be used for other domain tasks after completion of cleanup operation

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
	PS C:\> Get-VCFHost -fqdn sfo01m01esx01.sfo.rainpole.local
  This example shows how to get a host by fqdn
#>

  Param (
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

  createHeader # Calls Function createHeader to set Accept & Authorization
  Try {
    if ( -not $PsBoundParameters.ContainsKey("status") -and ( -not $PsBoundParameters.ContainsKey("id")) -and ( -not $PsBoundParameters.ContainsKey("fqdn"))) {
      $uri = "https://$sddcManager/v1/hosts"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
    if ($PsBoundParameters.ContainsKey("fqdn")) {
      $uri = "https://$sddcManager/v1/hosts"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements | Where-Object {$_.fqdn -eq $fqdn}
    }
    if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/hosts/$id"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
    if ($PsBoundParameters.ContainsKey("status")) {
      $uri = "https://$sddcManager/v1/hosts?status=$status"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$json
  )

  if (!(Test-Path $json)) {
    Throw "JSON File Not Found"
  }
  else {
    # Reads the commissionHostsJSON json file contents into the $ConfigJson variable
    $ConfigJson = (Get-Content -Raw $json)
    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")

    # Validate the provided JSON input specification file
    $response = Validate-CommissionHostSpec -json $ConfigJson
    # Get the task id from the validation function
    $taskId = $response.id
    # Keep checking until executionStatus is not IN_PROGRESS
    Do {
      $uri = "https://$sddcManager/v1/hosts/validations/$taskId"
      $response = Invoke-RestMethod -Method GET -URI $uri -Headers $headers -ContentType application/json
    }
    While ($response.executionStatus -eq "IN_PROGRESS")
    # Submit the commissiong job only if the JSON validation task finished with executionStatus=COMPLETED & resultStatus=SUCCEEDED
    if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
      Try {
        Write-Host ""
        Write-Host "Task validation completed successfully, invoking host(s) commissioning on SDDC Manager" -ForegroundColor Green
        $uri = "https://$sddcManager/v1/hosts/"
        $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
        Return $response
        Write-Host ""
      }
      Catch {
        ResponseException # Call Function ResponseException to get error response from the exception
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

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$json
  )

  if (!(Test-Path $json)) {
    Throw "JSON File Not Found"
  }
  else {
    # Reads the json file contents into the $ConfigJson variable
    $ConfigJson = (Get-Content -Raw $json)
    $headers = @{"Accept" = "application/json"}
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$sddcManager/v1/hosts"
    Try {
      $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
			$response
    }
    Catch {
      ResponseException # Call Function ResponseException to get error response from the exception
    }
  }
}
Export-ModuleMember -Function Decommission-VCFHost

Function Reset-VCFHost {
<#
  .SYNOPSIS
  Performs an ESXi host cleanup using the command line SoS utility

  .DESCRIPTION
  Performs a host cleanup using SoS option --cleanup-host. Valid options for the -dirtyHost parameter are: ALL, <MGMT ESXi IP>
  Please note:The SoS utility on VCF 3.9 is unable to perform networking host cleanup when the host belongs to an NSX-T cluster.
  This issue has been resolved on VCF 3.9.1

  .EXAMPLE
  Reset-VCFHost -privilegedUsername super-vcf@vsphere.local -privilegedPassword "VMware1!" -sddcManagerRootPassword "VMware1!"-dirtyHost 192.168.210.53
  This command will perform SoS host cleanup for host 192.168.210.53

  .EXAMPLE
  Reset-VCFHost -privilegedUsername super-vcf@vsphere.local -privilegedPassword "VMware1!" -sddcManagerRootPassword "VMware1!" -dirtyHost all
  This command will perform SoS host cleanup for all hosts in need of cleanup in the SDDC Manager database.
#>

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [String] $privilegedUsername,
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [String] $privilegedPassword,
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [String] $sddcManagerRootPassword,
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$dirtyHost
  )

  # Get the full list of PSC credentials
  $pscCreds = Get-VCFCredential -privilegedUsername $privilegedUsername -privilegedPassword $privilegedPassword -resourceType PSC
  # From PSC credentials extract the SSO username and password
  $ssoCreds = $pscCreds | Where-Object {$_.credentialType -eq "SSO"}
  # Get the list of all VCENTER credentials
  $vcCreds = Get-VCFCredential $privilegedUsername -privilegedPassword $privilegedPassword -resourceType VCENTER
  # Find out which VC is the MGMT. This is use to extract the MGMT VC FQDN ($mgmtVC.resourceName)
  $mgmtVC = $vcCreds.resource | Where-Object {$_.domainName -eq "MGMT"}
  # Connect to the Management vCenter without displaying the connection
  Connect-VIServer -Server $mgmtVC.resourceName -User $ssoCreds.username -Password $ssoCreds.password | Out-Null
  # Get the vm object for sddc-manager
  $sddcManagerVM = Get-VM -Name "sddc-manager"
  # The SoS help says to use ALL not sure if it's case sensitive but I'm converting upper case
  if ($dirtyHost -eq "all") { $dirtyHost = "ALL" }
    # Build the cmd to run and auto confirm
    $sshCommand = "echo Y | /opt/vmware/sddc-support/sos --cleanup-host " + $dirtyHost
    Write-Host ""
    Write-Host "Executing clean up for host(s): $dirtyHost - This might take a while, please wait..."
    Write-Host ""
    Try {
      $vmScript = Invoke-VMScript -VM $sddcManagerVM -ScriptText $sshCommand -GuestUser root -GuestPassword $sddcManagerRootPassword
      $vmScript
    }
    Catch {
      ResponseException # Call Function ResponseException to get error response from the exception
    }
}
Export-ModuleMember -Function Reset-VCFHost

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

  .EXAMPLE
  PS C:\> Get-VCFWorkloadDomain -id 8423f92e-e4b9-46e7-92f7-befce4755ba2 -endpoints | ConvertTo-Json
  This example shows how to get endpoints of a Workload Domain by its id and displays the output in Json format
#>

	Param (
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$name,
		[Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$id,
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [switch]$endpoints
  )

  createHeader # Calls Function createHeader to set Accept & Authorization
  Try {
    if ($PsBoundParameters.ContainsKey("name")) {
      $uri = "https://$sddcManager/v1/domains"
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements | Where-Object {$_.name -eq $name}
		}
		if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/domains/$id"
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response
		}
    if ( -not $PsBoundParameters.ContainsKey("name") -and ( -not $PsBoundParameters.ContainsKey("id"))) {
      $uri = "https://$sddcManager/v1/domains"
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements
		}
    if ( $PsBoundParameters.ContainsKey("id") -and ( $PsBoundParameters.ContainsKey("endpoints"))) {
      $uri = "https://$sddcManager/v1/domains/$id/endpoints"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
  		$response.elements
    }
	}
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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

	Param (
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
    createHeader # Calls Function createHeader to set Accept & Authorization
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
        Return $response
        Write-Host ""
        Return $response
        Write-Host ""
      }
      Catch {
        ResponseException # Call Function ResponseException to get error response from the exception
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

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$id
  )

  createHeader # Calls Function createHeader to set Accept & Authorization
  Try {
    $uri = "https://$sddcManager/v1/domains/$id"
    $body = '{"markForDeletion": true}'
    $response = Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $body
    # This API does not return a response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$id
  )

  createHeader # Calls Function createHeader to set Accept & Authorization
  Try {
    $uri = "https://$sddcManager/v1/domains/$id"
    $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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

  Param (
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$name,
		[Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$id
  )

  createHeader # Calls Function createHeader to set Accept & Authorization
  Try {
    if ( -not $PsBoundParameters.ContainsKey("name") -and ( -not $PsBoundParameters.ContainsKey("id"))) {
      $uri = "https://$sddcManager/v1/clusters"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
    if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/clusters/$id"
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
		}
    if ($PsBoundParameters.ContainsKey("name")) {
      $uri = "https://$sddcManager/v1/clusters"
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements | Where-Object {$_.name -eq $name}
		}
	}
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$json
  )

  if (!(Test-Path $json)) {
    Throw "JSON File Not Found"
  }
  else {
    $ConfigJson = (Get-Content $json) # Read the json file contents into the $ConfigJson variable
    createHeader # Calls Function createHeader to set Accept & Authorization
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
      Catch {
        ResponseException # Call Function ResponseException to get error response from the exception
      }
      else {
        Write-Host ""
        Write-Host "The validation task commpleted the run with the following problems:" -ForegroundColor Yellow
        Write-Host $response.validationChecks.errorResponse.message  -ForegroundColor Yellow
        Write-Host ""
      }
    }
  }
}
Export-ModuleMember -Function New-VCFCluster

Function Set-VCFCluster {
<#
  .SYNOPSIS
  Connects to the specified SDDC Manager & expands or compacts a cluster.

  .DESCRIPTION
	The Set-VCFCluster cmdlet connects to the specified SDDC Manager & expands
  or compacts a cluster by adding or removing a host(s). A cluster can also
  be marked for deletion

  .EXAMPLE
	PS C:\> Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 -json .\Cluster\clusterExpansionSpec.json
  This example shows how to expand a cluster by adding a host(s)

	.EXAMPLE
	PS C:\> Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 -json .\Cluster\clusterCompactionSpec.json
  This example shows how to compact a cluster by removing a host(s)

	.EXAMPLE
	PS C:\> Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 -markForDeletion
  This example shows how to mark a cluster for deletion
#>

  Param (
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
      $ConfigJson = (Get-Content $json) # Read the json file contents into the $ConfigJson variable
    }
  }
  createHeader # Calls Function createHeader to set Accept & Authorization
  Try {
    if ( -not $PsBoundParameters.ContainsKey("json") -and ( -not $PsBoundParameters.ContainsKey("markForDeletion"))) {
      Throw "You must include either -json or -markForDeletion"
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
					Return $response
					Write-Host ""
        }
				Catch {
          ResponseException # Call Function ResponseException to get error response from the exception
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
	Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$id
  )

  createHeader # Calls Function createHeader to set Accept & Authorization
  Try {
    $uri = "https://$sddcManager/v1/clusters/$id"
    $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
    #TODO: Parse the response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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

  Param (
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$name,
		[Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$id
  )

  createHeader # Calls Function createHeader to set Accept & Authorization
  Try {
    if ( -not $PsBoundParameters.ContainsKey("name") -and ( -not $PsBoundParameters.ContainsKey("id"))) {
      $uri = "https://$sddcManager/v1/network-pools"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
    if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/network-pools/$id"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
    if ($PsBoundParameters.ContainsKey("name")) {
      $uri = "https://$sddcManager/v1/network-pools"
			$response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
			$response.elements | Where-Object {$_.name -eq $name}
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$json
  )

  if (!(Test-Path $json)) {
    Throw "JSON File Not Found"
  }
  else {
    $ConfigJson = (Get-Content $json) # Read the json file contents into the $ConfigJson variable
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/network-pools"
    Try {
      $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
			# This API does not return a response body. Sending GET to validate the Network Pool creation was successful
			$validate = $ConfigJson | ConvertFrom-Json
			$poolName = $validate.name
			Get-VCFNetworkPool -name $poolName
    }
    Catch {
      ResponseException # Call Function ResponseException to get error response from the exception
    }
  }
}
Export-ModuleMember -Function New-VCFNetworkPool

Function Remove-VCFNetworkPool {
<#
  .SYNOPSIS
  Connects to the specified SDDC Manager & deletes a Network Pool

  .DESCRIPTION
  The Remove-VCFNetworkPool cmdlet connects to the specified SDDC Manager & deletes a Network Pool

  .EXAMPLE
  PS C:\> Remove-VCFNetworkPool -id 7ee7c7d2-5251-4bc9-9f91-4ee8d911511f
  This example shows how to get a Network Pool by id
#>

	Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$id
  )

  createHeader # Calls Function createHeader to set Accept & Authorization
  Try {
    $uri = "https://$sddcManager/v1/network-pools/$id"
    $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
    # This API does not return a response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$id,
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$networkid
  )

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/network-pools/$id/networks"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
    if ($PsBoundParameters.ContainsKey("id") -and ($PsBoundParameters.ContainsKey("networkid"))) {
      $uri = "https://$sddcManager/v1/network-pools/$id/networks/$networkid"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFNetworkIPPool

Function Add-VCFNetworkIPPool {
<#
  .SYNOPSIS
  Add an IP Pool to the Network of a Network Pool

  .DESCRIPTION
  The Add-VCFNetworkIPPool cmdlet connects to the specified SDDC Manager and adds a new IP Pool
  to an existing Network within a Network Pool.

  .EXAMPLE
  PS C:\> Add-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkid c2197368-5b7c-4003-80e5-ff9d3caef795 -ipStart 192.168.110.61 -ipEnd 192.168.110.64
  This example shows how create a new IP Pool on the existing network for a given Network Pool
#>

  Param (
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

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/network-pools/$id/networks/$networkid/ip-pools"
    $body = '{"end": "'+$ipEnd+'","start": "'+$ipStart+'"}'
    $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $body
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Add-VCFNetworkIPPool

Function Remove-VCFNetworkIPPool {
<#
  .SYNOPSIS
  Remove an IP Pool from the Network of a Network Pool

  .DESCRIPTION
  The Remove-VCFNetworkIPPool cmdlet connects to the specified SDDC Manager and removes an IP Pool assigned to an
  existing Network within a Network Pool.

  .EXAMPLE
  PS C:\> Remove-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkid c2197368-5b7c-4003-80e5-ff9d3caef795 -ipStart 192.168.110.61 -ipEnd 192.168.110.64
  This example shows how remove an IP Pool on the existing network for a given Network Pool
#>

  Param (
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

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/network-pools/$id/networks/$networkid/ip-pools"
    $body = '{"end": "'+$ipEnd+'","start": "'+$ipStart+'"}'
    $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers -ContentType application/json -body $body
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Remove-VCFNetworkIPPool

######### End Network Pool Operations ##########


######### Start License Key Operations ##########

Function Get-VCFLicenseKey {
<#
  .SYNOPSIS
  Connects to the specified SDDC Manager and retrieves a list of License keys

  .DESCRIPTION
  The Get-VCFLicenseKey cmdlet connects to the specified SDDC Manager and retrieves a list of License keys

  .EXAMPLE
  PS C:\> Get-VCFLicenseKey
  This example shows how to get a list of all License keys

  .EXAMPLE
  PS C:\> Get-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
  This example shows how to get a specified License key

  .EXAMPLE
  PS C:\> Get-VCFLicenseKey -productType "VCENTER,VSAN"
  This example shows how to get a License Key by product type
	Supported Product Types: SDDC_MANAGER, VCENTER, NSXV, VSAN, ESXI, VRA, VROPS, NSXT

	.EXAMPLE
  PS C:\> Get-VCFLicenseKey -status EXPIRED
  This example shows how to get a License by status
	Supported Status Types: EXPIRED, ACTIVE, NEVER_EXPIRES
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

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
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
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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
    $ConfigJson = (Get-Content $json) # Read the createNetworkPool json file contents into the $ConfigJson variable
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/license-keys"
    Try {
      $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
			# This API does not return a response body. Sending GET to validate the License Key creation was successful
			$license = $ConfigJson | ConvertFrom-Json
			$licenseKey = $license.key
			Get-VCFLicenseKey -key $licenseKey
    }
    Catch {
      ResponseException # Call Function ResponseException to get error response from the exception
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

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/license-keys/$key"
    $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
    # This API does not return a response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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

  .EXAMPLE
	PS C:\> Get-VCFTask -status SUCCESSFUL
  This example shows how to get all tasks with a status of SUCCESSFUL
#>

  Param (
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$id,
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$status
  )

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    if ( -not $PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/tasks/"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
    if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/tasks/$id"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
    if ($PsBoundParameters.ContainsKey("status")) {
      $uri = "https://$sddcManager/v1/tasks/$id"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements | Where-Object {$_.status -eq $status}
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$id
  )

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/tasks/$id"
    $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Retry-VCFTask

#### End Task Operations #####

######### Start Credential Task Operations ##########

Function Get-VCFCredentialTask {
<#
  .SYNOPSIS
  Connects to the specified SDDC Manager and retrieves a list of credential tasks in reverse chronological order.

  .DESCRIPTION
  The Get-VCFCredential cmdlet connects to the specified SDDC Manager and retrieves a list of
  credential tasks in reverse chronological order.

  .EXAMPLE
  PS C:\> Get-VCFCredentialTask
  This example shows how to get a list of all credentials tasks

  .EXAMPLE
  PS C:\> Get-VCFCredentialTask -id 7534d35d-98fb-43de-bcf7-2776beb6fcc3
  This example shows how to get the credential tasks for a specific task id

  .EXAMPLE
  PS C:\> Get-VCFCredentialTask -id 7534d35d-98fb-43de-bcf7-2776beb6fcc3 -resourceCredentials
  This example shows how to get resource credentials for a credential task id
#>

	Param (
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$id,
		[Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [switch]$resourceCredentials
  )

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    if ( -not $PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/credentials/tasks"
	    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
	    $response
    }
    if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/credentials/tasks/$id"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
    if ($PsBoundParameters.ContainsKey("id") -and ($PsBoundParameters.ContainsKey("resourceCredentials"))) {
      $uri = "https://$sddcManager/v1/credentials/tasks/$id/resource-credentials"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFCredentialTask

######### End Credential Task Operations ##########


######### Start Credential Operations ##########

Function Get-VCFCredential {
<#
    .SYNOPSIS
    Connects to the specified SDDC Manager and retrieves a list of credentials.
    Supported resource types are: PSC, VCENTER, ESXI, NSX_MANAGER, NSX_CONTROLLER, BACKUP
    Please note: if you are requesting credentials by resource type then the resource name parameter (if
    passed) will be ignored (they are mutually exclusive)

    .DESCRIPTION
    The Get-VCFCredential cmdlet connects to the specified SDDC Manager and retrieves a list of credentials.
    A privileged user account is required.

    .EXAMPLE
    PS C:\> Get-VCFCredential -privilegedUsername sec-admin@rainpole.local -privilegedPassword VMw@re1!
    This example shows how to get a list of credentials

    .EXAMPLE
    PS C:\> Get-VCFCredential -privilegedUsername sec-admin@rainpole.local -privilegedPassword VMw@re1! -resourceType PSC
    This example shows how to get a list of PSC credentials

    .EXAMPLE
    PS C:\> Get-VCFCredential -privilegedUsername sec-admin@rainpole.local -privilegedPassword VMw@re1! -resourceName sfo01m01esx01.sfo.rainpole.local
    This example shows how to get the credential for a specific resourceName (FQDN)
#>

    Param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$privilegedUsername,
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$privilegedPassword,
        [Parameter (Mandatory=$false)]
            [ValidateNotNullOrEmpty()]
            [string]$resourceName,
        [Parameter (Mandatory=$false)]
            [ValidateSet("PSC", "VCENTER", "ESXI", "NSX_MANAGER", "NSX_CONTROLLER", "BACKUP")]
            [ValidateNotNullOrEmpty()]
            [string]$resourceType
    )

    Try {
        createHeader # Calls Function createHeader to set Accept & Authorization
        $headers.Add("privileged-username", "$privilegedUsername")
        $headers.Add("privileged-password", "$privilegedPassword")
        if ($PsBoundParameters.ContainsKey("resourceName")) {
            $uri = "https://$sddcManager/v1/credentials?resourceName=$resourceName"
        }
        else {
            $uri = "https://$sddcManager/v1/credentials"
        }
        # if requesting credential by type then name is ignored (mutually exclusive)
        if ($PsBoundParameters.ContainsKey("resourceType") ) {
            $uri = "https://$sddcManager/v1/credentials?resourceType=$resourceType"
        }
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.elements
    }
    Catch {
        ResponseException # Call Function ResponseException to get error response from the exception
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

  Param (
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
      $ConfigJson = (Get-Content $json) # Read the json file contents into the $ConfigJson variable
    }
  }
  createHeader # Calls Function createHeader to set Accept & Authorization
  $uri = "https://$sddcManager/v1/credentials"
  Try {
    $response = Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Set-VCFCredential

######### End Credential Operations ##########

######### Start Credential Failed Task Cancel Operation ##########

Function Cancel-VCFCredentialTask {

<#
  .SYNOPSIS
  Connects to the specified SDDC Manager and cancels a failed update or rotate passwords task.

  .DESCRIPTION
	The Cancel-VCFCredentialTask cmdlet connects to the specified SDDC Manager and cancles a failed update or rotate passwords task.

  .EXAMPLE
	PS C:\> Cancel-VCFCredentialTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d
  This example shows how to cancel a failed rotate or update password task.
#>

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$id
  )

  if ($PsBoundParameters.ContainsKey("id")) {
    $uri = "https://$sddcManager/v1/credentials/tasks/$id"
  }
  else {
    Throw "task id to be cancelled is not provided"
  }
  createHeader # Calls Function createHeader to set Accept & Authorization
  Try {
    $response = Invoke-RestMethod -Method DELETE -URI $uri -ContentType application/json -headers $headers
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Cancel-VCFCredentialTask

######### End Credential Failed Task Cancel Operation ##########

######### Start Retry Credential Failed Task Rotate/Update operation ##########

Function Retry-VCFCredentialTask {
<#
  .SYNOPSIS
  Connects to the specified SDDC Manager and retry a failed rotate/update passwords task

  .DESCRIPTION
	The Retry-VCFCredentialTask cmdlet connects to the specified SDDC Manager and retry a failed rotate/update password task

  .EXAMPLE
	PS C:\> Retry-VCFCredentialTask -privilegedUsername sec-admin@rainpole.local -privilegedPassword VMw@reil! -id 4d661acc-2be6-491d-9256-ba3c78020e5d -json .\Credential\updateCredentialSpec.json
  This example shows how to update passwords of a resource type using a json spec

  .EXAMPLE
	PS C:\> Retry-VCFCredentialTask  -privilegedUsername sec-admin@rainpole.local -privilegedPassword VMw@reil! -id 4d661acc-2be6-491d-9256-ba3c78020e5d -json .\Credential\rotateCredentialSpec.json
  This example shows how to rotate passwords of a resource type using a json spec
#>

	Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$privilegedUsername,
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$privilegedPassword,
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$id,
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$json
  )

  if ($PsBoundParameters.ContainsKey("json")) {
    if (!(Test-Path $json)) {
      Throw "JSON File Not Found"
    }
    else {
      $ConfigJson = (Get-Content $json) # Read the json file contents into the $ConfigJson variable
    }
  }
  if ($PsBoundParameters.ContainsKey("id")) {
    $uri = "https://$sddcManager/v1/credentials/tasks/$id"
  }
  else {
    Throw "task id not provided"
  }
  createHeader # Calls Function createHeader to set Accept & Authorization
  $headers.Add("privileged-username", "$privilegedUsername")
  $headers.Add("privileged-password", "$privilegedPassword")
  Try {
    $response = Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Retry-VCFCredentialTask

######### End Retry Credential Failed Task Rotate/Update operation ##########


######## Start Validation Functions ########

Function Validate-CommissionHostSpec {

	Param (
    [Parameter (Mandatory=$true)]
    [object]$json
  )

  createHeader # Calls Function createHeader to set Accept & Authorization
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
  Try {
    $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $body
    Return $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}

Function Validate-WorkloadDomainSpec {

	Param (
    [Parameter (Mandatory=$true)]
      [object]$json
    )

  createHeader # Calls Function createHeader to set Accept & Authorization
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
  Try {
    $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $body
	   return $response
	}
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}

Function Validate-VCFClusterSpec {

	Param (
        [Parameter (Mandatory=$true)]
        [object]$json
    )

  createHeader # Calls Function createHeader to set Accept & Authorization
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
  Try {
    $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $body
	}
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
  Return $response
}

Function Validate-VCFUpdateClusterSpec {

	Param (
    [Parameter (Mandatory=$true)]
      [object]$clusterid,
		[Parameter (Mandatory=$true)]
      [object]$json
  )

  createHeader # Calls Function createHeader to set Accept & Authorization
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
  Try {
    $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $body
	}
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
  Return $response
}

######## End Validation Functions ########


######### Start CEIP Operations ##########

Function Get-VCFCeip {
<#
  .SYNOPSIS
  Retrieves the current setting for CEIP of the connected SDDC Manager

  .DESCRIPTION
  The Get-VCFCeip cmdlet retrieves the current setting for Customer Experience Improvement Program (CEIP) of the connected SDDC Manager

  .EXAMPLE
	PS C:\> Get-VCFCeip
  This example shows how to get the current setting of CEIP
#>

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/system/ceip"
    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFCeip

Function Set-VCFCeip {
<#
  .SYNOPSIS
  Sets the CEIP status (Enabled/Disabled) of the connected SDDC Manager and components managed

  .DESCRIPTION
  The Set-VCFCeip cmdlet configures the status (Enabled/Disabled) for Customer Experience Improvement Program (CEIP) of the connected SDDC Manager
  and the components managed (vCenter Server, vSAN and NSX Manager)

  .EXAMPLE
  PS C:\> Set-VCFCeip -ceipSetting DISABLE
  This example shows how to DISABLE CEIP for SDDC Manager, vCenter Server, vSAN and NSX Manager

  .EXAMPLE
  PS C:\> Set-VCFCeip -ceipSetting ENABLE
  This example shows how to ENABLE CEIP for SDDC Manager, vCenter Server, vSAN and NSX Manager
#>

	Param (
		[Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$ceipSetting
  )

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/system/ceip"
    if ( -not $PsBoundParameters.ContainsKey("ceipsetting")) {
      Throw "You must define ENABLE or DISABLE as an input"
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
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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
    The Get-VCFBackupConfiguration cmdlet retrieves the current backup configuration details

    .EXAMPLE
    PS C:\> Get-VCFBackupConfiguration
    This example retrieves the backup configuration

    .EXAMPLE
    PS C:\> Get-VCFBackupConfiguration | ConvertTo-Json
    This example retrieves the backup configuration and outputs it in json format
#>

    Try {
        createHeader # Calls Function createHeader to set Accept & Authorization
        $uri = "https://$sddcManager/v1/system/backup-configuration"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.backupLocations
    }
    Catch {
        ResponseException # Call Function ResponseException to get error response from the exception
    }
}
Export-ModuleMember -Function Get-VCFBackupConfiguration

Function Set-VCFBackupConfiguration {
<#
    .SYNOPSIS
    Configure backup settings for NSX and SDDC manager

    .DESCRIPTION
    The Set-VCFBackupConfiguration cmdlet configures or updates the backup configuration details for
    backing up NSX and SDDC Manager

    .EXAMPLE
    PS C:\> Set-VCFBackupConfiguration -privilegedUsername svc-mgr-vsphere@vsphere.local -privilegedPassword
    VMw@re1! -json backupConfiguration.json
    This example shows how to update the backup configuration
#>

    Param (
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
            $ConfigJson = (Get-Content -Raw $json)
        }
    }
    Try {
        createHeader # Calls Function createHeader to set Accept & Authorization
        $headers.Add("privileged-username", "$privilegedUsername")
        $headers.Add("privileged-password", "$privilegedPassword")
        $uri = "https://$sddcManager/v1/system/backup-configuration"
        $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
        $response
    }
    Catch {
        ResponseException # Call Function ResponseException to get error response from the exception
    }
}
Export-ModuleMember -Function Set-VCFBackupConfiguration

Function Start-VCFBackup {
<#
  .SYNOPSIS
  Start the SDDC Manager backup

  .DESCRIPTION
  The Start-VCFBackup cmdlet invokes the SDDC Manager backup task

  .EXAMPLE
	PS C:\> Start-VCFBackup
  This example shows how to start the SDDC Manager backup
#>

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    # this body is fixed for SDDC Manager backups. not worth having it stored on file
    $ConfigJson = '
      {
        "elements" : [{
          "resourceType" : "SDDC_MANAGER"
          }]
        }
      '
    $uri = "https://$sddcManager/v1/backups/tasks"
    $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType "application/json" -body $ConfigJson
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Start-VCFBackup

######### End Backup Configuration Operations ##########


######### Start Bundle Operations ##########

Function Get-VCFBundle {
<#
  .SYNOPSIS
  Get all Bundles available to SDDC Manager

  .DESCRIPTION
  The Get-VCFBundle cmdlet gets all bundles available to the SDDC Manager instance.
  i.e. Manually uploaded bundles and bundles available via depot access.

  .EXAMPLE
  PS C:\> Get-VCFBundle
  This example gets the list of bundles and all their details

	.EXAMPLE
  PS C:\> Get-VCFBundle | Select version,downloadStatus,id
  This example gets the list of bundles and filters on the version, download status and the id only

	.EXAMPLE
  PS C:\> Get-VCFBundle -id 7ef354ab-13a6-4e39-9561-10d2c4de89db
  This example gets the details of a specific bundle by its id

  .EXAMPLE
  PS C:\> Get-VCFBundle | Where {$_.description -Match "vRealize"}
  This example lists all bundles that match vRealize in the description field
#>

  Param (
    [Parameter (Mandatory=$false)]
      [string]$id
  )

  # Check the version of SDDC Manager
  CheckVCFVersion
  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/bundles/$id"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
    else {
      $uri = "https://$sddcManager/v1/bundles"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFBundle

Function Request-VCFBundle {
<#
  .SYNOPSIS
  Start download of bundle from depot

  .DESCRIPTION
  The Request-VCFBundle cmdlet starts an immediate download of a bundle from the depot.
  Only one download can be triggered for a bundle.

  .EXAMPLE
  PS C:\> Request-VCFBundle -id 7ef354ab-13a6-4e39-9561-10d2c4de89db
  This example requests the immediate download of a bundle based on its id
#>

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$id
  )

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/bundles/$id"
    $body = '{"bundleDownloadSpec": {"downloadNow": true}}'
    $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers	-ContentType application/json -body $body
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Request-VCFBundle

######### End Bundle Operations ##########

######### Start Get Upgradable Operations ##########

Function Get-VCFUpgradables {
<#
  .SYNOPSIS
  Retrieves list of upgradables in the system

  .DESCRIPTION
  Retrieves list of upgradables in the system

  .EXAMPLE
    PS C:\> Get-VCFUpgradables
  This example shows how to retrieve the list of upgradables in the system
#>

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/system/upgradables"
    $response = Invoke-RestMethod -Method GET -URI $uri -ContentType application/json -headers $headers
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFUpgradables

######### End Get Upgradable Operations ##########
######### Start Upload Bundle Operations ##########

Function Start-UploadVCFBundle {
<#
  .SYNOPSIS
  Starts upload of bundle to SDDC Manager

  .DESCRIPTION
  The Start-UploadVCFBundle cmdlet starts upload of bundle(s) to SDDC Manager

  .EXAMPLE
  PS C:\> Start-UploadVCFBundle -json .\Bundle\bundlespec.json
  This example invokes the upload of a bundle onto SDDC Manager
#>

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$json
  )

  $headers = @{"Accept" = "application/json"}
  $headers.Add("Authorization", "Basic $base64AuthInfo")

  if ($PsBoundParameters.ContainsKey("json")) {
      if (!(Test-Path $json)) {
           Throw "JSON File Not Found"
      }
      else {
           # Read the json file contents into the $ConfigJson variable
           $ConfigJson = (Get-Content $json)
      }
  }

  $uri = "https://$sddcManager/v1/bundles"
  try {
      $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers	-ContentType application/json -body $ConfigJson
  }
  catch {
    # Call the function ResponseException which handles execption messages
    ResponseException
  }
}
Export-ModuleMember -Function Start-UploadVCFBundle

######### End Upload Bundle Operations ##########



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

  .EXAMPLE
  PS C:\> Get-VCFCertificateAuthConfiguration | ConvertTo-Json
  This example shows how to get the certificate authority configuration from the connected SDDC Manager
  and output to Json format
#>

  # Check the version of SDDC Manager
  CheckVCFVersion

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/certificate-authorities"
    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
    $response.elements
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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
      [ValidateNotNullOrEmpty()]
      [string]$serverUrl,
		[Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$username,
		[Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$password,
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$templateName
  )

  # Check the version of SDDC Manager
  CheckVCFVersion

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/certificate-authorities"
    if ( -not $PsBoundParameters.ContainsKey("serverUrl") -and ( -not $PsBoundParameters.ContainsKey("username") -and ( -not $PsBoundParameters.ContainsKey("password") -and ( -not $PsBoundParameters.ContainsKey("templateName"))))){
      Throw "You must enter the mandatory values"
		}
    $ConfigJson = '{"microsoftCertificateAuthoritySpec": {"secret": "'+$password+'","serverUrl": "'+$serverUrl+'","username": "'+$username+'","templateName": "'+$templateName+'"}}'
    $response = Invoke-RestMethod -Method PUT -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Set-VCFMicrosoftCA

Function Get-VCFCertificateCSR {
<#
    .SYNOPSIS
    Get available CSR(s)

    .DESCRIPTION
    The Get-VCFCertificateCSR cmdlet gets the available CSRs that have been created on SDDC Manager

    .EXAMPLE
    PS C:\> Get-VCFCertificateCSRs -domainName MGMT
    This example gets a list of CSRs and displays the output

    .EXAMPLE
    PS C:\> Get-VCFCertificateCSRs -domainName MGMT | ConvertTo-Json
    This example gets a list of CSRs and displays them in JSON format
#>

    Param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$domainName
    )

    Try {
        createHeader # Calls Function createHeader to set Accept & Authorization
        $uri = "https://$sddcManager/v1/domains/$domainName/csrs"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.elements
    }
    Catch {
        ResponseException # Call Function ResponseException to get error response from the exception
    }
}
Export-ModuleMember -Function Get-VCFCertificateCSR

Function Request-VCFCertificateCSR {
<#
  .SYNOPSIS
  Generate CSR(s)

  .DESCRIPTION
  The Request-VCFCertificateCSR generates CSR(s) for the selected resource(s) in the domain
  - Resource Types (SDDC_MANAGER, PSC, VCENTER, NSX_MANAGER, NSXT_MANAGER, VRA,
    VRLI, VROPS, VRSLCM, VXRAIL_MANAGER

  .EXAMPLE
  PS C:\> Request-VCFCertificateCSR -domainName MGMT -json .\requestCsrSpec.json
  This example requests the generation of the CSR based on the entries within the requestCsrSpec.json file for resources within
    the domain called MGMT
#>

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$json,
		[Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$domainName
  )

  if (!(Test-Path $json)) {
    Throw "JSON File Not Found"
  }
  else {
    $ConfigJson = (Get-Content -Raw $json) # Reads the requestCsrSpec json file contents into the $ConfigJson variable
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/domains/$domainName/csrs"
    Try {
      $response = Invoke-RestMethod -Method PUT -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
      $response
    }
    Catch {
      ResponseException # Call Function ResponseException to get error response from the exception
    }
  }
}
Export-ModuleMember -Function Request-VCFCertificateCSR

Function Get-VCFCertificate {
<#
    .SYNOPSIS
    Get latest generated certificate(s) in a domain

    .DESCRIPTION
    The Get-VCFCertificate cmdlet gets the latest generated certificate(s) in a domain

    .EXAMPLE
    PS C:\> Get-VCFCertificate -domainName MGMT
    This example gets a list of certificates that have been generated

    .EXAMPLE
    PS C:\> Get-VCFCertificate -domainName MGMT | ConvertTo-Json
    This example gets a list of certificates and displays them in JSON format

    .EXAMPLE
    PS C:\> Get-VCFCertificate -domainName MGMT | Select issuedTo
    This example gets a list of endpoint names where certificates have been issued
#>

    Param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$domainName
    )
    Try {
        createHeader # Calls Function createHeader to set Accept & Authorization
        $uri = "https://$sddcManager/v1/domains/$domainName/certificates"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.elements
    }
    Catch {
        ResponseException # Call Function ResponseException to get error response from the exception
    }
}
Export-ModuleMember -Function Get-VCFCertificate

Function Request-VCFCertificate {
<#
  .SYNOPSIS
  Generate certificate(s) for the selected resource(s) in a domain

  .DESCRIPTION
  The Request-VCFCertificate cmdlet generates certificate(s) for the selected resource(s) in a domain.
  CA must be configured and CSR must be generated beforehand
  - Resource Types (SDDC_MANAGER, PSC, VCENTER, NSX_MANAGER, NSXT_MANAGER, VRA, VRLI, VROPS,
    VRSLCM, VXRAIL_MANAGER

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
      [ValidateNotNullOrEmpty()]
      [string]$domainName
  )

  if (!(Test-Path $json)) {
    Throw "JSON File Not Found"
  }
  else {
    # Reads the requestCsrSpec json file contents into the $ConfigJson variable
    $ConfigJson = (Get-Content -Raw $json)
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/domains/$domainName/certificates"
    Try {
      $response = Invoke-RestMethod -Method PUT -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
      $response
    }
    Catch {
      ResponseException # Call Function ResponseException to get error response from the exception
    }
  }
}
Export-ModuleMember -Function Request-VCFCertificate

Function Set-VCFCertificate {
<#
  .SYNOPSIS
  Replace certificate(s) for the selected resource(s) in a domain

  .DESCRIPTION
  The Set-VCFCertificate cmdlet replaces certificate(s) for the selected resource(s) in a domain

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
      [ValidateNotNullOrEmpty()]
      [string]$domainName
  )

  if (!(Test-Path $json)) {
    Throw "JSON File Not Found"
  }
  else {
    $ConfigJson = (Get-Content -Raw $json) # Reads the updateCertificateSpec json file contents into the $ConfigJson variable
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/domains/$domainName/certificates"
    Try {
      $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
      $response
    }
    Catch {
      ResponseException # Call Function ResponseException to get error response from the exception
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

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/system/settings/depot"
    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
    $response.vmwareAccount
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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
      [ValidateNotNullOrEmpty()]
      [string]$username,
		[Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$password
  )

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/system/settings/depot"
    if ( -not $PsBoundParameters.ContainsKey("username") -and ( -not $PsBoundParameters.ContainsKey("password"))) {
      Throw "You must enter a username and password"
		}
    $ConfigJson = '{"vmwareAccount": {"username": "'+$username+'","password": "'+$password+'"}}'
    $response = Invoke-RestMethod -Method PUT -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Set-VCFDepotCredentials

######### End Depot Configuration Operations ##########

######### Start System Health Check ##########

Function Start-PreCheckVCFSystem {
<#
  .SYNOPSIS
  The Start-PreCheckVCFSystem cmdlet performs system level health checks

  .DESCRIPTION
  The Start-PreCheckVCFSystem cmdlet performs system level health checks and upgrade pre-checks for an upgrade to be successful

  .EXAMPLE
  PS C:\> Start-PreCheckVCFSystem -json
  This example shows how to perform system level health check
#>

	Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$json
  )

  createHeader # Calls Function createHeader to set Accept & Authorization
  if ($PsBoundParameters.ContainsKey("json")) {
    if (!(Test-Path $json)) {
      Throw "JSON File Not Found"
    }
    else {
      $ConfigJson = (Get-Content $json) # Read the json file contents into the $ConfigJson variable
    }
  }
  else {
    Throw "json file not found"
  }
  $uri = "https://$sddcManager/v1/system/prechecks"
  Try {
    $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Start-PreCheckVCFSystem

######### End System Health Check ##########

######### Start System Health Check Task Monitoring ##########

Function Get-PreCheckVCFSystemTask {

<#
  .SYNOPSIS
  The Get-PreCheckVCFSystemTask cmdlet performs retrieval of a system precheck task that can be polled and monitored.

  .DESCRIPTION
  The Get-PreCheckVCFSystemTask cmdlet performs retrieval of a system precheck task that can be polled and monitored.

  .EXAMPLE
  PS C:\> Get-PreCheckVCFSystemTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d
  This example shows how to retrieve the status of a system level precheck task
#>

	Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$id
  )

  createHeader # Calls Function createHeader to set Accept & Authorization
  if ($PsBoundParameters.ContainsKey("id")) {
    $uri = "https://$sddcManager/v1/system/prechecks/tasks/$id"
  }
  else {
    Throw "task id not provided"
  }
  Try {
    $response = Invoke-RestMethod -Method GET -URI $uri -ContentType application/json -headers $headers
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-PreCheckVCFSystemTask

######### End System Health Check Task Monitoring ##########


######### Start Foundation Component Operations ##########

Function Get-VCFManager {
<#
  .SYNOPSIS
  Get a list of SDDC Managers

  .DESCRIPTION
  The Get-VCFManager cmdlet retrieves the SDDC Manager details

  .EXAMPLE
  PS C:\> Get-VCFManager
  This example shows how to retrieve a list of SDDC Managers

  .EXAMPLE
  PS C:\> Get-VCFManager -id 60d6b676-47ae-4286-b4fd-287a888fb2d0
  This example shows how to return the details for a specific SDDC Manager based on the ID

  .EXAMPLE
  PS C:\> Get-VCFManager -domain 1a6291f2-ed54-4088-910f-ead57b9f9902
  This example shows how to return the details for a specific SDDC Manager based on a domain ID
#>

  Param (
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$id,
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$domainId
  )

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/sddc-managers/$id"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
    if (-not $PsBoundParameters.ContainsKey("id") -and (-not $PsBoundParameters.ContainsKey("domainId"))) {
      $uri = "https://$sddcManager/v1/sddc-managers"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
    if ($PsBoundParameters.ContainsKey("domainId")) {
      $uri = "https://$sddcManager/v1/sddc-managers/?domain=$domainId"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFManager

Function Get-VCFService {
<#
  .SYNOPSIS
  Gets a list of running VCF Services

  .DESCRIPTION
  The Get-VCFService cmdlet retrieves the list of services running on the connected SDDC Manager

  .EXAMPLE
  PS C:\> Get-VCFService
  This example shows how to get the list of services running on the connected SDDC Manager

  .EXAMPLE
  PS C:\> Get-VCFService -id 4e416419-fb82-409c-ae37-32a60ba2cf88
  This example shows how to return the details for a specific service running on the connected SDDC Manager based on the ID
#>

  Param (
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$id
  )

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/vcf-services/$id"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
    if (-not $PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/vcf-services"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
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
  using its id

  .EXAMPLE
  PS C:\> Get-VCFvCenter -domain 1a6291f2-ed54-4088-910f-ead57b9f9902
  This example shows how to return the details off all vCenter Server managed by the connected SDDC Manager using
  its domainId

  .EXAMPLE
  PS C:\> Get-VCFvCenter | select fqdn
  This example shows how to get the list of vCenter Servers managed by the connected SDDC Manager but only return the fqdn
#>

  Param (
		[Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$id,
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$domainId
  )

  # Check the version of SDDC Manager
  CheckVCFVersion
  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    if (-not $PsBoundParameters.ContainsKey("id") -and (-not $PsBoundParameters.ContainsKey("domainId"))) {
      $uri = "https://$sddcManager/v1/vcenters"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
    if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/vcenters/$id"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
    if ($PsBoundParameters.ContainsKey("domainId")) {
      $uri = "https://$sddcManager/v1/vcenters/?domain=$domainId"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFvCenter

Function Get-VCFPsc {
<#
  .SYNOPSIS
  Gets a list of Platform Services Controller (PSC) Servers

  .DESCRIPTION
  The Get-VCFPsc cmdlet retrieves a list of Platform Services Controllers (PSC)s managed by
  the connected SDDC Manager

  .EXAMPLE
  PS C:\> Get-VCFPsc
  This example shows how to get the list of the PSC servers managed by the connected SDDC Manager

  .EXAMPLE
  PS C:\> Get-VCFPsc -id 23832dec-e156-4d2d-89bf-37fb0a47aab5
  This example shows how to return the details for a specific PSC server managed by the connected SDDC Manager
  using its id

  .EXAMPLE
  PS C:\> Get-VCFPsc -domainId 1a6291f2-ed54-4088-910f-ead57b9f9902
  This example shows how to return the details for all PSC servers managed by the connected SDDC Manager using
  the domain ID

  .EXAMPLE
  PS C:\> Get-VCFPsc | select fqdn
  This example shows how to get the list of PSC Servers managed by the connected SDDC Manager but only return the fqdn
#>

  Param (
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$id,
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$domainId
  )

  # Check the version of SDDC Manager
  CheckVCFVersion
  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    if (-not $PsBoundParameters.ContainsKey("id") -and (-not $PsBoundParameters.ContainsKey("domainId"))) {
      $uri = "https://$sddcManager/v1/pscs"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
    if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/pscs/$id"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
    if ($PsBoundParameters.ContainsKey("domainId")) {
      $uri = "https://$sddcManager/v1/pscs/?domain=$domainId"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFPsc

Function Get-VCFNsxvManager {
<#
  .SYNOPSIS
  Gets a list of NSX-v Managers

  .DESCRIPTION
  The Get-VCFNsxvManager cmdlet retrieves a list of NSX-v Managers managed by the connected SDDC Manager

  .EXAMPLE
  PS C:\> Get-VCFNsxvManager
  This example shows how to get the list of NSX-v Managers managed by the connected SDDC Manager

  .EXAMPLE
  PS C:\> Get-VCFNsxvManager -id d189a789-dbf2-46c0-a2de-107cde9f7d24
  This example shows how to return the details for a specic NSX-v Manager managed by the connected SDDC Manager
  using its ID

  PS C:\> Get-VCFNsxvManager -domainId 9a13bde7-bbd7-4d91-95a2-ee0189ffdaf3
  This example shows how to return details for all NSX-v Managers managed by the connected SDDC Manager
  using its Domain ID

  .EXAMPLE
  PS C:\> Get-VCFNsxvManager | select fqdn
  This example shows how to get the list of NSX-v Managers managed by the connected SDDC Manager but only return the fqdn
#>

  Param (
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$id,
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$domainId
  )

  # Check the version of SDDC Manager
  CheckVCFVersion
  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    if (-not $PsBoundParameters.ContainsKey("id") -and (-not $PsBoundParameters.ContainsKey("domainId"))) {
      $uri = "https://$sddcManager/v1/nsx-managers"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
    if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/nsx-managers/$id"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
    if ($PsBoundParameters.ContainsKey("domainId")) {
      $uri = "https://$sddcManager/v1/nsx-managers/?domain=$domainId"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFNsxvManager

Function Get-VCFNsxtCluster {
<#
  .SYNOPSIS
  Gets a list of NSX-T Clusters

  .DESCRIPTION
  The Get-VCFNsxtCluster cmdlet retrieves a list of NSX-T Clusters managed by the connected SDDC Manager

  .EXAMPLE
  PS C:\> Get-VCFNsxtCluster
  This example shows how to get the list of NSX-T Clusters managed by the connected SDDC Manager

  .EXAMPLE
  PS C:\> Get-VCFNsxtCluster -id d189a789-dbf2-46c0-a2de-107cde9f7d24
  This example shows how to return the details for a specic NSX-T Clusters managed by the connected SDDC Manager
  using the ID

  .EXAMPLE
  PS C:\> Get-VCFNsxtCluster -domainId 9a13bde7-bbd7-4d91-95a2-ee0189ffdaf3
  This example shows how to return the details for all NSX-T Clusters managed by the connected SDDC Manager
  using the domain ID

  .EXAMPLE
  PS C:\> Get-VCFNsxtCluster | select vipfqdn
  This example shows how to get the list of NSX-T Clusters managed by the connected SDDC Manager but only return the vipfqdn
#>

  Param (
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$id,
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [string]$domainId
  )

  # Check the version of SDDC Manager
  CheckVCFVersion
  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    if (-not $PsBoundParameters.ContainsKey("id") -and (-not $PsBoundParameters.ContainsKey("domainId"))) {
      $uri = "https://$sddcManager/v1/nsxt-clusters"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
    if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/v1/nsxt-clusters/$id"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
    if ($PsBoundParameters.ContainsKey("domainId")) {
      $uri = "https://$sddcManager/v1/nsxt-clusters/?domain=$domainId"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response.elements
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFNsxtCluster

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

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/vrli"
    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFvRLI

Function Invoke-VCFCommand {
<#
  .SYNOPSIS
  Connects to the specified SDDC Manager using SSH and invoke SSH commands (SoS)

  .DESCRIPTION
  The Invoke-VCFCommand cmdlet connects to the specified SDDC Manager via SSH using vcf user and subsequently
  execute elevated SOS commands using the root account. Both vcf and root password are mandatory parameters.
  If passwords are not passed as parameters it will prompt for them.

  .EXAMPLE
  PS C:\> Invoke-VCFCommand -vcfpassword VMware1! -rootPassword VMware1! -sosOption general-health
  This example will execute and display the output of "/opt/vmware/sddc-support/sos --general-health"

  .EXAMPLE
  PS C:\> Invoke-VCFCommand -sosOption general-health
  This example will ask for vcf and root password to the user and then execute and display the output of "/opt/vmware/sddc-support/sos --general-health"
#>

  Param (
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String] $vcfPassword,
    [Parameter (Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
      [String] $rootPassword,
    [Parameter (Mandatory=$true)]
      [ValidateSet("general-health","compute-health","ntp-health","password-health","get-vcf-summary","get-inventory-info","get-host-ips","get-vcf-services-summary")]
      [String] $sosOption
  )

  $poshSSH = Resolve-PSModule -moduleName "Posh-SSH" # POSH module is required, if not present skipping
  if ($poshSSH -eq "ALREADY_IMPORTED" -or $poshSSH -eq "IMPORTED" -or $poshSSH -eq "INSTALLED_IMPORTED") {
    # Expected sudo prompt from SDDC Manager for elevated commands
    $sudoPrompt = "[sudo] password for vcf"
  # validate if the SDDC Manager vcf password parameter is passed, if not prompt the user and then build vcfCreds PSCredential object
  if ( -not $PsBoundParameters.ContainsKey("vcfPassword") ) {
    Write-Host "Please provide the SDDC Manager vcf user password:" -ForegroundColor Green
    $vcfSecuredPassword = Read-Host -AsSecureString
    $vcfCred = New-Object System.Management.Automation.PSCredential ('vcf', $vcfSecuredPassword)
  }
  else {
    # Convert the clear text input password to secure string
    $vcfSecuredPassword = ConvertTo-SecureString $vcfPassword -AsPlainText -Force
    # build credential object
    $vcfCred = New-Object System.Management.Automation.PSCredential ('vcf', $vcfSecuredPassword)
  }
  # validate if the SDDC Manager root password parameter is passed, if not prompt the user and then build rootCreds PSCredential object
  if ( -not $PsBoundParameters.ContainsKey("rootPassword") ) {
    Write-Host "Please provide the root credential to execute elevated commands in SDDC Manager:" -ForegroundColor Green
    $rootSecuredPassword = Read-Host -AsSecureString
    $rootCred = New-Object System.Management.Automation.PSCredential ('root', $rootSecuredPassword)
  }
  else {
    # Convert the clear text input password to secure string
    $rootSecuredPassword = ConvertTo-SecureString $rootPassword -AsPlainText -Force
    # build credential object
    $rootCred = New-Object System.Management.Automation.PSCredential ('root', $rootSecuredPassword)
  }
  # depending on the SoS command there will be a different pattern to match at the end of the ssh stream output
  switch ($sosOption) {
    "general-health"        { $sosEndMessage = "For detailed report" }
    "compute-health"        { $sosEndMessage = "Health Check completed" }
    "ntp-health"            { $sosEndMessage = "For detailed report" }
    "password-health"       { $sosEndMessage = "completed"  }
    "get-inventory-info"    { $sosEndMessage = "Health Check completed" }
    "get-vcf-summary"       { $sosEndMessage = "SOLUTIONS_MANAGER" }
    "get-host-ips"          { $sosEndMessage = "Health Check completed" }
    "get-vcf-services-summary" { $sosEndMessage = "VCF SDDC Manager Uptime" }
  }
  # Create SSH session to SDDC Manager using vcf user (can't ssh as root by default)
  Try {
    $sessionSSH = New-SSHSession -Computer $sddcManager -Credential $vcfCred -AcceptKey
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
  if ($sessionSSH.Connected -eq "True") {
    $stream = $SessionSSH.Session.CreateShellStream("PS-SSH", 0, 0, 0, 0, 1000)
    # build the SOS command to run
    $sshCommand = "sudo /opt/vmware/sddc-support/sos " + "--" + $sosOption
    # Invoke the SSH stream command
    $outInvoke = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command $sshCommand -ExpectString $sudoPrompt -SecureAction $rootCred.Password
    if ($outInvoke) {
      Write-Host ""
      Write-Host "Executing the remote SoS command, output will display when the the run is completed. This might take a while, please wait..."
      Write-Host ""
      $stream.Expect($sosEndMessage)
    }
    # distroy the connection previously established
    Remove-SSHSession -SessionId $sessionSSH.SessionId | Out-Null
    }
  }
  else {
    Write-Host ""
    Write-Host "PowerShell Module Posh-SSH staus is: $poshSSH. Posh-SSH is required to execute this cmdlet, please install the module and try again." -ForegroundColor Yellow
    Write-Host ""
  }
}
Export-ModuleMember -Function Invoke-VCFCommand

######### End Foundation Component Operations ##########

######### Start vRealize Suite Operations ##########
Function Get-VCFvRSLCM {
<#
  .SYNOPSIS
  Get the existing vRealize Suite Lifecycle Manager

  .DESCRIPTION
  The Get-VCFvRSLCM cmdlet gets the complete information about the existing vRealize Suite Lifecycle Manager.

  .EXAMPLE
  PS C:\> Get-VCFvRSLCM
  This example list all details concerning the vRealize Suite Lifecycle Manager
#>

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/vrslcm"
    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFvRSLCM

Function Get-VCFvRSLCMEnvironment {
<#
  .SYNOPSIS
  Get vRealize Suite Lifecycle Manager environments

  .DESCRIPTION
  The Get-VCFvRSLCMEnvironment cmdlet gets all the vRealize products and the corresponding vRealize Suite Lifecycle Manager environments that are managed by VMware Cloud Foundation.

  .EXAMPLE
  PS C:\> Get-VCFvRSLCMEnvironment
  This example list all vRealize Suite Lifecycle Manager environments
#>

  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/vrslcm/environments"
    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFvRSLCMEnvironment

Function New-VCFvRSLCM {
<#
    .SYNOPSIS
    Deploy vRealize Suite Lifecycle Manager
    
    .DESCRIPTION
    The New-VCFvRSLCM cmdlet deploys vRealize Suite Lifecycle Manager to the specified network.
    
    .EXAMPLE
    PS C:\> New-VCFvRSLCM -json .\SampleJson\vRealize\New-vRSLCM.json
    This example deploys vRealize Suite Lifecycle Manager using a supplied json file
    
    #>

    Param (
        [Parameter (Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$json
    )

    if (!(Test-Path $json)) {
        Throw "JSON File Not Found"
    }
    else {
        Try {
            # Call Function createHeader to set Accept & Authorization
            createHeader 
            # Read the json file contents into the $ConfigJson variable
            $ConfigJson = (Get-Content -Raw $json)
            $uri = "https://$sddcManager/v1/vrslcms"
            $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
            $response
        }
        Catch {
            # Call Function ResponseException to get error response from the exception
            ResponseException
        }
    }
}   
Export-ModuleMember -Function New-VCFvRSLCM

Function Remove-VCFvRSLCM {
<#
    .SYNOPSIS
    Remove a failed vRealize Suite Lifecycle Manager deployment
    
    .DESCRIPTION
    The New-VCFvRSLCM cmdlet removes a failed vRealize Suite Lifecycle Manager deployment. Not applicable 
    to a successful vRealize Suite Lifecycle Manager deployment.
    
    .EXAMPLE
    PS C:\> Remove-VCFvRSLCM
    This example removes a failed vRealize Suite Lifecycle Manager deployment
    
    #>

    Try {
        # Call Function createHeader to set Accept & Authorization
        createHeader 
        $uri = "https://$sddcManager/v1/vrslcm"
        $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
        $response
    }
    Catch {
        # Call Function ResponseException to get error response from the exception
        ResponseException
    }
}   
Export-ModuleMember -Function Remove-VCFvRSLCM


Function Get-VCFvROPs {
<#
  .SYNOPSIS
  Get the existing vRealize Operations Manager

  .DESCRIPTION
  The Get-VCFvROPs cmdlet gets the complete information about the existing vRealize Operations Manager.

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

	Param (
    [Parameter (Mandatory=$false)]
			[ValidateNotNullOrEmpty()]
			[switch]$getIntegratedDomains,
    [Parameter (Mandatory=$false)]
			[ValidateNotNullOrEmpty()]
			[switch]$nodes
	)

  createHeader # Calls Function createHeader to set Accept & Authorization
  if ($PsBoundParameters.ContainsKey("nodes")) {
    $uri = "https://$sddcmanager/v1/vrops/nodes"
  }
  if ($PsBoundParameters.ContainsKey("getIntegratedDomains")) {
    $uri = "https://$sddcmanager/v1/vrops/domains"
  }
  else {
    $uri = "https://$sddcManager/v1/vropses"
	}
  Try {
    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFvROPs




######### End vRealize Suite Operations ##########

######### Start Federation Management ##########

Function Get-VCFFederation {
<#
  .SYNOPSIS
  Get information on existing Federation

  .DESCRIPTION
  The Get-VCFFederation cmdlet gets the complete information about the existing VCF Federation

  .EXAMPLE
  PS C:\> Get-VCFFederation
  This example list all details concerning the VCF Federation

  .EXAMPLE
  PS C:\> Get-VCFFederation | ConvertTo-Json
  This example list all details concerning the VCF Federation and outputs them in Json format
#>

  Try {
    CheckVCFVersion # Calls Function CheckVCFVersion to check VCF Version
    createHeader # Calls Function createHeader to set Accept & Authorization
    $uri = "https://$sddcManager/v1/sddc-federation"
    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
    $response
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Get-VCFFederation

Function Set-VCFFederation {
<#
  .SYNOPSIS
  Bootstrap a VMware Cloud Foundation to form a federation

  .DESCRIPTION
  The Set-VCFFederation cmdlet bootstraps the creation of a Federation in VCF

  .EXAMPLE
  PS C:\> Set-VCFFederation -json createFederation.json
  This example shows how to create a fedration using the json file
#>

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$json
  )

  if (!(Test-Path $json)) {
    Throw "JSON File Not Found"
  }
  else {
    Try {
      CheckVCFVersion # Calls Function CheckVCFVersion to check VCF Version
      createHeader # Calls Function createHeader to set Accept & Authorization
      $ConfigJson = (Get-Content -Raw $json) # Reads the json file contents into the $ConfigJson variable
      $uri = "https://$sddcManager/v1/sddc-federation"
      $response = Invoke-RestMethod -Method PUT -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
      $response
    }
    Catch {
      ResponseException # Call Function ResponseException to get error response from the exception
    }
  }
}
Export-ModuleMember -Function Set-VCFFederation

Function Remove-VCFFederation {
<#
  .SYNOPSIS
  Remove VCF Federation

  .DESCRIPTION
  A function that ensures VCF Federation is empty and completely dismantles it.

  .EXAMPLE
  PS C:\> Remove-VCFFederation
  This example demonstrates how to dismantle the VCF Federation
#>

  CheckVCFVersion # Calls Function CheckVCFVersion to check VCF Version
  createHeader # Calls Function createHeader to set Accept & Authorization
  $uri = "https://$sddcManager/v1/sddc-federation"
  Try {
    # Verify that SDDC Manager we're connected to is a controller and only one in the Federation
    $sddcs = Get-VCFFederation | Select-Object memberDetails
    Foreach ($sddc in $sddcs) {
      if ($sddc.memberDetails.role -eq "CONTROLLER") {
        $controller++
        if ($sddc.memberDetails.role -eq "MEMBER") {
          $member++
          }
        }
      }
      if ($controller -gt 1) {
        Throw "Only one controller can be present when dismantling VCF Federation. Remove additional controllers and try again"
      }
      if ($member -gt 0) {
        Throw "VCF Federation members still exist. Remove all members and additional controllers before dismantling VCF Federation"
      }
      $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
      $response
    }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function Remove-VCFFederation

Function New-VCFFederationInvite {
<#
  .SYNOPSIS
  Invite new member to VCF Federation.

  .DESCRIPTION
  A function that creates a new invitation for a member to join the existing VCF Federation.

  .EXAMPLE
  PS C:\> New-VCFFederationInvite -inviteeFqdn sddc-manager1.vsphere.local
  This example demonstrates how to create an invitation for a specified VCF Manager from the Federation controller.
#>

  Param (
	  [Parameter (Mandatory=$true)]
		  [ValidateNotNullOrEmpty()]
			[string]$inviteeFqdn
  )

  CheckVCFVersion # Calls Function CheckVCFVersion to check VCF Version
  createHeader # Calls Function createHeader to set Accept & Authorization
  $uri = "https://$sddcManager/v1/sddc-federation/membership-tokens"
  Try {
    $sddcMemberRole = Get-VCFFederationMembers
    if ($sddcMemberRole.memberDetail.role -ne "CONTROLLER" -and $sddcMemberRole.memberDetail.fqdn -ne $sddcManager) {
      Throw "$sddcManager is not the Federation controller. Invitatons to join Federation can only be sent from the Federation controller."
    }
    else {
      $inviteeDetails = @{
        inviteeRole = 'MEMBER'
        inviteeFqdn = $inviteeFqdn
      }
      $ConfigJson = $inviteeDetails | ConvertTo-Json
      $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -body $ConfigJson -ContentType 'application/json'
      $response
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -Function New-VCFFederationInvite

Function Get-VCFFederationMembers {
<#
  .SYNOPSIS
  A function that gets information on all members in the VCF Federation

  .DESCRIPTION
  Gets the complete information about the existing VCF Federation members.

  .EXAMPLE
  PS C:\> Get-VCFFederationMembers
  This example lists all details concerning the VCF Federation members.
#>

  CheckVCFVersion # Calls Function CheckVCFVersion to check VCF Version
  createHeader # Calls Function createHeader to set Accept & Authorization
  $uri = "https://$sddcManager/v1/sddc-federation/members"
  Try {
    $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
    if (!$response.federationName) {
      Throw "Failed to get members, no Federation found."
    }
    else {
      $response
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
Export-ModuleMember -function Get-VCFFederationMembers

Function Join-VCFFederation {
<#
  .SYNOPSIS
  A function to join an existing VCF Federation

  .DESCRIPTION
  A function that enables a new VCF Manager to join an existing VCF Federation.

  .EXAMPLE
  PS C:\> Join-VCFFederation .\joinVCFFederationSpec.json
  This example demonstrates how to join an VCF Federation by referencing config info in JSON file.
#>

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$json
  )

  if (!(Test-Path $json)) {
    Throw "JSON File Not Found"
  }
  else {
    CheckVCFVersion # Calls Function CheckVCFVersion to check VCF Version
    $ConfigJson = (Get-Content -Raw $json) # Reads the joinSVCFFederation json file contents into the $ConfigJson variable
    createHeader # Calls Function createHeader to set Accept & Authorization
	  $uri = "https://$sddcManager/v1/sddc-federation/members"
    Try {
			$response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType 'application/json' -body $ConfigJson
      $response
      $taskId = $response.taskId # get the task id from the action
      # keep checking until executionStatus is not IN_PROGRESS
      Do {
        $uri = "https://$sddcManager/v1/sddc-federation/tasks/$taskId"
        $response = Invoke-RestMethod -Method GET -URI $uri -Headers $headers -ContentType 'application/json'
        Start-Sleep -Second 5
      }
      While ($response.status -eq "IN_PROGRESS")
        $response
      }
    Catch {
      ResponseException # Call Function ResponseException to get error response from the exception
    }
  }
}
Export-ModuleMember -Function Join-VCFFederation

######### End Federation Management ##########


######### Start Application Virtual Network ##########

Function Get-VCFApplicationVirtualNetwork {
  <#
  .SYNOPSIS
  Retrieves all Application Virtual Networks
  
  .DESCRIPTION
  The Get-VCFApplicationVirtualNetwork cmdlet retrieves the Application Virtual Networks configured in SDDC Manager
    - regionType supports REGION_A, REGION_B, X_REGION
  
  .EXAMPLE
  PS C:\> Get-VCFApplicationVirtualNetwork
  This example demonstrates how to retrieve a list of Application Virtual Networks

  .EXAMPLE
  PS C:\> Get-VCFApplicationVirtualNetwork -regionType REGION_A
  This example demonstrates how to retrieve the details of the regionType REGION_A Application Virtual Networks

  .EXAMPLE
  PS C:\> Get-VCFApplicationVirtualNetwork -id 577e6262-73a9-4825-bdb9-4341753639ce
  This example demonstrates how to retrieve the details of the Application Virtual Networks using the id
  #>

  Param (
    [Parameter (Mandatory=$false)]
        [ValidateSet("REGION_A", "REGION_B", "X_REGION")]
        [ValidateNotNullOrEmpty()]
        [string]$regionType,
    [Parameter (Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$id
  )

  CheckVCFVersion # Calls Function CheckVCFVersion to check VCF Version
  Try {
    createHeader # Calls Function createHeader to set Accept & Authorization
    if (-not $PsBoundParameters.ContainsKey("regionType") -and (-not $PsBoundParameters.ContainsKey("id"))) {
      $uri = "https://$sddcManager/v1/avns"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
    if ($PsBoundParameters.ContainsKey("regionType")) {
      $uri = "https://$sddcManager/v1/avns?regionType=$regionType"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
    if ($PsBoundParameters.ContainsKey("id")) {
      $uri = "https://$sddcManager/internal/avns/$id"
      $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
      $response
    }
  }
  Catch {
    ResponseException # Call Function ResponseException to get error response from the exception
  }
}
  Export-ModuleMember -Function Get-VCFApplicationVirtualNetwork

######### End Application Virtual Network ##########


######### Start Utility Functions (not exported) ##########

Function ResponseException {
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
    Throw $ErrorString
    Write-Host ""
  }
  else {
    Throw $_
  }
}

Function CheckVCFVersion {
  $vcfManager = Get-VCFManager
  if (($vcfManager.version.Substring(0,3) -ne "3.9") -and ($vcfManager.version.Substring(0,3) -ne "4.0")) {
    Write-Host ""
    Write-Host "This cmdlet is only supported in VCF 3.9 or later" -ForegroundColor Magenta
    Write-Host ""
    break
  }
}

Function createHeader {
  $Global:headers = @{"Accept" = "application/json"}
  $Global:headers.Add("Authorization", "Basic $base64AuthInfo")
}

Function Resolve-PSModule {
<#
  .SYNOPSIS
  Check for a PowerShell module presence, if not there try to import/install it.

  .DESCRIPTION
  This function is not exported. The idea is to use the return searchResult from the caller function to establish
  if we can proceed to the next step where the module will be required (developed to check on Posh-SSH).
  Logic:
  - Check if module is imported into the current session
  - If module is not imported, check if available on disk and try to import
  - If module is not imported & not available on disk, try PSGallery then install and import
  - If module is not imported, not available and not in online gallery then abort

  Informing user only if the module needs importing/installing. If the module is already present nothing will be displayed.

  .EXAMPLE
  PS C:\> $poshSSH = Resolve-PSModule -moduleName "Posh-SSH"
  This example will check if the current PS module session has Posh-SSH installed, if not will try to install it
#>

  Param (
    [Parameter (Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [string]$moduleName
  )

  # check if module is imported into the current session
  if (Get-Module -Name $moduleName) {
    $searchResult = "ALREADY_IMPORTED"
  }
  else {
    # If module is not imported, check if available on disk and try to import
    if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $moduleName}) {
      Try {
        Write-Host ""
        Write-Host "Module $moduleName not loaded, importing now please wait..."
        Import-Module $moduleName
        Write-Host "Module $moduleName imported successfully."
        $searchResult = "IMPORTED"
      }
      Catch {
        $searchResult = "IMPORT_FAILED"
      }
    }
    else {
      # If module is not imported & not available on disk, try PSGallery then install and import
      if (Find-Module -Name $moduleName | Where-Object {$_.Name -eq $moduleName}) {
      Try {
        Write-Host ""
        Write-Host "Module $moduleName was missing, installing now please wait..."
        Install-Module -Name $moduleName -Force -Scope CurrentUser
        Write-Host "Importing module $moduleName, please wait..."
        Import-Module $moduleName
        Write-Host "Module $moduleName installed and imported"
        $searchResult = "INSTALLED_IMPORTED"
      }
      Catch {
        $searchResult = "INSTALLIMPORT_FAILED"
      }
    }
    else {
      # If module is not imported, not available and not in online gallery then abort
      $searchResult = "NOTAVAILABLE"
    }
  }
}
Return $searchResult
}

######### End Utility Functions (not exported) ##########
