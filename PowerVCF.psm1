# PowerShell module for VMware Cloud Foundation
# Contributions, Improvements &/or Complete Re-writes Welcome!
# https://github.com/PowerVCF/PowerVCF

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
# OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Note
# This PowerShell module should be considered entirely experimental. It is still in development & not tested beyond
# lab scenarios. It is recommended you dont use it for any production environment without testing extensively!

# Enable communication with self signed certs when using Powershell Core if you require all communications to be secure
# and do not wish to allow communication with self signed certs remove lines 22-39 before importing the module

if ($PSEdition -eq 'Core') {
    $PSDefaultParameterValues.Add("Invoke-RestMethod:SkipCertificateCheck", $true)
}

if ($PSEdition -eq 'Desktop') {
    # Enable communication with self signed certs when using Windows Powershell
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

    If (!("TrustAllCertificatePolicy" -as [type])) {
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
}
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertificatePolicy
}

####  Do not modify anything below this line. All user variables are in the accompanying JSON files #####

#Region APIs for managing VCF tokens and initial connections
Function Request-VCFToken {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and requests API access & refresh tokens

        .DESCRIPTION
        The Request-VCFToken cmdlet connects to the specified SDDC Manager and requests API access & refresh tokens.
        It is required once per session before running all other cmdlets

        .EXAMPLE
        Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username administrator@vsphere.local -password VMw@re1!
        This example shows how to connect to SDDC Manager to request API access & refresh tokens

        .EXAMPLE
        Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username admin@local -password VMw@re1!VMw@re1!
        This example shows how to connect to SDDC Manager using local account admin@local
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$fqdn,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$username,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$password,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$skipCertificateCheck
    )

    if ( -not $PsBoundParameters.ContainsKey("username") -or ( -not $PsBoundParameters.ContainsKey("password"))) {
        $creds = Get-Credential # Request Credentials
        $username = $creds.UserName.ToString()
        $password = $creds.GetNetworkCredential().password
    }

    if ($PsBoundParameters.ContainsKey("skipCertificateCheck")) {
        if (-not("dummy" -as [type])) {
            add-type -TypeDefinition @"
using System;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

public static class Dummy {
    public static bool ReturnTrue(object sender,
        X509Certificate certificate,
        X509Chain chain,
        SslPolicyErrors sslPolicyErrors) { return true; }

    public static RemoteCertificateValidationCallback GetDelegate() {
        return new RemoteCertificateValidationCallback(Dummy.ReturnTrue);
    }
}
"@
} 
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = [dummy]::GetDelegate()
    }

    $Global:sddcManager = $fqdn
    $headers = @{"Content-Type" = "application/json" }
    $uri = "https://$sddcManager/v1/tokens" # Set URI for executing an API call to validate authentication
    $body = '{"username": "' + $username + '","password": "' + $password + '"}'

    Try {
        # Checking authentication with SDDC Manager
        if ($PSEdition -eq 'Core') {
            $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -body $body -SkipCertificateCheck # PS Core has -SkipCertificateCheck implemented
            $Global:accessToken = $response.accessToken
            $Global:refreshToken = $response.refreshToken.id
        }:
        else {
            $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -body $body
            $Global:accessToken = $response.accessToken
            $Global:refreshToken = $response.refreshToken.id
        }
        if ($response.accessToken) {
            Write-Output "Successfully Requested New API Token From SDDC Manager: $sddcManager"
        }
    }
    Catch {
        Write-Error $._Exception.Message
    }
}
Export-ModuleMember -Function Request-VCFToken

Function Connect-CloudBuilder {
    <#
        .SYNOPSIS
        Connects to the specified Cloud Builder and stores the credentials in a base64 string

        .DESCRIPTION
        The Connect-CloudBuilder cmdlet connects to the specified Cloud Builder and stores the credentials
        in a base64 string. It is required once per session before running all other cmdlets

        .EXAMPLE
        Connect-CloudBuilder -fqdn sfo-cb01.sfo.rainpole.io -username admin -password VMware1!
        This example shows how to connect to the Cloud Builder applaince
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$fqdn,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$username,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$password,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$skipCertificateCheck
    )

    if ( -not $PsBoundParameters.ContainsKey("username") -or ( -not $PsBoundParameters.ContainsKey("password"))) {
        $creds = Get-Credential # Request Credentials
        $username = $creds.UserName.ToString()
        $password = $creds.GetNetworkCredential().password
    }

    if ($PsBoundParameters.ContainsKey("skipCertificateCheck")) {
        if (-not("dummy" -as [type])) {
            add-type -TypeDefinition @"
using System;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

public static class Dummy {
    public static bool ReturnTrue(object sender,
        X509Certificate certificate,
        X509Chain chain,
        SslPolicyErrors sslPolicyErrors) { return true; }

    public static RemoteCertificateValidationCallback GetDelegate() {
        return new RemoteCertificateValidationCallback(Dummy.ReturnTrue);
    }
}
"@
} 
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = [dummy]::GetDelegate()
    }

    $Global:cloudBuilder = $fqdn
    $Global:base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password))) # Create Basic Authentication Encoded Credentials

    $headers = @{"Accept" = "application/json" }
    $headers.Add("Authorization", "Basic $base64AuthInfo")
    $uri = "https://$cloudBuilder/v1/sddcs" # Set URI for executing an API call to validate authentication

    Try {
        # Checking authentication with VMware Cloud Builder
        if ($PSEdition -eq 'Core') {
            $response = Invoke-WebRequest -Method GET -Uri $uri -Headers $headers -SkipCertificateCheck # PS Core has -SkipCertificateCheck implemented
        }
        else {
            $response = Invoke-WebRequest -Method GET -Uri $uri -Headers $headers
        }
        if ($response.StatusCode -eq 200) {
            Write-Output "Successfully connected to the Cloud Builder Appliance: $cloudBuilder"
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Connect-CloudBuilder
#EndRegion APIs for managing VCF tokens and initial connections


#Region APIs for managing Application Virtual Networks
Function Get-VCFApplicationVirtualNetwork {
    <#
        .SYNOPSIS
        Retrieves all Application Virtual Networks

        .DESCRIPTION
        The Get-VCFApplicationVirtualNetwork cmdlet retrieves the Application Virtual Networks configured in SDDC Manager
        - regionType supports REGION_A, REGION_B, X_REGION

        .EXAMPLE
        Get-VCFApplicationVirtualNetwork
        This example demonstrates how to retrieve a list of Application Virtual Networks

        .EXAMPLE
        Get-VCFApplicationVirtualNetwork -regionType REGION_A
        This example demonstrates how to retrieve the details of the regionType REGION_A Application Virtual Networks

        .EXAMPLE
        Get-VCFApplicationVirtualNetwork -id 577e6262-73a9-4825-bdb9-4341753639ce
        This example demonstrates how to retrieve the details of the Application Virtual Networks using the id
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateSet("REGION_A", "REGION_B", "X_REGION")] [ValidateNotNullOrEmpty()] [String]$regionType,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
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
            $uri = "https://$sddcManager/v1/avns/avns?id=$id"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFApplicationVirtualNetwork

Function Add-VCFApplicationVirtualNetwork {
    <#
        .SYNOPSIS
        Creates Application Virtual Networks

        .DESCRIPTION
        The Add-VCFApplicationVirtualNetwork cmdlet creates Application Virtual Networks in SDDC Manager and NSX-T Data Center

        .EXAMPLE
        Add-VCFApplicationVirtualNetwork -json (Get-Content -Raw .\SampleJSON\Application Virtual Network\avnOPverlaySpec.json)
        This example demonstrates how to deploy the Application Virtual Networks using the JSON spec supplied

        .EXAMPLE
        Add-VCFApplicationVirtualNetwork -json (Get-Content -Raw .\SampleJSON\Application Virtual Network\avnOverlaySpec.json) -validate
        This example demonstrates how to validate the Application Virtual Networks JSON spec supplied
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$validate
    )
    
    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ($PsBoundParameters.ContainsKey("validate")) {
            $uri = "https://$sddcManager/v1/avns/validations"
            $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $jsonBody
            $response
        }
        else {
            $uri = "https://$sddcManager/v1/avns"
            $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $jsonBody
            $response
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Add-VCFApplicationVirtualNetwork

#EndRegion APIs for managing Application Virtual Networks


#Region APIs for managing Backup and Restore
Function Get-VCFBackupConfiguration {
    <#
        .SYNOPSIS
        Gets the backup configuration of NSX Manager and SDDC Manager

        .DESCRIPTION
        The Get-VCFBackupConfiguration cmdlet retrieves the current backup configuration details

        .EXAMPLE
        Get-VCFBackupConfiguration
        This example retrieves the backup configuration

        .EXAMPLE
        Get-VCFBackupConfiguration | ConvertTo-Json
        This example retrieves the backup configuration and outputs it in json format
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/system/backup-configuration"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.backupLocations
    }
    Catch {
        ResponseException -object $_
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
        Set-VCFBackupConfiguration -json (Get-Content -Raw .\SampleJSON\Backup\backupConfiguration.json)
        This example shows how to update the backup configuration
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    
    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/system/backup-configuration"
        $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers -ContentType application/json -body $jsonBody
        $response
    }
    Catch {
        ResponseException -object $_
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
        Start-VCFBackup
        This example shows how to start the SDDC Manager backup
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        # this body is fixed for SDDC Manager backups. not worth having it stored on file
        $ConfigJson = '{"elements" : [{"resourceType" : "SDDC_MANAGER"}]}'
        $uri = "https://$sddcManager/v1/backups/tasks"
        $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType "application/json" -body $ConfigJson
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-VCFBackup

Function Start-VCFRestore {
    <#
        .SYNOPSIS
        Start the SDDC Manager restore

        .DESCRIPTION
        The Start-VCFRestore cmdlet invokes the SDDC Manager restore task

        .EXAMPLE
        Start-VCFRestore -backupFile "/tmp/vcf-backup-sfo-vcf01-sfo-rainpole-io-2020-04-20-14-37-25.tar.gz" -passphrase "VMw@re1!VMw@re1!"
        This example shows how to start the SDDC Manager restore
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$backupFile,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$passphrase
    )

    Try {
        createBasicAuthHeader
        $ConfigJson = '{ "backupFile": "' + $backupFile + '", "elements": [ {"resourceType": "SDDC_MANAGER"} ], "encryption": {"passphrase": "' + $passphrase + '"}}'
        $uri = "https://$sddcManager/v1/restores/tasks"
        $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType "application/json" -body $ConfigJson
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-VCFRestore

Function Get-VCFRestoreTask {
    <#
        .SYNOPSIS
        Fetch the restores task

        .DESCRIPTION
        The Get-VCFRestoreTask cmdlet retrieves the status of the restore task

        .EXAMPLE
        Get-VCFRestoreTask -id a5788c2d-3126-4c8f-bedf-c6b812c4a753
        This example shows how to retrieve the status of the restore task by id
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        if ($PsBoundParameters.ContainsKey("id")) {
            createBasicAuthHeader
            $uri = "https://$sddcManager/v1/restores/tasks/$id"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFRestoreTask

#EndRegion APIs for managing Backup and Restore


#Region APIs for managing Bundles

Function Get-VCFBundle {
    <#
        .SYNOPSIS
        Get all Bundles available to SDDC Manager

        .DESCRIPTION
        The Get-VCFBundle cmdlet gets all bundles available to the SDDC Manager instance.
        i.e. Manually uploaded bundles and bundles available via depot access.

        .EXAMPLE
        Get-VCFBundle
        This example gets the list of bundles and all their details

        .EXAMPLE
        Get-VCFBundle | Select version,downloadStatus,id
        This example gets the list of bundles and filters on the version, download status and the id only

        .EXAMPLE
        Get-VCFBundle -id 7ef354ab-13a6-4e39-9561-10d2c4de89db
        This example gets the details of a specific bundle by its id

        .EXAMPLE
        Get-VCFBundle | Where {$_.description -Match "vRealize"}
        This example lists all bundles that match vRealize in the description field
    #>

    Param (
        [Parameter (Mandatory = $false)] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
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
        ResponseException -object $_
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
        Request-VCFBundle -id 7ef354ab-13a6-4e39-9561-10d2c4de89db
        This example requests the immediate download of a bundle based on its id
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/bundles/$id"
        $body = '{"bundleDownloadSpec": {"downloadNow": true}}'
        $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers	-ContentType application/json -body $body
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Request-VCFBundle

Function Start-VCFBundleUpload {
    <#
        .SYNOPSIS
        Starts upload of bundle to SDDC Manager

        .DESCRIPTION
        The Start-VCFBundleUpload cmdlet starts upload of bundle(s) to SDDC Manager
        Prerequisite: The bundle should have been downloaded to SDDC Manager VM using the bundle transfer utility tool

        .EXAMPLE
        Start-VCFBundleUpload -json $jsonSpec
        This example invokes the upload of a bundle onto SDDC Manager using a variable

        .EXAMPLE
        Start-VCFBundleUpload -json (Get-Content -Raw .\upgradeDomain.json)
        This example invokes the upload of a bundle onto SDDC Manager by passing a JSON file
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )
 
    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/bundles"
        $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers	-ContentType application/json -body $jsonBody
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-VCFBundleUpload

#EndRegion APIs for managing Bundles


#Region APIs for managing CEIP

Function Get-VCFCeip {
    <#
        .SYNOPSIS
        Retrieves the current setting for CEIP of the connected SDDC Manager

        .DESCRIPTION
        The Get-VCFCeip cmdlet retrieves the current setting for Customer Experience Improvement Program (CEIP) of the connected SDDC Manager

        .EXAMPLE
        Get-VCFCeip
        This example shows how to get the current setting of CEIP
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/system/ceip"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFCeip

Function Set-VCFCeip {
    <#
        .SYNOPSIS
        Sets the CEIP status (Enabled/Disabled) of the connected SDDC Manager and components managed

        .DESCRIPTION
        The Set-VCFCeip cmdlet configures the status (Enabled/Disabled) for Customer Experience Improvement Program (CEIP) of the connected
        SDDC Manager and the components managed (vCenter Server, vSAN and NSX Manager)

        .EXAMPLE
        Set-VCFCeip -ceipSetting DISABLE
        This example shows how to DISABLE CEIP for SDDC Manager, vCenter Server, vSAN and NSX Manager

        .EXAMPLE
        Set-VCFCeip -ceipSetting ENABLE
        This example shows how to ENABLE CEIP for SDDC Manager, vCenter Server, vSAN and NSX Manager
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateSet("ENABLE", "DISABLE")] [String]$ceipSetting
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/system/ceip"
        $json = '{"status": "' + $ceipSetting + '"}'
        $response = Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $json
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFCeip

#EndRegion APIs for managing CEIP


#Region APIs for managing Certificates

Function Get-VCFCertificateAuthority {
    <#
        .SYNOPSIS
        Get certificate authorities information

        .DESCRIPTION
        The Get-VCFCertificateAuthority cmdlet retrieves the certificate authorities information for the connected SDDC Manager

        .EXAMPLE
        Get-VCFCertificateAuthority
        This example shows how to get the certificate authority configuration from the connected SDDC Manager

        .EXAMPLE
        Get-VCFCertificateAuthority | ConvertTo-Json
        This example shows how to get the certificate authority configuration from the connected SDDC Manager
        and output to Json format

        .EXAMPLE
        Get-VCFCertificateAuthority -caType Microsoft
        This example shows how to get the certificate authority configuration for a Microsoft Certificate Authority from the
        connected SDDC Manager
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateSet("OpenSSL", "Microsoft")] [String] $caType
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ($PsBoundParameters.ContainsKey("caType")) {
            $uri = "https://$sddcManager/v1/certificate-authorities/$caType"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
        else {
            $uri = "https://$sddcManager/v1/certificate-authorities"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFCertificateAuthority

Function Remove-VCFCertificateAuthority {
    <#
        .SYNOPSIS
        Deletes certificate authority configuration

        .DESCRIPTION
        The Remove-VCFCertificateAuthority cmdlet removes the certificate authority configuration from the connected SDDC Manager

        .EXAMPLE
        Remove-VCFCertificateAuthority
        This example removes the Micosoft certificate authority configuration from the connected SDDC Manager
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateSet("OpenSSL", "Microsoft")] [String] $caType
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/certificate-authorities/$caType"
        $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFCertificateAuthority

Function Set-VCFMicrosoftCA {
    <#
        .SYNOPSIS
        Configures a Microsoft Certificate Authority

        .DESCRIPTION
        Configures the Microsoft Certificate Authorty on the connected SDDC Manager

        .EXAMPLE
        Set-VCFMicrosoftCA -serverUrl "https://rpl-dc01.rainpole.io/certsrv" -username Administrator -password "VMw@re1!" -templateName VMware
        This example shows how to configure a Microsoft certificate authority on the connected SDDC Manager
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$serverUrl,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$username,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$password,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$templateName
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $json = '{"microsoftCertificateAuthoritySpec": {"secret": "' + $password + '","serverUrl": "' + $serverUrl + '","username": "' + $username + '","templateName": "' + $templateName + '"}}'
        $uri = "https://$sddcManager/v1/certificate-authorities"
        Invoke-RestMethod -Method PUT -URI $uri -ContentType application/json -headers $headers -body $json # No response from API
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFMicrosoftCA

Function Set-VCFOpenSSLCA {
    <#
        .SYNOPSIS
        Configures the OpenSSL Certificate Authority

        .DESCRIPTION
        Configures the OpenSSL Certificate Authorty on the connected SDDC Manager

        .EXAMPLE
        Set-VCFOpenSSLCA -commonName sddcManager -organization Rainpole -organizationUnit Support -locality "Palo Alto" -state CA -country US
        This example shows how to configure a Microsoft certificate authority on the connected SDDC Manager
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$commonName,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$organization,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$organizationUnit,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$locality,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$state,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$country
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $json = '{"openSSLCertificateAuthoritySpec": {"commonName": "' + $commonName + '","organization": "' + $organization + '","organizationUnit": "' + $organizationUnit + '","locality": "' + $locality + '","state": "' + $state + '","country": "' + $country + '"}}'
        $uri = "https://$sddcManager/v1/certificate-authorities"
        Invoke-RestMethod -Method PUT -URI $uri -ContentType application/json -headers $headers -body $json # No response from API
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFOpenSSLCA

Function Get-VCFCertificateCSR {
    <#
        .SYNOPSIS
        Get available CSR(s)

        .DESCRIPTION
        The Get-VCFCertificateCSR cmdlet gets the available CSRs that have been created on SDDC Manager

        .EXAMPLE
        Get-VCFCertificateCSR -domainName sfo-m01
        This example gets a list of CSRs and displays the output

        .EXAMPLE
        Get-VCFCertificateCSR -domainName sfo-m01 | ConvertTo-Json
        This example gets a list of CSRs and displays them in JSON format
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainName
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/domains/$domainName/csrs"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.elements
    }
    Catch {
        ResponseException -object $_
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
        Request-VCFCertificateCSR -domainName MGMT -json .\requestCsrSpec.json
        This example requests the generation of the CSR based on the entries within the requestCsrSpec.json file for resources within
        the domain called MGMT
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainName
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/domains/$domainName/csrs"
        $response = Invoke-RestMethod -Method PUT -URI $uri -headers $headers -ContentType application/json -body $jsonBody
        $response
    }
    Catch {
        ResponseException -object $_
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
        Get-VCFCertificate -domainName sfo-m01
        This example gets a list of certificates that have been generated

        .EXAMPLE
        Get-VCFCertificate -domainName sfo-m01 | ConvertTo-Json
        This example gets a list of certificates and displays them in JSON format

        .EXAMPLE
        Get-VCFCertificate -domainName sfo-m01 | Select issuedTo
        This example gets a list of endpoint names where certificates have been issued

        .EXAMPLE
        Get-VCFCertificate -domainName sfo-m01 -resources
        This example gets the certificates of all resources in the domain
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainName,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$resources
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ($PsBoundParameters.ContainsKey("resources")) {
            $uri = "https://$sddcManager/v1/domains/$domainName/resource-certificates"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
        else {
            $uri = "https://$sddcManager/v1/domains/$domainName/certificates"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
    }
    Catch {
        ResponseException -object $_
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
        Request-VCFCertificate -domainName MGMT -json .\requestCertificateSpec.json
        This example requests the generation of the Certificates based on the entries within the requestCertificateSpec.json file
        for resources within the domain called MGMT
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainName
    )

    if ($PsBoundParameters.ContainsKey("json")) {
	    Try {
            $jsonBody = validateJsonInput -json $json
            createHeader # Calls createHeader function to set Accept & Authorization
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            $uri = "https://$sddcManager/v1/domains/$domainName/certificates"
            $response = Invoke-RestMethod -Method PUT -URI $uri -headers $headers -ContentType application/json -body $jsonBody
            $response
        }
        Catch {
            ResponseException -object $_
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
        Set-VCFCertificate -domainName MGMT -json .\updateCertificateSpec.json
        This example replaces the Certificates based on the entries within the requestCertificateSpec.json file
        for resources within the domain called MGMT
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainName
    )

    if ($PsBoundParameters.ContainsKey("json")) {
	    Try {
            $jsonBody = validateJsonInput -json $json
            createHeader # Calls createHeader function to set Accept & Authorization
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            $uri = "https://$sddcManager/v1/domains/$domainName/certificates"
            $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers -ContentType application/json -body $jsonBody
            $response
        }
        Catch {
            ResponseException -object $_
        }
    }
}
Export-ModuleMember -Function Set-VCFCertificate

#EndRegion APIs for managing Certificates


#Region APIs for managing Clusters

Function Get-VCFCluster {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager & retrieves a list of clusters.

        .DESCRIPTION
        The Get-VCFCluster cmdlet connects to the specified SDDC Manager & retrieves a list of clusters.

        .EXAMPLE
        Get-VCFCluster
        This example shows how to get a list of all clusters

        .EXAMPLE
        Get-VCFCluster -name wld01-cl01
        This example shows how to get a cluster by name

        .EXAMPLE
        Get-VCFCluster -id 8423f92e-e4b9-46e7-92f7-befce4755ba2
        This example shows how to get a cluster by id
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$name,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    createHeader # Calls createHeader function to set Accept & Authorization
    checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
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
            $response.elements | Where-Object { $_.name -eq $name }
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFCluster

Function New-VCFCluster {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and creates a cluster

        .DESCRIPTION
        The New-VCFCluster cmdlet connects to the specified SDDC Manager and creates a cluster in a specified workload domains

        .EXAMPLE
        New-VCFCluster -json .\WorkloadDomain\addClusterSpec.json
        This example shows how to create a cluster in a Workload Domain from a json spec
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        # Validate the provided JSON input specification file
        $response = Validate-VCFClusterSpec -json $jsonBody
        # the validation API does not currently support polling with a task ID
        Start-Sleep 5
        # Submit the job only if the JSON validation task finished with executionStatus=COMPLETED & resultStatus=SUCCEEDED
        if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
            Try {
                Write-Output "Task validation completed successfully, invoking cluster task on SDDC Manager"
                $uri = "https://$sddcManager/v1/clusters"
                $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $jsonBody
                $response
            }
            Catch {
                ResponseException -object $_
            }
        }
        else {
            Write-Error "The validation task commpleted the run with the following problems: $($response.validationChecks.errorResponse.message)"
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFCluster

Function Set-VCFCluster {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager & expands or compacts a cluster.

        .DESCRIPTION
        The Set-VCFCluster cmdlet connects to the specified SDDC Manager & expands or compacts a cluster by adding or
        removing a host(s). A cluster can also be marked for deletion

        .EXAMPLE
        Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 -json .\Cluster\clusterExpansionSpec.json
        This example shows how to expand a cluster by adding a host(s)

        .EXAMPLE
        Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 -json .\Cluster\clusterCompactionSpec.json
        This example shows how to compact a cluster by removing a host(s)

        .EXAMPLE
        Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 -markForDeletion
        This example shows how to mark a cluster for deletion
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$markForDeletion
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ( -not $PsBoundParameters.ContainsKey("json") -and ( -not $PsBoundParameters.ContainsKey("markForDeletion"))) {
            Throw "You must include either -json or -markForDeletion"
        }
        
            $jsonBody = validateJsonInput -json $json   # validate input file and format
            $response = Validate-VCFUpdateClusterSpec -clusterid $id -json $jsonBody # validate the JSON provided meets the cluster specifications format
            # the validation API does not currently support polling with a task ID
            Start-Sleep 5
            # Submit the job only if the JSON validation task finished with executionStatus=COMPLETED & resultStatus=SUCCEEDED
            if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
                Try {
                    Write-Output "`Task validation completed successfully. Invoking cluster task on SDDC Manager"
                    $uri = "https://$sddcManager/v1/clusters/$id/"
                    $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers -ContentType application/json -body $jsonBody
                    $response
                }
                Catch {
                    ResponseException -object $_
                }
            }
            else {
                Write-Error "The validation task commpleted the run with the following problems: $($response.validationChecks.errorResponse.message)"
            }
        
        if ($PsBoundParameters.ContainsKey("markForDeletion") -and ($PsBoundParameters.ContainsKey("id"))) {
            $jsonBody = '{"markForDeletion": true}'
            $uri = "https://$sddcManager/v1/clusters/$id/"
            $response = Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $jsonBody
        }
    }
    Catch {
        ResponseException -object $_
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
        Remove-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1
        This example shows how to delete a cluster
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    createHeader # Calls createHeader function to set Accept & Authorization
    checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
    Try {
        $uri = "https://$sddcManager/v1/clusters/$id"
        $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFCluster

Function Get-VCFClusterValidation {
    <#
        .SYNOPSIS
        Get the status of the validations for cluster deployment

        .DESCRIPTION
        The Get-VCFClusterValidation cmdlet returns the status of a validation of the json

        .EXAMPLE
        Get-VCFClusterValidation -id 001235d8-3e40-4a5a-8a89-09985dac1434
        This example shows how to get the cluster validation task based on the id
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/clusters/validations/$id"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFClusterValidation

#EndRegion APIs for managing Clusters


#Region APIs for managing Credentials

Function Get-VCFCredential {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and retrieves a list of credentials.
        Supported resource types are: VCENTER, ESXI, NSXT_MANAGER, NSXT_EDGE, BACKUP
        Please note: if you are requesting credentials by resource type then the resource name parameter (if
        passed) will be ignored (they are mutually exclusive)

        .DESCRIPTION
        The Get-VCFCredential cmdlet connects to the specified SDDC Manager and retrieves a list of credentials.
        Authenticated user must have ADMIN role.

        .EXAMPLE
        Get-VCFCredential
        This example shows how to get a list of credentials

        .EXAMPLE
        Get-VCFCredential -resourceType VCENTER
        This example shows how to get a list of VCENTER credentials

        .EXAMPLE
        Get-VCFCredential -resourceName sfo01-m01-esx01.sfo.rainpole.io
        This example shows how to get the credential for a specific resourceName (FQDN)

        .EXAMPLE
        Get-VCFCredential -id 3c4acbd6-34e5-4281-ad19-a49cb7a5a275
        This example shows how to get the credential using the id
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$resourceName,
        [Parameter (Mandatory = $false)] [ValidateSet("VCENTER", "PSC", "ESXI", "BACKUP", "NSXT_MANAGER", "NSXT_EDGE", "VRSLCM", "WSA", "VROPS", "VRLI", "VRA")] [ValidateNotNullOrEmpty()] [String]$resourceType,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ($PsBoundParameters.ContainsKey("resourceName")) {
            $uri = "https://$sddcManager/v1/credentials?resourceName=$resourceName"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
        elseif ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/credentials/$id"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
        # if requesting credential by type then name is ignored (mutually exclusive)
        elseif ($PsBoundParameters.ContainsKey("resourceType") ) {
            $uri = "https://$sddcManager/v1/credentials?resourceType=$resourceType"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
        else {
            $uri = "https://$sddcManager/v1/credentials"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
    }
    Catch {
        ResponseException -object $_
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
        Set-VCFCredential -json .\Credential\updateCredentialSpec.json
        This example shows how to update a credential using a json spec
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )
    
    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/credentials"
        $response = Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $jsonBody
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFCredential

Function Get-VCFCredentialTask {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and retrieves a list of credential tasks in reverse chronological order.

        .DESCRIPTION
        The Get-VCFCredentialTask cmdlet connects to the specified SDDC Manager and retrieves a list of
        credential tasks in reverse chronological order.

        .EXAMPLE
        Get-VCFCredentialTask
        This example shows how to get a list of all credentials tasks

        .EXAMPLE
        Get-VCFCredentialTask -id 7534d35d-98fb-43de-bcf7-2776beb6fcc3
        This example shows how to get the credential tasks for a specific task id

        .EXAMPLE
        Get-VCFCredentialTask -id 7534d35d-98fb-43de-bcf7-2776beb6fcc3 -resourceCredentials
        This example shows how to get resource credentials (for e.g. ESXI) for a credential task id

        .EXAMPLE
        Get-VCFCredentialTask -status SUCCESSFUL
        This example shows how to get all tasks with a status of SUCCESSFUL
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$resourceCredentials,
        [Parameter (Mandatory = $false)] [ValidateSet("SUCCESSFUL", "FAILED", "USER_CANCELLED")] [String]$status
        
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/credentials/tasks/$id"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
        elseif ($PsBoundParameters.ContainsKey("id") -and ($PsBoundParameters.ContainsKey("resourceCredentials"))) {
            $uri = "https://$sddcManager/v1/credentials/tasks/$id/resource-credentials"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
        elseif ($PsBoundParameters.ContainsKey("status")) {
            $uri = "https://$sddcManager/v1/credentials/tasks"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements | Where-Object { $_.status -eq $status }
        }
        elseif ( -not $PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/credentials/tasks"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFCredentialTask

Function Stop-VCFCredentialTask {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and cancels a failed update or rotate passwords task.

        .DESCRIPTION
        The Stop-VCFCredentialTask cmdlet connects to the specified SDDC Manager and cancles a failed update or rotate passwords task.

        .EXAMPLE
        Stop-VCFCredentialTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d
        This example shows how to cancel a failed rotate or update password task.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    if ($PsBoundParameters.ContainsKey("id")) {
        $uri = "https://$sddcManager/v1/credentials/tasks/$id"
    }
    else {
        Throw "task id to be cancelled is not provided"
    }
    createHeader # Calls createHeader function to set Accept & Authorization
    checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
    Try {
        $response = Invoke-RestMethod -Method DELETE -URI $uri -ContentType application/json -headers $headers
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Stop-VCFCredentialTask

Function Restart-VCFCredentialTask {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and retry a failed rotate/update passwords task

        .DESCRIPTION
        The Restart-VCFCredentialTask cmdlet connects to the specified SDDC Manager and retry a failed rotate/update password task

        .EXAMPLE
        Restart-VCFCredentialTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d -json .\Credential\updateCredentialSpec.json
        This example shows how to update passwords of a resource type using a json spec
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        $uri = "https://$sddcManager/v1/credentials/tasks/$id"
    }
    Catch {
        Throw "Task id not provided"
    }
    createHeader # Calls createHeader function to set Accept & Authorization
    checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
    Try {
        $response = Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $jsonBody
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Restart-VCFCredentialTask

#EndRegion APIs for managing Credentials


#Region APIs for managing Depot Settings

Function Get-VCFDepotCredential {
    <#
        .SYNOPSIS
        Get Depot Settings

        .DESCRIPTION
        Retrieves the configuration for the depot of the connected SDDC Manager

        .EXAMPLE
        Get-VCFDepotCredential
        This example shows credentials that have been configured for the depot.
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/system/settings/depot"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.vmwareAccount
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFDepotCredential

Function Set-VCFDepotCredential {
    <#
        .SYNOPSIS
        Update the Depot Settings

        .DESCRIPTION
        Update the configuration for the depot of the connected SDDC Manager

        .EXAMPLE
        Set-VCFDepotCredential -username "user@yourdomain.com" -password "VMware1!"
        This example sets the credentials that have been configured for the depot.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$username,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$password
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/system/settings/depot"
        if ( -not $PsBoundParameters.ContainsKey("username") -and ( -not $PsBoundParameters.ContainsKey("password"))) {
            Throw "You must enter a username and password"
        }
        $ConfigJson = '{"vmwareAccount": {"username": "' + $username + '","password": "' + $password + '"}}'
        $response = Invoke-RestMethod -Method PUT -URI $uri -ContentType application/json -headers $headers -body $ConfigJson
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFDepotCredential

#EndRegion APIs for managing Depot Settings


#Region APIs for managing Domains

Function Get-VCFWorkloadDomain {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager & retrieves a list of workload domains.

        .DESCRIPTION
        The Get-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager & retrieves a list of workload domains.

        .EXAMPLE
        Get-VCFWorkloadDomain
        This example shows how to get a list of Workload Domains

        .EXAMPLE
        Get-VCFWorkloadDomain -name WLD01
        This example shows how to get a Workload Domain by name

        .EXAMPLE
        Get-VCFWorkloadDomain -id 8423f92e-e4b9-46e7-92f7-befce4755ba2
        This example shows how to get a Workload Domain by id

        .EXAMPLE
        Get-VCFWorkloadDomain -id 8423f92e-e4b9-46e7-92f7-befce4755ba2 -endpoints | ConvertTo-Json
        This example shows how to get endpoints of a Workload Domain by its id and displays the output in Json format
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$name,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$endpoints
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ($PsBoundParameters.ContainsKey("name")) {
            $uri = "https://$sddcManager/v1/domains"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements | Where-Object { $_.name -eq $name }
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
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFWorkloadDomain

Function New-VCFWorkloadDomain {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager & creates a workload domain.

        .DESCRIPTION
        The New-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager & creates a workload domain.

        .EXAMPLE
        New-VCFWorkloadDomain -json .\WorkloadDomain\workloadDomainSpec.json
        This example shows how to create a Workload Domain from a json spec
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json        
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $response = Validate-WorkloadDomainSpec -json $jsonBody # Validate the provided JSON input specification file # the validation API does not currently support polling with a task ID
        Start-Sleep 5
        # Submit the job only if the JSON validation task completed with executionStatus=COMPLETED & resultStatus=SUCCEEDED
        if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
            Write-Output "Task validation completed successfully. Invoking Workload Domain Creation on SDDC Manager"
            $uri = "https://$sddcManager/v1/domains"
            $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $jsonBody
            Return $response
        }
        else {
            Write-Error "The validation task commpleted the run with the following problems:"
            Write-Error $response.validationChecks.errorResponse.message
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFWorkloadDomain

Function Set-VCFWorkloadDomain {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager & marks a workload domain for deletion.

        .DESCRIPTION
        Before a workload domain can be deleted it must first be marked for deletion.
        The Set-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager & marks a workload domain for deletion.

        .EXAMPLE
        Set-VCFWorkloadDomain -id fbdcf199-c086-43aa-9071-5d53b5c5b99d
        This example shows how to mark a workload domain for deletion
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    createHeader # Calls createHeader function to set Accept & Authorization
    checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
    Try {
        $uri = "https://$sddcManager/v1/domains/$id"
        $body = '{"markForDeletion": true}'
        Invoke-RestMethod -Method PATCH -URI $uri -ContentType application/json -headers $headers -body $body # This API does not return a response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFWorkloadDomain

Function Remove-VCFWorkloadDomain {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager & deletes a workload domain.

        .DESCRIPTION
        Before a workload domain can be deleted it must first be marked for deletion. See Set-VCFWorkloadDomain
        The Remove-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager & deletes a workload domain.

        .EXAMPLE
        Remove-VCFWorkloadDomain -id fbdcf199-c086-43aa-9071-5d53b5c5b99d
        This example shows how to delete a workload domain
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    createHeader # Calls createHeader function to set Accept & Authorization
    checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
    Try {
        $uri = "https://$sddcManager/v1/domains/$id"
        $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFWorkloadDomain

#EndRegion APIs for managing Domains


#Region APIs for managing Federation

Function Get-VCFFederation {
    <#
        .SYNOPSIS
        Get information on existing Federation

        .DESCRIPTION
        The Get-VCFFederation cmdlet gets the complete information about the existing VCF Federation

        .EXAMPLE
        Get-VCFFederation
        This example list all details concerning the VCF Federation

        .EXAMPLE
        Get-VCFFederation | ConvertTo-Json
        This example list all details concerning the VCF Federation and outputs them in Json format
    #>

    Try {
        $vcfVersion = ((Get-VCFManager).version -Split ('\.\d{1}\-\d{8}')) -split '\s+' -match '\S'
        if ($vcfVersion -lt "4.4.0") {
            createHeader # Calls createHeader function to set Accept & Authorization
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            $uri = "https://$sddcManager/v1/sddc-federation"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
        else {
            Write-Warning "Multi-Instance Management has been deprecated in VMware Cloud Foundation v4.4.0 and later, this API is no longer supported"
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFFederation

Function Set-VCFFederation {
    <#
        .SYNOPSIS
        Bootstrap a VMware Cloud Foundation to form a federation

        .DESCRIPTION
        The Set-VCFFederation cmdlet bootstraps the creation of a federation in VCF

        .EXAMPLE
        Set-VCFFederation -json $jsonSpec
        This example shows how to create a federation using a variable

        .EXAMPLE
        Set-VCFFederation -json (Get-Content -Raw .\federationSpec.json)
        This example shows how to create a federation using a JSON file
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )
    
    Try {
        $vcfVersion = ((Get-VCFManager).version -Split ('\.\d{1}\-\d{8}')) -split '\s+' -match '\S'
        if ($vcfVersion -lt "4.4.0") {
            $jsonBody = validateJsonInput -json $json
            createHeader # Calls createHeader function to set Accept & Authorization
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            $uri = "https://$sddcManager/v1/sddc-federation"
            $response = Invoke-RestMethod -Method PUT -URI $uri -headers $headers -ContentType application/json -body $jsonBody
            $response
        }
        else {
            Write-Warning "Multi-Instance Management has been deprecated in VMware Cloud Foundation v4.4.0 and later, this API is no longer supported"
        }
    }
    Catch {
        ResponseException -object $_
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
        Remove-VCFFederation
        This example demonstrates how to dismantle the VCF Federation
    #>

    
    Try {
        $vcfVersion = ((Get-VCFManager).version -Split ('\.\d{1}\-\d{8}')) -split '\s+' -match '\S'
        if ($vcfVersion -lt "4.4.0") {
            createHeader # Calls createHeader function to set Accept & Authorization
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            $uri = "https://$sddcManager/v1/sddc-federation"
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
        else {
            Write-Warning "Multi-Instance Management has been deprecated in VMware Cloud Foundation v4.4.0 and later, this API is no longer supported"
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFFederation

#EndRegion APIs for managing Federation


#Region APIs for managing Hosts

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
        Get-VCFHost
        This example shows how to get all hosts regardless of status

        .EXAMPLE
        Get-VCFHost -Status ASSIGNED
        This example shows how to get all hosts with a specific status

        .EXAMPLE
        Get-VCFHost -id edc4f372-aab5-4906-b6d8-9b96d3113304
        This example shows how to get a host by id

        .EXAMPLE
        Get-VCFHost -fqdn sfo01-m01-esx01.sfo.rainpole.io
        This example shows how to get a host by fqdn
    #>

    [CmdletBinding(DefaultParametersetname = "Default")]
    Param (
        [Parameter (Mandatory = $false, ParameterSetName = "fqdn")] [ValidateNotNullOrEmpty()] [String]$fqdn,
        [Parameter (Mandatory = $false, ParameterSetName = "status")] [ValidateSet('ASSIGNED', 'UNASSIGNED_USEABLE', 'UNASSIGNED_UNUSEABLE', IgnoreCase = $false)] [String]$Status,
        [Parameter (Mandatory = $false, ParameterSetName = "id")] [ValidateNotNullOrEmpty()] [String]$id
    )

    createHeader # Calls createHeader function to set Accept & Authorization
    checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
    Try {

        $uri = "https://$sddcManager/v1/hosts"

        Switch ( $PSCmdlet.ParameterSetName ) {
            "id" {
                #Add id to uri
                $uri += "/$id"
            }
            "status" {
                #Add status to uri
                $uri += "?status=$status"
            }
        }

        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers

        Switch ( $PSCmdlet.ParameterSetName ) {
            "id" {
                #When there is a id, it is directly the result...
                $response
            }
            "fqdn" {
                #When there is a fqdn, search on response
                $response.elements | Where-Object { $_.fqdn -eq $fqdn }
            }
            Default {
                $response.elements
            }
        }

    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFHost

Function New-VCFCommissionedHost {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and commissions a list of hosts

        .DESCRIPTION
        The New-VCFCommissionedHost cmdlet connects to the specified SDDC Manager and commissions a list of hosts
        Host list spec is provided in a JSON file.

        .EXAMPLE
        New-VCFCommissionedHost -json .\Host\commissionHosts\commissionHostSpec.json
        This example shows how to commission a list of hosts based on the details provided in the JSON file

        .EXAMPLE
        New-VCFCommissionedHost -json .\Host\commissionHosts\commissionHostSpec.json -validate
        This example shows how to validate the JSON spec before starting the workflow
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$validate
    )

    if ($MyInvocation.InvocationName -eq "Commission-VCFHost") { Write-Warning "Commission-VCFHost is deprecated and will be removed in a future release of PowerVCF. Automatically redirecting to New-VCFCommissionedHost. Please refactor to New-VCFCommissionedHost at earliest opportunity." }

    Try {
        $jsonBody = validateJsonInput -json $json        
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ( -Not $PsBoundParameters.ContainsKey("validate")) {
            $response = Validate-CommissionHostSpec -json $jsonBody # Validate the provided JSON input specification file
            $taskId = $response.id # Get the task id from the validation function
            Do {
                # Keep checking until executionStatus is not IN_PROGRESS
                $uri = "https://$sddcManager/v1/hosts/validations/$taskId"
                $response = Invoke-RestMethod -Method GET -URI $uri -Headers $headers -ContentType application/json
            }
            While ($response.executionStatus -eq "IN_PROGRESS")
            # Submit the commissiong job only if the JSON validation task finished with executionStatus=COMPLETED & resultStatus=SUCCEEDED
            if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
                Write-Output "Task validation completed successfully. Invoking host(s) commissioning on SDDC Manager"
                $uri = "https://$sddcManager/v1/hosts/"
                $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $jsonBody
                Return $response
            }
            else {
                Write-Error "The validation task commpleted the run with the following problems: $($response.validationChecks.errorResponse.message)"
            }
        }
        elseif ($PsBoundParameters.ContainsKey("validate")) {
            $response = Validate-CommissionHostSpec -json $jsonBody # Validate the provided JSON input specification file
            $taskId = $response.id # Get the task id from the validation function
            Do {
                # Keep checking until executionStatus is not IN_PROGRESS
                $uri = "https://$sddcManager/v1/hosts/validations/$taskId"
                $response = Invoke-RestMethod -Method GET -URI $uri -Headers $headers -ContentType application/json
            }
            While ($response.executionStatus -eq "IN_PROGRESS")
            if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
                Write-Output "Task validation completed successfully"
                Return $response
            }
            else {
                Write-Error "`n The validation task commpleted the run with the following problems: $($response.validationChecks.errorResponse.message)"
            }
        }
    }
    Catch {
        ResponseException -object $_
    }
}
New-Alias -name Commission-VCFHost -Value New-VCFCommissionedHost
Export-ModuleMember -Alias Commission-VCFHost -Function New-VCFCommissionedHost

Function Remove-VCFCommissionedHost {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and decommissions a list of hosts. Host list is provided in a JSON file.

        .DESCRIPTION
        The Remove-VCFCommissionedHost cmdlet connects to the specified SDDC Manager and decommissions a list of hosts.

        .EXAMPLE
        Remove-VCFCommissionedHost -json .\Host\decommissionHostSpec.json
        This example shows how to decommission a set of hosts based on the details provided in the JSON file.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    If ($MyInvocation.InvocationName -eq "Decommission-VCFHost") { Write-Warning "Decommission-VCFHost is deprecated and will be removed in a future release of PowerVCF. Automatically redirecting to Remove-VCFCommissionedHost. Please refactor to Remove-VCFCommissionedHost at earliest opportunity." }

    Try {
        $jsonBody = validateJsonInput -json $json        
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/hosts"
        $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers -ContentType application/json -body $jsonBody
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
New-Alias -name Decommission-VCFHost -value Remove-VCFCommissionedHost
Export-ModuleMember -Alias Decommission-VCFHost -Function Remove-VCFCommissionedHost

#EndRegion APIs for managing Hosts


#Region APIs for managing License Keys

Function Get-VCFLicenseKey {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and retrieves a list of License keys

        .DESCRIPTION
        The Get-VCFLicenseKey cmdlet connects to the specified SDDC Manager and retrieves a list of License keys

        .EXAMPLE
        Get-VCFLicenseKey
        This example shows how to get a list of all License keys

        .EXAMPLE
        Get-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
        This example shows how to get a specified License key

        .EXAMPLE
        Get-VCFLicenseKey -productType VCENTER
        This example shows how to get a License Key by product type
        Supported Product Types: SDDC_MANAGER, VCENTER, VSAN, ESXI, NSXT

        .EXAMPLE
        Get-VCFLicenseKey -status EXPIRED
        This example shows how to get a License by status
        Supported Status Types: EXPIRED, ACTIVE, NEVER_EXPIRES
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$key,
        [Parameter (Mandatory = $false)] [ValidateSet("VCENTER", "VSAN", "ESXI", "NSXT", "SDDC_MANAGER")] [String]$productType,
        [Parameter (Mandatory = $false)] [ValidateSet("EXPIRED", "ACTIVE", "NEVER_EXPIRES")] [String]$status
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
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
        ResponseException -object $_
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
        New-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA" -productType VCENTER -description "vCenter License"
        This example shows how to add a new License key to SDDC Manager
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$key,
        [Parameter (Mandatory = $true)] [ValidateSet("VCENTER", "VSAN", "ESXI", "WCP", "NSXT", "NSXV","SDDC_MANAGER", "HORIZON_VIEW")] [String]$productType,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$description
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $jsonBody = '{ "key" : "' + $key + '", "productType" : "' + $productType + '", "description" : "' + $description + '" }'
        $uri = "https://$sddcManager/v1/license-keys"
        Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $jsonBody # This API does not return a response
        Get-VCFLicenseKey -key $key
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFLicenseKey

Function Remove-VCFLicenseKey {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and deletes a license key.

        .DESCRIPTION
        The Remove-VCFLicenseKey cmdlet connects to the specified SDDC Manager and deletes a License Key.
        A license Key can only be removed if it is not in use.

        .EXAMPLE
        Remove-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
        This example shows how to delete a License Key
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$key
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/license-keys/$key"
        Invoke-RestMethod -Method DELETE -URI $uri -headers $headers # This API does not return a response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFLicenseKey

#EndRegion APIs for managing License Keys


#Region APIs for managing Members of the Federation

Function Get-VCFFederationMember {
    <#
        .SYNOPSIS
        Gets members of the Federation

        .DESCRIPTION
        Gets the complete information about the existing VCF Federation members.

        .EXAMPLE
        Get-VCFFederationMember
        This example lists all details concerning the VCF Federation members.
    #>
    
    Try {
        $vcfVersion = ((Get-VCFManager).version -Split ('\.\d{1}\-\d{8}')) -split '\s+' -match '\S'
        if ($vcfVersion -lt "4.4.0") {
            createHeader # Calls createHeader function to set Accept & Authorization
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            $uri = "https://$sddcManager/v1/sddc-federation/members"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            if (!$response.federationName) {
                Throw "Failed to get members, no Federation found."
            }
            else {
                $response.memberDetail
            }
        }
        else {
            Write-Warning "Multi-Instance Management has been deprecated in VMware Cloud Foundation v4.4.0 and later, this API is no longer supported"
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFFederationMember

Function New-VCFFederationInvite {
    <#
        .SYNOPSIS
        Invite new member to VCF Federation.

        .DESCRIPTION
        The New-VCFFederationInvite cmdlet creates a new invitation for a member to join the existing VCF Federation.

        .EXAMPLE
        New-VCFFederationInvite -inviteeFqdn lax-vcf01.lax.rainpole.io -inviteeRole MEMBER
        This example demonstrates how to create an invitation for a specified VCF Manager from the Federation controller.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$inviteeFqdn,
        [Parameter (Mandatory = $true)] [ValidateSet("MEMBER", "CONTROLLER")] [String]$inviteeRole
    )

    Try {
        $vcfVersion = ((Get-VCFManager).version -Split ('\.\d{1}\-\d{8}')) -split '\s+' -match '\S'
        if ($vcfVersion -lt "4.4.0") {
            createHeader # Calls createHeader function to set Accept & Authorization
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            $uri = "https://$sddcManager/v1/sddc-federation/membership-tokens"
            $sddcMemberRole = Get-VCFFederationMember
            if ($sddcMemberRole.memberDetail.role -ne "CONTROLLER" -and $sddcMemberRole.memberDetail.fqdn -ne $sddcManager) {
                Throw "$sddcManager is not the Federation controller. Invitatons to join Federation can only be sent from the Federation controller."
            }
            else {
                $inviteeDetails = @{
                    inviteeRole = $inviteeRole
                    inviteeFqdn = $inviteeFqdn

                }
                $ConfigJson = $inviteeDetails | ConvertTo-Json
                $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -body $ConfigJson -ContentType 'application/json'
                $response
            }
        }
        else {
            Write-Warning "Multi-Instance Management has been deprecated in VMware Cloud Foundation v4.4.0 and later, this API is no longer supported"
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFFederationInvite

Function Join-VCFFederation {
    <#
        .SYNOPSIS
        Join an VMware Cloud Foundation instance to a Federation

        .DESCRIPTION
        The Join-VCFFederation cmdlet joins a VMware Cloud Foundation instance an existing VMware Cloud Foundation
        Federation (Multi-Instance configuration).

        .EXAMPLE
        Join-VCFFederation -json .\joinVCFFederationSpec.json
        This example demonstrates how to join an VCF Federation by referencing config info in JSON file.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $vcfVersion = ((Get-VCFManager).version -Split ('\.\d{1}\-\d{8}')) -split '\s+' -match '\S'
        if ($vcfVersion -lt "4.4.0") {
            if (!(Test-Path $json)) {
                Throw "JSON File Not Found"
            }
            else {
                $ConfigJson = (Get-Content -Raw $json) # Reads the joinSVCFFederation json file contents into the $ConfigJson variable
                createHeader # Calls createHeader function to set Accept & Authorization
                checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
                $uri = "https://$sddcManager/v1/sddc-federation/members"
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
        }
        else {
            Write-Warning "Multi-Instance Management has been deprecated in VMware Cloud Foundation v4.4.0 and later, this API is no longer supported"
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Join-VCFFederation

#EndRegion APIs for managing Members of the Federation


#Region APIs for managing NSX-T Clusters

Function Get-VCFNsxtCluster {
    <#
        .SYNOPSIS
        Gets a list of NSX-T Clusters

        .DESCRIPTION
        The Get-VCFNsxtCluster cmdlet retrieves a list of NSX-T Clusters managed by the connected SDDC Manager

        .EXAMPLE
        Get-VCFNsxtCluster
        This example shows how to get the list of NSX-T Clusters managed by the connected SDDC Manager

        .EXAMPLE
        Get-VCFNsxtCluster -id d189a789-dbf2-46c0-a2de-107cde9f7d24
        This example shows how to return the details for a specic NSX-T Clusters managed by the connected SDDC Manager
        using the ID

        .EXAMPLE
        Get-VCFNsxtCluster | select vipfqdn
        This example shows how to get the list of NSX-T Clusters managed by the connected SDDC Manager but only return the vipfqdn
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
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
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFNsxtCluster

#EndRegion APIs for managing NSX-T Clusters


#Region APIs for managing Network Pools

Function Get-VCFNetworkPool {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager & retrieves a list of Network Pools.

        .DESCRIPTION
        The Get-VCFNetworkPool cmdlet connects to the specified SDDC Manager & retrieves a list of Network Pools.

        .EXAMPLE
        Get-VCFNetworkPool
        This example shows how to get a list of all Network Pools

        .EXAMPLE
        Get-VCFNetworkPool -name sfo01-networkpool
        This example shows how to get a Network Pool by name

        .EXAMPLE
        Get-VCFNetworkPool -id 40b0b36d-36d6-454c-814b-ba8bf9b383e3
        This example shows how to get a Network Pool by id
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$name,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
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
            $response.elements | Where-Object { $_.name -eq $name }
        }
    }
    Catch {
        ResponseException -object $_
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
        New-VCFNetworkPool -json .\NetworkPool\createNetworkPoolSpec.json
        This example shows how to create a Network Pool
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/network-pools"
        Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $jsonBody
        # This API does not return a response body. Sending GET to validate the Network Pool creation was successful
        $validate = $jsonBody | ConvertFrom-Json
        $poolName = $validate.name
        Get-VCFNetworkPool -name $poolName
    }
    Catch {
        ResponseException -object $_
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
        Remove-VCFNetworkPool -id 7ee7c7d2-5251-4bc9-9f91-4ee8d911511f
        This example shows how to get a Network Pool by id
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/network-pools/$id"
        Invoke-RestMethod -Method DELETE -URI $uri -headers $headers # This API does not return a response
    }
    Catch {
        ResponseException -object $_
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
        Get-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52
        This example shows how to get a list of all networks associated to the network pool based on the id provided

        .EXAMPLE
        Get-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkId c2197368-5b7c-4003-80e5-ff9d3caef795
        This example shows how to get a list of details for a specific network associated to the network pool using ids
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$networkId
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ($PsBoundParameters.ContainsKey("id") -and $PsBoundParameters.ContainsKey("networkId")) {
            $uri = "https://$sddcManager/v1/network-pools/$id/networks/$networkid"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        } else {
            $uri = "https://$sddcManager/v1/network-pools/$id/networks"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
        
    }
    Catch {
        ResponseException -object $_
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
        Add-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkid c2197368-5b7c-4003-80e5-ff9d3caef795 -ipStart 192.168.110.61 -ipEnd 192.168.110.64
        This example shows how create a new IP Pool on the existing network for a given Network Pool
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$networkid,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$ipStart,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$ipEnd
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/network-pools/$id/networks/$networkid/ip-pools"
        $body = '{"end": "' + $ipEnd + '","start": "' + $ipStart + '"}'
        $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $body
        $response
    }
    Catch {
        ResponseException -object $_
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
        Remove-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkid c2197368-5b7c-4003-80e5-ff9d3caef795 -ipStart 192.168.110.61 -ipEnd 192.168.110.64
        This example shows how remove an IP Pool on the existing network for a given Network Pool
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$networkid,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$ipStart,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$ipEnd
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/network-pools/$id/networks/$networkid/ip-pools"
        $body = '{"end": "' + $ipEnd + '","start": "' + $ipStart + '"}'
        $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers -ContentType application/json -body $body
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFNetworkIPPool

#EndRegion APIs for managing Network Pools


#Region APIs for managing NSX-T Edge Clusters

Function Get-VCFEdgeCluster {
    <#
        .SYNOPSIS
        Get the Edge Clusters

        .DESCRIPTION
        The Get-VCFEdgeCluster cmdlet gets a list of NSX-T Edge Clusters

        .EXAMPLE
        Get-VCFEdgeCluster
        This example list all NSX-T Edge Clusters

        .EXAMPLE
        Get-VCFEdgeCluster -id b4e3b2c4-31e8-4816-b1c5-801e848bef09
        This example list the NSX-T Edge Cluster by id
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ( -not $PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/edge-clusters"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/edge-clusters/$id"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFEdgeCluster

Function New-VCFEdgeCluster {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager & creates an NSX-T edge cluster.

        .DESCRIPTION
        The New-VCFEdgeCluster cmdlet connects to the specified SDDC Manager & creates an NSX-T edge cluster.

        .EXAMPLE
        New-VCFEdgeCluster -json .\SampleJSON\EdgeCluster\edgeClusterSpec.json
        This example shows how to create an NSX-T edge cluster from a json spec

        .EXAMPLE
        New-VCFEdgeCluster -json .\SampleJSON\EdgeCluster\edgeClusterSpec.json -validate
        This example shows how to validate the JSON spec for Edge Cluster creation
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$validate
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ( -Not $PsBoundParameters.ContainsKey("validate")) {
            $response = Validate-EdgeClusterSpec -json $jsonBody # Validate the provided JSON input specification file
            $taskId = $response.id # Get the task id from the validation function
            Do {
                # Keep checking until executionStatus is not IN_PROGRESS
                $uri = "https://$sddcManager/v1/edge-clusters/validations/$taskId"
                $response = Invoke-RestMethod -Method GET -URI $uri -Headers $headers -ContentType application/json
            }
            While ($response.executionStatus -eq "IN_PROGRESS")
            # Submit the commissiong job only if the JSON validation task finished with executionStatus=COMPLETED & resultStatus=SUCCEEDED
            if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
                Write-Output "Task validation completed successfully, invoking NSX-T Edge Cluster Creation on SDDC Manager"
                $uri = "https://$sddcManager/v1/edge-clusters"
                $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $jsonBody
                Return $response
            }
            else {
                Write-Error "The validation task commpleted the run with the following problems: $($response.validationChecks.errorResponse.message)"
            }
        }
        elseif ($PsBoundParameters.ContainsKey("validate")) {
            $response = Validate-EdgeClusterSpec -json $jsonBody # Validate the provided JSON input specification file
            $taskId = $response.id # Get the task id from the validation function
            Do {
                # Keep checking until executionStatus is not IN_PROGRESS
                $uri = "https://$sddcManager/v1/edge-clusters/validations/$taskId"
                $response = Invoke-RestMethod -Method GET -URI $uri -Headers $headers -ContentType application/json
            }
            While ($response.executionStatus -eq "IN_PROGRESS")
            if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
                Write-Output "Task validation completed successfully"
                Return $response
            }
            else {
                Write-Error "The validation task commpleted the run with the following problems: $($response.validationChecks.errorResponse.message)"
            }
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFEdgeCluster

#EndRegion APIs for managing NSX-T Edge Clusters


#Region APIs for managing PSCs

Function Get-VCFPSC {
    <#
        .SYNOPSIS
        Get Platform Services Controllers

        .DESCRIPTION
        The Get-VCFPSC cmdlet gets a list of Platform Services Controllers

        .EXAMPLE
        Get-VCFPSC
        This example list all Platform Services Controllers

        .EXAMPLE
        Get-VCFPSC -id b4e3b2c4-31e8-4816-b1c5-801e848bef09
        This example list the Platform Services Controllers by id
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ( -not $PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/pscs"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/pscs/$id"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFPSC

#EndRegion APIs for managing PSCs


#Region APIs for managing Personalities

Function Get-VCFPersonality {
    <#
        .SYNOPSIS
        Get the vSphere Lifecycle Manager personalities

        .DESCRIPTION
        The Get-VCFPersonality cmdlet gets the vSphere Lifecycle Manager personalities which are available via depot access

        .EXAMPLE
        Get-VCFPersonality
        This example list all the vSphere Lifecycle Manager personalities availble in the depot

        .EXAMPLE
        Get-VCFPersonality -id b4e3b2c4-31e8-4816-b1c5-801e848bef09
        This example gets a vSphere Lifecycle Manager personality by ID
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ( -not $PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/personalities"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/personalities/$id"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFPersonality

#EndRegion APIs for managing Personalities


#Region APIs for managing Federation Tasks

Function Get-VCFFederationTask {
    <#
        .SYNOPSIS
        Get task status for Federation operations

        .DESCRIPTION
        The Get-VCFFederationTask cmdlet gets the status of tasks relating to Federation operations

        .EXAMPLE
        Get-VCFFederationTask -id f6f38f6b-da0c-4ef9-9228-9330f3d30279
        This example list all tasks for Federation operations
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        $vcfVersion = ((Get-VCFManager).version -Split ('\.\d{1}\-\d{8}')) -split '\s+' -match '\S'
        if ($vcfVersion -lt "4.4.0") {
            createHeader # Calls createHeader function to set Accept & Authorization
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            $uri = "https://$sddcManager/v1/sddc-federation/tasks/$id"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
        else {
            Write-Warning "Multi-Instance Management has been deprecated in VMware Cloud Foundation v4.4.0 and later, this API is no longer supported"
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFFederationTask

#EndRegion APIs for managing Federation Tasks


#Region APIs for managing SDDC (Cloud Builder)

Function Get-CloudBuilderSDDC {
    <#
        .SYNOPSIS
        Retrieve all SDDCs

        .DESCRIPTION
        The Get-CloudBuilderSDDC cmdlet gets a list of SDDC deployments from Cloud Builder

        .EXAMPLE
        Get-CloudBuilderSDDC
        This example list all SDDC deployments from Cloud Builder

        .EXAMPLE
        Get-CloudBuilderSDDC -id 51cc2d90-13b9-4b62-b443-c1d7c3be0c23
        This example gets the SDDC deployment with a specific ID from Cloud Builder
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createBasicAuthHeader # Calls createBasicAuthHeader Function to basic auth
        if ( -not $PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$cloudBuilder/v1/sddcs"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
        elseif ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$cloudBuilder/v1/sddcs/$id"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-CloudBuilderSDDC

Function Start-CloudBuilderSDDC {
    <#
        .SYNOPSIS
        Create an SDDC

        .DESCRIPTION
        The Start-CloudBuilderSDDC cmdlet starts the deployment based on the SddcSpec.json provided

        .EXAMPLE
        Start-CloudBuilderSDDC -json .\SampleJSON\SDDC\SddcSpec.json
        This example starts the deployment using the SddcSpec.json
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createBasicAuthHeader # Calls createBasicAuthHeader Function to basic auth
        $uri = "https://$cloudBuilder/v1/sddcs"
        $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $jsonBody
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-CloudBuilderSDDC

Function Restart-CloudBuilderSDDC {
    <#
        .SYNOPSIS
        Retry failed SDDC creation

        .DESCRIPTION
        The Restart-CloudBuilderSDDC retries a deployment on Cloud Builder

        .EXAMPLE
        Restart-CloudBuilderSDDC -id bedf19f8-9dfe-4c60-aae4-bca986a65a31
        This example retries a deployment on Cloud Builder based on the ID

        .EXAMPLE
        Restart-CloudBuilderSDDC -id bedf19f8-9dfe-4c60-aae4-bca986a65a31 -json .\SampleJSON\SDDC\SddcSpec.json
        This example retries a deployment on Cloud Builder based on the ID with an updated JSON file
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createBasicAuthHeader # Calls createBasicAuthHeader Function to basic auth
        if ($PsBoundParameters.ContainsKey("id") -and ($PsBoundParameters.ContainsKey("json"))) {
            validateJsonInput # Calls validateJsonInput Function to check the JSON file provided exists
            $uri = "https://$cloudBuilder/v1/sddcs/$id"
            $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers -ContentType application/json -body $jsonBody
            $response
        }
        elseif ($PsBoundParameters.ContainsKey("id") -and (-not $PsBoundParameters.ContainsKey("json"))) {
            $uri = "https://$cloudBuilder/v1/sddcs/$id"
            $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers
            $response
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Restart-CloudBuilderSDDC

Function Get-CloudBuilderSDDCValidation {
    <#
        .SYNOPSIS
        Get all SDDC specification validations

        .DESCRIPTION
        The Get-CloudBuilderSDDCValidation cmdlet gets a list of SDDC validations from Cloud Builder

        .EXAMPLE
        Get-CloudBuilderSDDCValidation
        This example list all SDDC validations from Cloud Builder

        .EXAMPLE
        Get-CloudBuilderSDDCValidation -id 1ff80635-b878-441a-9e23-9369e1f6e5a3
        This example gets the SDDC validation with a specific ID from Cloud Builder
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createBasicAuthHeader # Calls createBasicAuthHeader Function to basic auth
        if ( -not $PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$cloudBuilder/v1/sddcs/validations"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
        elseif ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$cloudBuilder/v1/sddcs/validations/$id"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-CloudBuilderSDDCValidation

Function Start-CloudBuilderSDDCValidation {
    <#
        .SYNOPSIS
        Validate SDDC specification before creation

        .DESCRIPTION
        The Start-CloudBuilderSDDCValidation cmdlet performs validation of the SddcSpec.json provided

        .EXAMPLE
        Start-CloudBuilderSDDCValidation -json .\SampleJSON\SDDC\SddcSpec.json
        This example starts the validation of the SddcSpec.json

        .EXAMPLE
        Start-CloudBuilderSDDCValidation -json .\SampleJSON\SDDC\SddcSpec.json -validation LICENSE_KEY_VALIDATION
        This example starts the validation of the License Key items only based on the SddcSpec.json json
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateSet("JSON_SPEC_VALIDATION", "LICENSE_KEY_VALIDATION", "TIME_SYNC_VALIDATION", "NETWORK_IP_POOLS_VALIDATION", "NETWORK_CONFIG_VALIDATION", "MANAGEMENT_NETWORKS_VALIDATION", "ESXI_VERSION_VALIDATION", "ESXI_HOST_READINESS_VALIDATION", "PASSWORDS_VALIDATION", "HOST_IP_DNS_VALIDATION", "CLOUDBUILDER_READY_VALIDATION", "VSAN_AVAILABILITY_VALIDATION", "NSXT_NETWORKS_VALIDATION", "AVN_NETWORKS_VALIDATION", "SECURE_PLATFORM_AUDIT")] [String]$validation
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createBasicAuthHeader # Calls createBasicAuthHeader Function to basic auth
        if (-not $PsBoundParameters.ContainsKey("validation")) {
            $uri = "https://$cloudBuilder/v1/sddcs/validations"
            $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $jsonBody
            $response
        }
        if ($PsBoundParameters.ContainsKey("validation")) {
            $uri = "https://$cloudBuilder/v1/sddcs/validations?name=$validation"
            $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $jsonBody
            $response
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-CloudBuilderSDDCValidation

Function Stop-CloudBuilderSDDCValidation {
    <#
        .SYNOPSIS
        Cancel SDDC specification validation

        .DESCRIPTION
        The Stop-CloudBuilderSDDCValidation cancels a validation in progress on Cloud Builder

        .EXAMPLE
        Stop-CloudBuilderSDDCValidation -id bedf19f8-9dfe-4c60-aae4-bca986a65a31
        This example stops a validation that is running on Cloud Builder based on the ID
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createBasicAuthHeader # Calls createBasicAuthHeader Function to basic auth
        $uri = "https://$cloudBuilder/v1/sddcs/validations/$id"
        $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Stop-CloudBuilderSDDCValidation

Function Restart-CloudBuilderSDDCValidation {
    <#
        .SYNOPSIS
        Retry SDDC validation

        .DESCRIPTION
        The Restart-CloudBuilderSDDCValidation reties a validation on Cloud Builder

        .EXAMPLE
        Restart-CloudBuilderSDDCValidation -id bedf19f8-9dfe-4c60-aae4-bca986a65a31
        This example retries a validation on Cloud Builder based on the ID
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createBasicAuthHeader # Calls createBasicAuthHeader Function to basic auth
        $uri = "https://$cloudBuilder/v1/sddcs/validations/$id"
        $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Restart-CloudBuilderSDDCValidation

#EndRegion APIs for managing SDDC (Cloud Builder)


#Region APIs for managing SOS

Function Get-VCFHealthSummaryTask {
    <#
        .SYNOPSIS
        Get Health Summary tasks

        .DESCRIPTION
        The Get-VCFHealthSummaryTask cmdlet retrieves the Health Summary tasks

        .EXAMPLE
        Get-VCFHealthSummaryTask
        This example gets all Health Summary tasks

        .EXAMPLE
        Get-VCFHealthSummaryTask -id <task_id>
        This example gets the Health Summary task by id
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        $vcfVersion = ((Get-VCFManager).version -Split ('\.\d{1}\-\d{8}')) -split '\s+' -match '\S'
        if ($vcfVersion -ge "4.4.0") {
            createHeader # Calls createHeader function to set Accept & Authorization
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            if ($PsBoundParameters.ContainsKey("id")) {
                $uri = "https://$sddcManager/v1/system/health-summary/$id"
                $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
                $response
            }
            else {
                $uri = "https://$sddcManager/v1/system/health-summary"
                $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
                $response.elements
            }
        }
        else { 
            Write-Warning "API is only valid with VMware Cloud Foundation v4.4.0 or later"
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFHealthSummaryTask

Function Request-VCFHealthSummaryBundle {
    <#
        .SYNOPSIS
        Download Health Summary bundle

        .DESCRIPTION
        The Request-VCFHealthSummaryBundle cmdlet downloads the Health Summary bundle

        .EXAMPLE
        Request-VCFHealthSummaryBundle -id <id>
        This example downloads a Health Summary bundle
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        $vcfVersion = ((Get-VCFManager).version -Split ('\.\d{1}\-\d{8}')) -split '\s+' -match '\S'
        if ($vcfVersion -ge "4.4.0") {
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            $vcfHeaders = @{"Accept" = "application/octet-stream" }
            $vcfHeaders.Add("ContentType", "application/octet-stream")
            $vcfHeaders.Add("Authorization", "Bearer $accessToken")
            $uri = "https://$sddcManager/v1/system/health-summary/$id/data"
            Invoke-RestMethod -Method GET -URI $uri -headers $vcfHeaders -OutFile "health-summary-$id.tar"
        }
        else { 
            Write-Warning "API is only valid with VMware Cloud Foundation v4.4.0 or later"
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Request-VCFHealthSummaryBundle

Function Start-VCFHealthSummary {
    <#
        .SYNOPSIS
        Start Health Summary checks

        .DESCRIPTION
        The Start-VCFHealthSummary cmdlet is used to start the Health Summary checks

        .EXAMPLE
        Start-VCFHealthSummary -json .\SampleJSON\SOS\systemHealthChecks.json
        This example starts the Health Summary checks using the json file
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $vcfVersion = ((Get-VCFManager).version -Split ('\.\d{1}\-\d{8}')) -split '\s+' -match '\S'
        if ($vcfVersion -ge "4.4.0") {
            validateJsonInput # Calls validateJsonInput Function to check the JSON file provided exists
            createHeader # Calls createHeader function to set Accept & Authorization
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            $uri = "https://$sddcManager/v1/system/health-summary"
            $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
            $response
        }
        else { 
            Write-Warning "API is only valid with VMware Cloud Foundation v4.4.0 or later"
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-VCFHealthSummary

Function Get-VCFSupportBundleTask {
    <#
        .SYNOPSIS
        Get Support Bundle tasks

        .DESCRIPTION
        The Get-VCFSupportBundleTask cmdlet retrieves the Support Bundle tasks

        .EXAMPLE
        Get-VCFSupportBundleTask
        This example gets all Support Bundle tasks

        .EXAMPLE
        Get-VCFSupportBundleTask -id <task_id>
        This example gets the Support Bundle task by id
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        $vcfVersion = ((Get-VCFManager).version -Split ('\.\d{1}\-\d{8}')) -split '\s+' -match '\S'
        if ($vcfVersion -ge "4.4.0") {
            createHeader # Calls createHeader function to set Accept & Authorization
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            if ($PsBoundParameters.ContainsKey("id")) {
                $uri = "https://$sddcManager/v1/system/support-bundles/$id"
                $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
                $response
            }
            else {
                $uri = "https://$sddcManager/v1/system/support-bundles"
                $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
                $response.elements
            }
        }
        else { 
            Write-Warning "API is only valid with VMware Cloud Foundation v4.4.0 or later"
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFSupportBundleTask

Function Request-VCFSupportBundle {
    <#
        .SYNOPSIS
        Download the Support Bundle

        .DESCRIPTION
        The Request-VCFSupportBundle cmdlet downloads the Support Bundle

        .EXAMPLE
        Request-VCFSupportBundle -id <id>
        This example downloads the Support Bundle based on the id
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        $vcfVersion = ((Get-VCFManager).version -Split ('\.\d{1}\-\d{8}')) -split '\s+' -match '\S'
        if ($vcfVersion -ge "4.4.0") {
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            $vcfHeaders = @{"Accept" = "application/octet-stream" }
            $vcfHeaders.Add("Authorization", "Bearer $accessToken")
            $uri = "https://$sddcManager/v1/system/support-bundles/$id/data"
            Invoke-RestMethod -Method GET -URI $uri -headers $vcfHeaders -OutFile "support-bundle-$id.tar"
        }
        else { 
            Write-Warning "API is only valid with VMware Cloud Foundation v4.4.0 or later"
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Request-VCFSupportBundle

Function Start-VCFSupportBundle {
    <#
        .SYNOPSIS
        Start Support Bundle generation

        .DESCRIPTION
        The Start-VCFSupportBundle cmdlet is used to start the Support Bundle generation

        .EXAMPLE
        Start-VCFSupportBundle -json .\SampleJSON\SOS\supportBundle.json
        This example starts the Support Bundle generation using the json file
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $vcfVersion = ((Get-VCFManager).version -Split ('\.\d{1}\-\d{8}')) -split '\s+' -match '\S'
        if ($vcfVersion -ge "4.4.0") {
            validateJsonInput # Calls validateJsonInput Function to check the JSON file provided exists
            createHeader # Calls createHeader function to set Accept & Authorization
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            $uri = "https://$sddcManager/v1/system/support-bundles"
            $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
            $response
        }
        else { 
            Write-Warning "API is only valid with VMware Cloud Foundation v4.4.0 or later"
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-VCFSupportBundle

#EndRegion APIs for managing SOS


#Region APIs for managing SDDC Manager

Function Get-VCFManager {
    <#
        .SYNOPSIS
        Get a list of SDDC Managers

        .DESCRIPTION
        The Get-VCFManager cmdlet retrieves a list of SDDC Managers

        .EXAMPLE
        Get-VCFManager
        This example shows how to retrieve a list of SDDC Managers

        .EXAMPLE
        Get-VCFManager -id 60d6b676-47ae-4286-b4fd-287a888fb2d0
        This example shows how to return the details for a specific SDDC Manager based on the unique ID

        .EXAMPLE
        Get-VCFManager -domainId 1a6291f2-ed54-4088-910f-ead57b9f9902
        This example shows how to return the details for a specific SDDC Manager based on a workload domains unique ID
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$domainId
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
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
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFManager

#EndRegion APIs for managing SDDC Manager


#Region APIs for managing System Prechecks

Function Start-VCFSystemPrecheck {
    <#
        .SYNOPSIS
        The Start-VCFSystemPrecheck cmdlet performs system level health checks

        .DESCRIPTION
        The Start-VCFSystemPrecheck cmdlet performs system level health checks and upgrade pre-checks for an upgrade to be successful

        .EXAMPLE
        Start-VCFSystemPrecheck -json .\SystemCheck\precheckVCFSystem.json
        This example shows how to perform system level health check
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/system/prechecks"
        $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $json
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-VCFSystemPrecheck

Function Get-VCFSystemPrecheckTask {
    <#
        .SYNOPSIS
        Get Precheck Task by ID

        .DESCRIPTION
        The Get-VCFSystemPrecheckTask cmdlet performs retrieval of a system precheck task that can be polled and monitored.

        .EXAMPLE
        Get-VCFSystemPrecheckTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d
        This example shows how to retrieve the status of a system level precheck task
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/system/prechecks/tasks/$id"
        $response = Invoke-RestMethod -Method GET -URI $uri -ContentType application/json -headers $headers
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFSystemPrecheckTask

#EndRegion APIs for managing System Prechecks


#Region APIs for managing Tasks

Function Get-VCFTask {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and retrieves a list of tasks.

        .DESCRIPTION
        The Get-VCFTask cmdlet connects to the specified SDDC Manager and retrieves a list of tasks.

        .EXAMPLE
        Get-VCFTask
        This example shows how to get all tasks

        .EXAMPLE
        Get-VCFTask -id 7e1c2eee-3177-4e3b-84db-bfebc83f386a
        This example shows how to get a task by id

        .EXAMPLE
        Get-VCFTask -status SUCCESSFUL
        This example shows how to get all tasks with a status of SUCCESSFUL
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateSet("SUCCESSFUL", "FAILED")] [String]$status
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ( -not $PsBoundParameters.ContainsKey("id") -and ( -not $PsBoundParameters.ContainsKey("status"))) {
            $uri = "https://$sddcManager/v1/tasks/"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/tasks/$id"
            Try {
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            }
            catch {
                if ($_.Exception.Message -eq "The remote server returned an error: (404) Not Found.") {
                    Write-Output "Task ID Not Found"
                }
            }
            $response
        }
        elseif ($PsBoundParameters.ContainsKey("status")) {
            $uri = "https://$sddcManager/v1/tasks/"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements | Where-Object { $_.status -eq $status }
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFTask

Function Restart-VCFTask {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and retries a previously failed task.

        .DESCRIPTION
        The Restart-VCFTask cmdlet connects to the specified SDDC Manager and retries a previously
        failed task using the task id.

        .EXAMPLE
        Restart-VCFTask -id 7e1c2eee-3177-4e3b-84db-bfebc83f386a
        This example retries the task based on the task id
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/tasks/$id"
        $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Restart-VCFTask

#EndRegion APIs for managing Tasks


#Region APIs for managing Access and Refresh Token
Function checkVCFToken {
    if (!$accessToken) {
        Write-Error "API Access Token Required. Request an Access Token by running Request-VCFToken"
        Break
    }
    else {
        $expiryDetails = Get-JWTDetail $accessToken
        if ($expiryDetails.timeToExpiry.Hours -eq 0 -and $expiryDetails.timeToExpiry.Minutes -lt 2) {
            Write-Output "API Access Token Expired. Requesting a new access token with current refresh token"
            $headers = @{"Accept" = "application/json" }
            $uri = "https://$sddcManager/v1/tokens/access-token/refresh"
            $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -body $refreshToken
            $Global:accessToken = $response
        }
    }
}

Function Get-JWTDetail {
    [cmdletbinding()]

    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)] [String]$token
    )

    <#
        .SYNOPSIS
        Decode a JWT Access Token and convert to a PowerShell Object.
        JWT Access Token updated to include the JWT Signature (sig), JWT Token Expiry (expiryDateTime) and JWT Token time to expiry (timeToExpiry).
        Written by Darren Robinson
        https://blog.darrenjrobinson.com
        https://blog.darrenjrobinson.com/jwtdetails-powershell-module-for-decoding-jwt-access-tokens-with-readable-token-expiry-time/

        .DESCRIPTION
        Decode a JWT Access Token and convert to a PowerShell Object.
        JWT Access Token updated to include the JWT Signature (sig), JWT Token Expiry (expiryDateTime) and JWT Token time to expiry (timeToExpiry).

        .PARAMETER token
        The JWT Access Token to decode and udpate with expiry time and time to expiry

        .INPUTS
        Token from Pipeline

        .OUTPUTS
        PowerShell Object

        .SYNTAX
        Get-JWTDetail (accesstoken)

        .EXAMPLE
        PS> Get-JWTDetail ('eyJ0eXAiOi........XmN4GnWQAw7OwMA')
    #>


    if (!$token.Contains(".") -or !$token.StartsWith("eyJ")) { Write-Error "Invalid token" -ErrorAction Stop }

    # Token
    Foreach ($i in 0..1) {
        $data = $token.Split('.')[$i].Replace('-', '+').Replace('_', '/')
        Switch ($data.Length % 4) {
            0 { break }
            2 { $data += '==' }
            3 { $data += '=' }
        }
    }

    $decodedToken = [System.Text.Encoding]::UTF8.GetString([convert]::FromBase64String($data)) | ConvertFrom-Json
    Write-Verbose "JWT Token:"
    Write-Verbose $decodedToken

    # Signature
    Foreach ($i in 0..2) {
        $sig = $token.Split('.')[$i].Replace('-', '+').Replace('_', '/')
        Switch ($sig.Length % 4) {
            0 { break }
            2 { $sig += '==' }
            3 { $sig += '=' }
        }
    }
    Write-Verbose "JWT Signature:"
    Write-Verbose $sig
    $decodedToken | Add-Member -Type NoteProperty -Name "sig" -Value $sig

    # Convert Expiry time to PowerShell DateTime
    $orig = (Get-Date -Year 1970 -Month 1 -Day 1 -hour 0 -Minute 0 -Second 0 -Millisecond 0)
    $timeZone = Get-TimeZone
    $utcTime = $orig.AddSeconds($decodedToken.exp)
    $hoursOffset = $timeZone.GetUtcOffset($(Get-Date)).hours #Daylight saving needs to be calculated
    $localTime = $utcTime.AddHours($hoursOffset)     # Return local time,
    $decodedToken | Add-Member -Type NoteProperty -Name "expiryDateTime" -Value $localTime

    # Time to Expiry
    $timeToExpiry = ($localTime - (get-date))
    $decodedToken | Add-Member -Type NoteProperty -Name "timeToExpiry" -Value $timeToExpiry

    Return $decodedToken
}

#EndRegion APIs for managing Access and Refresh Token


#Region APIs for managing Upgradables

Function Get-VCFUpgradable {
    <#
        .SYNOPSIS
        Get the Upgradables

        .DESCRIPTION
        Fetches the list of Upgradables in the System. Only one Upgradable becomes AVAILABLE for Upgrade.
        The Upgradables provides information that can be use for Precheck API and also in the actual Upgrade API call.

        .EXAMPLE
        Get-VCFUpgradable
        This example shows how to retrieve the list of upgradables in the system
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/system/upgradables"
        $response = Invoke-RestMethod -Method GET -URI $uri -ContentType application/json -headers $headers
        $response.elements
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFUpgradable

#EndRegion APIs for managing Upgradables


#Region APIs for managing Upgrades

Function Get-VCFUpgrade {
    <#
        .SYNOPSIS
        Get the Upgrade

        .DESCRIPTION
        The Get-VCFUpgrade cmdlet retrives a list of upgradable resources in SDDC Manager

        .EXAMPLE
        Get-VCFUpgrade
        This example shows how to retrieve the list of upgradable resources in the system
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ( -not $PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/upgrades"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/upgrades/$id"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFUpgrade

Function Start-VCFUpgrade {
    <#
        .SYNOPSIS
        Schedule/Trigger Upgrade of a Resource

        .DESCRIPTION
        The Start-VCFUpgrade cmdlet triggers an upgrade of a resource in SDDC Manager

        .EXAMPLE
        Start-VCFUpgrade -json $jsonSpec
        This example invokes an upgrade in SDDC Manager using a variable

        .EXAMPLE
        Start-VCFUpgrade -json (Get-Content -Raw .\upgradeDomain.json)
        This example invokes an upgrade in SDDC Manager by passing a JSON file

    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    createHeader # Calls createHeader function to set Accept & Authorization
    checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
    $uri = "https://$sddcManager/v1/upgrades"
    Try {
        $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $json
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-VCFUpgrade

#EndRegion APIs for managing Upgrades


#Region APIs for managing Users

Function Get-VCFUser {
    <#
        .SYNOPSIS
        Get all Users

        .DESCRIPTION
        The Get-VCFUser cmdlet gets a list of users, groups and service users in SDDC Manager

        .EXAMPLE
        Get-VCFUser
        This example list all users, groups and service users in SDDC Manager

        .EXAMPLE
        Get-VCFUser -type USER
        This example list all users in SDDC Manager

        .EXAMPLE
        Get-VCFUser -type GROUP
        This example list all groups in SDDC Manager

        .EXAMPLE
        Get-VCFUser -type SERVICE
        This example list all service users in SDDC Manager

        .EXAMPLE
        Get-VCFUser -domain rainpole.io
        This example list all users and groups based on the authentication domain provided in SDDC Manager
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateSet("USER", "GROUP", "SERVICE")] [String]$type,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$domain
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/users"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        if ($PsBoundParameters.ContainsKey("type")) {
            $response.elements | Where-Object { $_.type -eq $type }
        }
        elseif ($PsBoundParameters.ContainsKey("domain")) {
            $response.elements | Where-Object { $_.domain -eq $domain }
        }
        else {
            $response.elements
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFUser

Function New-VCFUser {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and adds a new user.

        .DESCRIPTION
        The New-VCFUser cmdlet connects to the specified SDDC Manager and adds a new user with a specified role.

        .EXAMPLE
        New-VCFUser -user vcf-admin@rainpole.io -role ADMIN
        This example shows how to add a new user with a specified role
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$user,
        [Parameter (Mandatory = $true)] [ValidateSet("ADMIN", "OPERATOR", "VIEWER")] [String]$role
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/users"
        #Get the Role ID
        $roleID = Get-VCFRole | Where-object { $_.name -eq $role } | Select-Object -ExpandProperty id
        $domain = $user.split('@')
        $body = '[ {
            "name" : "'+ $user + '",
            "domain" : "'+ $domain[1] + '",
            "type" : "USER",
            "role" : {
            "id" : "'+ $roleID + '"
            }
        }]'
        $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $body
        $response.elements
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFUser

Function New-VCFServiceUser {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and adds a service user.

        .DESCRIPTION
        The New-VCFServiceUser cmdlet connects adds a service user.

        .EXAMPLE
        PS C:\> New-VCFServiceUser -user svc-user@rainpole.io -role ADMIN
        This example shows how to add a service user with role ADMIN
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$user,
        [Parameter (Mandatory = $true)] [ValidateSet("ADMIN", "OPERATOR", "VIEWER")] [String]$role
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/users"
        #Get the Role ID
        $roleID = Get-VCFRole | Where-object { $_.name -eq $role } | Select-Object -ExpandProperty id
        $body = '[ {
            "name" : "'+ $user + '",
            "type" : "SERVICE",
            "role" : {
            "id" : "'+ $roleID + '"
        }
        }]'
        $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $body
        $response.elements
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFServiceUser

Function Get-VCFRole {
    <#
        .SYNOPSIS
        Get all roles

        .DESCRIPTION
        The Get-VCFRole cmdlet gets a list of roles in SDDC Manager

        .EXAMPLE
        Get-VCFRole
        This example list all roles in SDDC Manager
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/roles"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.elements
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFRole

Function Remove-VCFUser {
    <#
        .SYNOPSIS
        Deletes a user from SDDC Manager

        .DESCRIPTION
        The Remove-VCFUser cmdlet connects to the specified SDDC Manager and deletes a user

        .EXAMPLE
        Remove-VCFUser -id c769fcc5-fb61-4d05-aa40-9c7786163fb5
        This example shows how to delete a user
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/users/$id"
        $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers -ContentType application/json
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFUser

Function New-VCFGroup {
    <#
        .SYNOPSIS
        Connects to the specified SDDC Manager and adds a new group

        .DESCRIPTION
        The New-VCFGroup cmdlet connects to the specified SDDC Manager and adds a new group with a specified role

        .EXAMPLE
        New-VCFGroup -group ug-vcf-group -domain rainpole.io -role ADMIN
        This example shows how to add a new group with a specified role
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$group,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domain,
        [Parameter (Mandatory = $true)] [ValidateSet("ADMIN", "OPERATOR", "VIEWER")] [String]$role
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/users"
        #Get the Role ID
        $roleID = Get-VCFRole | Where-object { $_.name -eq $role } | Select-Object -ExpandProperty id
        #$domain = $user.split('@')
        $body = '[{
            "name" : "'+ $group + '",
            "domain" : "'+ $domain.ToUpper() + '",
            "type" : "GROUP",
            "role" : {
            "id" : "'+ $roleID + '"
        }
        }]'
        $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $body
        $response.elements
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFGroup

#EndRegion APIs for managing Users


#Region APIs for managing VCF Services

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
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
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
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFService

#EndRegion APIs for managing VCF Services


#Region APIs for managing Version Alias Configuration
# for future implementation
#EndRegion APIs for managing Version Alias Configuration


#Region APIs for managing DNS NTP Configuration

Function Get-VCFConfigurationDNS {
    <#
        .SYNOPSIS
        Gets the current DNS Configuration

        .DESCRIPTION
        The Get-VCFConfigurationDNS cmdlet retrieves the DNS configuration of the connected SDDC Manager

        .EXAMPLE
        Get-VCFConfigurationDNS
        This example shows how to get the DNS configuration of the connected SDDC Manager
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/system/dns-configuration"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.dnsServers
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFConfigurationDNS

Function Get-VCFConfigurationDNSValidation {
    <#
        .SYNOPSIS
        Get the status of the validation of the input for the DNS Configuration

        .DESCRIPTION
        The Get-VCFConfigurationDNSValidation cmdlet retrieves the status of the validation of the DNS Configuration
        JSON

        .EXAMPLE
        Get-VCFConfigurationDNSValidation -id d729fcc5-fb61-2d05-aa40-9c7686163fa1
        This example shows how to get the status of the validation of the DNS Configuration
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/system/dns-configuration/validations/$id"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFConfigurationDNSValidation

Function Set-VCFConfigurationDNS {
    <#
        .SYNOPSIS
        Configures DNS for all systems

        .DESCRIPTION
        The Set-VCFConfigurationDNS cmdlet configures the DNS Server for all systems managed by SDDC Manager

        .EXAMPLE
        Set-VCFConfigurationDNS -json $jsonSpec
        This example shows how to configure the DNS Servers for all systems managed by SDDC Manager using a variable

        .EXAMPLE
        Set-VCFConfigurationDNS -json (Get-Content -Raw .\dnsSpec.json)
        This example shows how to configure the DNS Servers for all systems managed by SDDC Manager using a JSON file

        .EXAMPLE
        Set-VCFConfigurationDNS -json $jsonSpec -validate
        This example shows how to validate the DNS configuration only
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$validate
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ($PsBoundParameters.ContainsKey("validate")) {
            $uri = "https://$sddcManager/v1/system/dns-configuration/validations"
            $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $json
            $response
        }
        else {
            $uri = "https://$sddcManager/v1/system/dns-configuration"
            $response = Invoke-RestMethod -Method PUT -URI $uri -headers $headers -ContentType application/json -body $json
            $response
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFConfigurationDNS

Function Get-VCFConfigurationNTP {
    <#
        .SYNOPSIS
        Gets the current NTP Configuration

        .DESCRIPTION
        The Get-VCFConfigurationNTP cmdlet retrieves the NTP configuration of the connected SDDC Manager

        .EXAMPLE
        Get-VCFConfigurationNTP
        This example shows how to get the NTP configuration of the connected SDDC Manager
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/system/ntp-configuration"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.ntpServers
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFConfigurationNTP

Function Get-VCFConfigurationNTPValidation {
    <#
        .SYNOPSIS
        Get the status of the validation of the input for the NTP Configuration

        .DESCRIPTION
        The Get-VCFConfigurationNTPValidation cmdlet retrieves the status of the validation of the NTP Configuration
        JSON

        .EXAMPLE
        Get-VCFConfigurationNTPValidation -id a749fcc5-fb61-2d05-aa40-9c7686164fc2
        This example shows how to get the status of the validation of the NTP Configuration
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/system/ntp-configuration/validations/$id"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFConfigurationNTPValidation

Function Set-VCFConfigurationNTP {
    <#
        .SYNOPSIS
        Configures NTP for all systems

        .DESCRIPTION
        The Set-VCFConfigurationNTP cmdlet configures the NTP Server for all systems managed by SDDC Manager

        .EXAMPLE
        Set-VCFConfigurationNTP -json $jsonSpec
        This example shows how to configure the NTP Servers for all systems managed by SDDC Manager using a variable

        .EXAMPLE
        Set-VCFConfigurationNTP (Get-Content -Raw .\ntpSpec.json)
        This example shows how to configure the NTP Servers for all systems managed by SDDC Manager using a JSON file

        .EXAMPLE
        Set-VCFConfigurationNTP -json $jsonSpec -validate
        This example shows how to validate the NTP configuration only
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$validate
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ($PsBoundParameters.ContainsKey("validate")) {
            $uri = "https://$sddcManager/v1/system/ntp-configuration/validations"
            $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $json
            $response
        }
        else {
            $uri = "https://$sddcManager/v1/system/ntp-configuration"
            $response = Invoke-RestMethod -Method PUT -URI $uri -headers $headers -ContentType application/json -body $json
            $response
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFConfigurationNTP

#EndRegion APIs for managing DNS NTP Configuration


#Region APIs for managing vCenters

Function Get-VCFvCenter {
    <#
        .SYNOPSIS
        Gets a list of vCenter Servers

        .DESCRIPTION
        Retrieves a list of vCenter Servers managed by the connected SDDC Manager

        .EXAMPLE
        Get-VCFvCenter
        This example shows how to get the list of vCenter Servers managed by the connected SDDC Manager

        .EXAMPLE
        Get-VCFvCenter -id d189a789-dbf2-46c0-a2de-107cde9f7d24
        This example shows how to return the details for a specific vCenter Server managed by the connected SDDC Manager
        using its id

        .EXAMPLE
        Get-VCFvCenter -domain 1a6291f2-ed54-4088-910f-ead57b9f9902
        This example shows how to return the details off all vCenter Server managed by the connected SDDC Manager using
        its domainId

        .EXAMPLE
        Get-VCFvCenter | select fqdn
        This example shows how to get the list of vCenter Servers managed by the connected SDDC Manager but only return the fqdn
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$domainId
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
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
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFvCenter

#EndRegion APIs for managing vCenters


#Region APIs for managing vRealize Suite Lifecycle Manager

Function Get-VCFvRSLCM {
    <#
        .SYNOPSIS
        Get the existing vRealize Suite Lifecycle Manager

        .DESCRIPTION
        The Get-VCFvRSLCM cmdlet gets the complete information about the existing vRealize Suite Lifecycle Manager.

        .EXAMPLE
        Get-VCFvRSLCM
        This example list all details concerning the vRealize Suite Lifecycle Manager
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/vrslcms"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.elements
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFvRSLCM

Function New-VCFvRSLCM {
    <#
        .SYNOPSIS
        Deploy vRealize Suite Lifecycle Manager

        .DESCRIPTION
        The New-VCFvRSLCM cmdlet deploys vRealize Suite Lifecycle Manager to the specified network.

        .EXAMPLE
        New-VCFvRSLCM -json .\SampleJson\vRealize\New-VCFvRSLCM-AVN.json
        This example deploys vRealize Suite Lifecycle Manager using a supplied json file

        .EXAMPLE
        New-VCFvRSLCM -json .\SampleJson\vRealize\New-VCFvRSLCM-AVN.json -validate
        This example performs validation of vRealize Suite Lifecycle Manager using a supplied json file
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$validate
    )

    if (!(Test-Path $json)) {
        Throw "JSON File Not Found"
    }
    else {
        Try {
            createHeader # Calls createHeader function to set Accept & Authorization
            checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
            validateJsonInput # Calls validateJsonInput Function to check the JSON file provided exists
            if ( -not $PsBoundParameters.ContainsKey("validate")) {
                $uri = "https://$sddcManager/v1/vrslcms"
                $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
                $response
            }
            elseif ($PsBoundParameters.ContainsKey("validate")) {
                $uri = "https://$sddcManager/v1/vrslcms/validations"
                $response = Invoke-RestMethod -Method POST -URI $uri -headers $headers -ContentType application/json -body $ConfigJson
                $response
            }
        }
        Catch {
            ResponseException -object $_
        }
    }
}
Export-ModuleMember -Function New-VCFvRSLCM

Function Remove-VCFvRSLCM {
    <#
        .SYNOPSIS
        Remove a failed vRealize Suite Lifecycle Manager deployment

        .DESCRIPTION
        The Remove-VCFvRSLCM cmdlet removes a failed vRealize Suite Lifecycle Manager deployment. Not applicable
        to a successful vRealize Suite Lifecycle Manager deployment.

        .EXAMPLE
        Remove-VCFvRSLCM
        This example removes a failed vRealize Suite Lifecycle Manager deployment
    #>

    Try {
        createHeader # Call createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/vrslcm"
        $response = Invoke-RestMethod -Method DELETE -URI $uri -headers $headers
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFvRSLCM

Function Reset-VCFvRSLCM {
    <#
        .SYNOPSIS
        Redeploy vRealize Suite Lifecycle Manager

        .DESCRIPTION
        The Reset-VCFvRSLCM cmdlet redeploys the existing vRealize Suite Lifecycle Manager

        .EXAMPLE
        Reset-VCFvRSLCM
        This example redeploys the vRealize Suite Lifecycle Manager
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/vrslcm"
        $response = Invoke-RestMethod -Method PATCH -URI $uri -headers $headers
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Reset-VCFvRSLCM

#EndRegion APIs for managing vRealize Suite Lifecycle Manager


#Region APIs for managing vRealize Operations Manager

Function Get-VCFvROPS {
    <#
        .SYNOPSIS
        Get the existing vRealize Operations Manager

        .DESCRIPTION
        The Get-VCFvROPs cmdlet gets the complete information about the existing vRealize Operations Manager.

        .EXAMPLE
        Get-VCFvROPs
        This example list all details concerning the vRealize Operations Manager

        .EXAMPLE
        Get-VCFvROPs -domains
        This example lists all workload domains connected to vRealize Operations Manager
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$domains
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        if ($PsBoundParameters.ContainsKey("domains")) {
            $uri = "https://$sddcManager/v1/vrops/domains"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
        else {
            $uri = "https://$sddcManager/v1/vropses"
            $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
            $response.elements
        }
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFvROPS

Function Get-VCFvROPSConnection {
    <#
        .SYNOPSIS
        Get connection status of VI Workload Domains to vRealize Operations Manager

        .DESCRIPTION
        The Get-VCFvROPSConnection cmdlet gets the connection status for all VI Workload Domains to vRealize Operations Manager

        .EXAMPLE
        Get-VCFvROPSConnection
        This example gets the connection status of all VI Workload Domains to vRealize Operations Manager
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/vrops/domains"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers 
        $response.elements
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFvROPSConnection

Function Set-VCFvROPSConnection {
    <#
        .SYNOPSIS
        Connect or disconnect Workload Domains to vRealize Operations Manager

        .DESCRIPTION
        The Set-VCFvROPs cmdlet connects or disconnects Workload Domains to vRealize Operations Manager.

        .EXAMPLE
        Set-VCFvROPs -domainId <domain-id> -status ENABLED
        This example connects a Workload Domain to vRealize Operations Manager

        .EXAMPLE
        Set-VCFvROPs -domainId <domain-id> -status DISABLED
        This example disconnects a Workload Domain from vRealize Operations Manager
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainId,
        [Parameter (Mandatory = $true)] [ValidateSet("ENABLED", "DISABLED")] [ValidateNotNullOrEmpty()] [String]$status
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $body = '{"domainId": "' + $domainId + '","status": "' + $status + '"}'
        $uri = "https://$sddcManager/v1/vrops/domains"
        $response = Invoke-RestMethod -Method PUT -URI $uri -headers $headers -body $body -ContentType application/json
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFvROPSConnection

#EndRegion APIs for managing vRealize Operations Manager


#Region APIs for managing Workspace ONE Access

Function Get-VCFWSA {
    <#
        .SYNOPSIS
        Get the existing Workspace ONE Access

        .DESCRIPTION
        The Get-VCFWSA cmdlet gets the complete information about the existing Workspace ONE Access.

        .EXAMPLE
        Get-VCFWSA
        This example list all details concerning Workspace ONE Access
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/wsas"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.elements
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFWSA

#EndRegion APIs for managing Workspace ONE Access


#Region APIs for managing vRealize Automation

Function Get-VCFvRA {
    <#
        .SYNOPSIS
        Get the existing vRealize Automation

        .DESCRIPTION
        The Get-VCFvRA cmdlet gets the complete information about the existing vRealize Automation.

        .EXAMPLE
        Get-VCFvRA
        This example list all details concerning the vRealize Automation
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/vras"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.elements
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFvRA

#EndRegion APIs for managing vRealize Automation


#Region APIs for managing vRealize Log Insight

Function Get-VCFvRLI {
    <#
        .SYNOPSIS
        Get the existi  ng vRealize Log Insight

        .DESCRIPTION
        The Get-VCFvRLI cmdlet gets the complete information about the existing vRealize Log Insight.

        .EXAMPLE
        Get-VCFvRLI
        This example list all details concerning the vRealize Log Insight
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/vrlis"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers
        $response.elements
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFvRLI

Function Get-VCFvRLIConnection {
    <#
        .SYNOPSIS
        Get connection status of VI Workload Domains to vRealize Log Insight

        .DESCRIPTION
        The Get-VCFvRLIConnection cmdlet gets the connection status for all VI Workload Domains to vRealize Log Insight

        .EXAMPLE
        Get-VCFvRLIConnection
        This example gets the connection status of all VI Workload Domains to vRealize Log Insight
    #>

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/vrli/domains"
        $response = Invoke-RestMethod -Method GET -URI $uri -headers $headers 
        $response.elements
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFvRLIConnection

Function Set-VCFvRLIConnection {
    <#
        .SYNOPSIS
        Connect or disconnect Workload Domains to vRealize Log Insight

        .DESCRIPTION
        The Set-VCFvRLIConnection cmdlet connects or disconnects Workload Domains to vRealize Log Insight

        .EXAMPLE
        Set-VCFvRLIConnection -domainId <domain-id> -status ENABLED
        This example connects a Workload Domain to vRealize Log Insight

        .EXAMPLE
        Set-VCFvRLIConnection -domainId <domain-id> -status DISABLED
        This example disconnects a Workload Domain from vRealize Log Insight
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainId,
        [Parameter (Mandatory = $true)] [ValidateSet("ENABLED", "DISABLED")] [ValidateNotNullOrEmpty()] [String]$status
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $json = '{"domainId": "' + $domainId + '","status": "' + $status + '"}'
        $uri = "https://$sddcManager/v1/vrli/domains"
        $response = Invoke-RestMethod -Method 'PUT' -URI $uri -headers $headers -body $json -ContentType application/json
        $response
    }
    Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFvRLIConnection

#EndRegion APIs for managing vRealize Log Insight


#Region APIs for managing Validations

Function Validate-CommissionHostSpec {

    Param (
        [Parameter (Mandatory = $true)] [object]$json
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/hosts/validations"
        $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $json
        Return $response
    }
    Catch {
        ResponseException -object $_
    }
}

Function Validate-WorkloadDomainSpec {

    Param (
        [Parameter (Mandatory = $true)] [object]$json
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/domains/validations"
        $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $json
        Return $response
    }
    Catch {
        ResponseException -object $_
    }
}

Function Validate-VCFClusterSpec {

    Param (
        [Parameter (Mandatory = $true)] [object]$json
    )
    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/clusters/validations"
        $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $jsonBody
    }
    Catch {
        ResponseException -object $_
    }
    Return $response
}

Function Validate-VCFUpdateClusterSpec {

    Param (
        [Parameter (Mandatory = $true)] [object]$clusterid,
        [Parameter (Mandatory = $true)] [object]$json
    )

    createHeader # Calls createHeader function to set Accept & Authorization
    checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
    $uri = "https://$sddcManager/v1/clusters/$clusterid/validations"
    Try {
        $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $json
    }
    Catch {
        ResponseException -object $_
    }
    Return $response
}

Function Validate-EdgeClusterSpec {

    Param (
        [Parameter (Mandatory = $true)] [object]$json
    )

    Try {
        createHeader # Calls createHeader function to set Accept & Authorization
        checkVCFToken # Calls the CheckVCFToken function to validate the access token and refresh if necessary
        $uri = "https://$sddcManager/v1/edge-clusters/validations"
        $response = Invoke-RestMethod -Method POST -URI $uri -ContentType application/json -headers $headers -body $json
    }
    Catch {
        ResponseException -object $_
    }
    Return $response
}
#EndRegion APIs for managing Validations


#Region SoS Operations

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
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String] $vcfPassword,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String] $rootPassword,
        [Parameter (Mandatory = $true)] [ValidateSet("general-health", "compute-health", "ntp-health", "password-health", "get-vcf-summary", "get-inventory-info", "get-host-ips", "get-vcf-services-summary")] [String] $sosOption
    )

    $poshSSH = Resolve-PSModule -moduleName "Posh-SSH" # POSH module is required, if not present skipping
    if ($poshSSH -eq "ALREADY_IMPORTED" -or $poshSSH -eq "IMPORTED" -or $poshSSH -eq "INSTALLED_IMPORTED") {
        # Expected sudo prompt from SDDC Manager for elevated commands
        $sudoPrompt = "[sudo] password for vcf"
        # validate if the SDDC Manager vcf password parameter is passed, if not prompt the user and then build vcfCreds PSCredential object
        if ( -not $PsBoundParameters.ContainsKey("vcfPassword") ) {
            Write-Output "Please provide the SDDC Manager vcf user password:"
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
            Write-Output "Please provide the root credential to execute elevated commands in SDDC Manager:"
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
            "general-health" { $sosEndMessage = "For detailed report" }
            "compute-health" { $sosEndMessage = "Health Check completed" }
            "ntp-health" { $sosEndMessage = "For detailed report" }
            "password-health" { $sosEndMessage = "completed" }
            "get-inventory-info" { $sosEndMessage = "Health Check completed" }
            "get-vcf-summary" { $sosEndMessage = "SOLUTIONS_MANAGER" }
            "get-host-ips" { $sosEndMessage = "Health Check completed" }
            "get-vcf-services-summary" { $sosEndMessage = "VCF SDDC Manager Uptime" }
        }

        # Create SSH session to SDDC Manager using vcf user (can't ssh as root by default)
        Try {
            $sessionSSH = New-SSHSession -Computer $sddcManager -Credential $vcfCred -AcceptKey
        }
        Catch {
            $errorString = ResponseException; Write-Error $errorString
        }
        if ($sessionSSH.Connected -eq "True") {
            $stream = $SessionSSH.Session.CreateShellStream("PS-SSH", 0, 0, 0, 0, 1000)
            # build the SOS command to run
            $sshCommand = "sudo /opt/vmware/sddc-support/sos " + "--" + $sosOption
            # Invoke the SSH stream command
            $outInvoke = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command $sshCommand -ExpectString $sudoPrompt -SecureAction $rootCred.Password
            if ($outInvoke) {
                Write-Output "Executing the remote SoS command, output will display when the the run is completed. This might take a while, please wait..."
                $stream.Expect($sosEndMessage)
            }
            # distroy the connection previously established
            Remove-SSHSession -SessionId $sessionSSH.SessionId | Out-Null
        }
    }
    else {
        Write-Error "PowerShell Module Posh-SSH staus is: $poshSSH. Posh-SSH is required to execute this cmdlet, please install the module and try again."
    }
}
Export-ModuleMember -Function Invoke-VCFCommand

#EndRegion SoS Operations


#Region Utility Functions (not exported)

Function ResponseException {
    Param (
        [Parameter (Mandatory = $true)] [PSObject]$object
    )

    Write-Host "Script File:       $($object.InvocationInfo.ScriptName) Line: $($object.InvocationInfo.ScriptLineNumber)" -ForegroundColor Red
    Write-Host "Relevant Command:  $($object.InvocationInfo.Line.trim())" -ForegroundColor Red
    Write-Host "Target Uri:         $($object.TargetObject.RequestUri.AbsoluteUri)" -ForegroundColor Red
    Write-Host "Exception Message: $($object.Exception.Message)" -ForegroundColor Red
    Write-Host "Error Message:     $($object.ErrorDetails.Message)" -ForegroundColor Red
}

Function createHeader {
    $Global:headers = @{"Accept" = "application/json" }
    $Global:headers.Add("Authorization", "Bearer $accessToken")
}

Function createBasicAuthHeader {
    $Global:headers = @{"Accept" = "application/json" }
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
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$moduleName
    )

    # check if module is imported into the current session
    if (Get-Module -Name $moduleName) {
        $searchResult = "ALREADY_IMPORTED"
    }
    else {
        # If module is not imported, check if available on disk and try to import
        if (Get-Module -ListAvailable | Where-Object { $_.Name -eq $moduleName }) {
            Try {
                Write-Output "`n Module $moduleName not loaded, importing now please wait..."
                Import-Module $moduleName
                Write-Output "Module $moduleName imported successfully."
                $searchResult = "IMPORTED"
            }
            Catch {
                $searchResult = "IMPORT_FAILED"
            }
        }
        else {
            # If module is not imported & not available on disk, try PSGallery then install and import
            if (Find-Module -Name $moduleName | Where-Object { $_.Name -eq $moduleName }) {
                Try {
                    Write-Output "Module $moduleName was missing, installing now please wait..."
                    Install-Module -Name $moduleName -Force -Scope CurrentUser
                    Write-Output "Importing module $moduleName, please wait..."
                    Import-Module $moduleName
                    Write-Output "Module $moduleName installed and imported"
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

Function validateJsonInput {
    
    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    # Checking the file path is valid. if not, evaluate if the variable was passed as JSON string
    if (!(Test-Path $json)) {
        
        # File path invalid. Checking if the JSON was passed directly as string by converting to a PS object.If it works, means it was
        # Not using Test-Json since it's not available on PS 5.x but only on 6+
        
        Try {
            $jsonPSobject = ConvertFrom-Json $json -ErrorAction Stop;
            $jsonValid = $true;
        }

        Catch {
            $jsonValid = $false;
            $ConfigJson = $json   # load the raw & wrong JSON content for function return
        }
    
        if ($jsonValid) {
            # JSON parameter was passed as JSON string.Reconverting back from PS object
            $ConfigJson = ConvertTo-Json -InputObject $jsonPSobject
            Write-Verbose "The JSON parameter was passed as a valid JSON string notation"
            $ConfigJson  # return validated json
        }
        else {
            ResponseException -object $_
            $ConfigJson  # return unvalidated JSON before throwing
            Throw "The provided JSON parameter couldn't be validated as file path nor as JSON string. Please check the file path or JSON string formatting again."
        }  
    }
    else {
        # JSON parameter was passed as file path.  Read the file contents and loads it
        $ConfigJson = (Get-Content -Raw $json)
        
        # Validate JSON format
        Try {
            $jsonPSobject = ConvertFrom-Json  $ConfigJson -ErrorAction Stop;
            $jsonValid = $true;
        } 
        Catch {
            $jsonValid = $false;
        }

        if ($jsonValid) {
            Write-Verbose "JSON file found, JSON string format was valid and content has been stored into a variable"
            Write-Verbose $ConfigJson
            $Global:ConfigJson  # return validated json
        }
        else {
            ConfigJson  # return unvalidated json before throwing
            Throw "The provided JSON file path was valid however it couldn't be converted from JSON, please check the formatting of your input file"
        }
    }
}
#EndRegion Utility Functions (not exported()


#Region Useful Script Functions

Function Start-SetupLogFile ($path, $scriptName) {
    $filetimeStamp = Get-Date -Format "MM-dd-yyyy_hh_mm_ss"
    $Global:logFile = $path + '\logs\' + $scriptName + '-' + $filetimeStamp + '.log'
    $logFolder = $path + '\logs'
    $logFolderExists = Test-Path $logFolder
    if (!$logFolderExists) {
        New-Item -ItemType Directory -Path $logFolder | Out-Null
    }
    New-Item -type File -Path $logFile | Out-Null
    $logContent = '[' + $filetimeStamp + '] Beginning of Log File'
    Add-Content -Path $logFile $logContent | Out-Null
}
Export-ModuleMember -Function Start-SetupLogFile

Function Write-LogMessage {
    Param (
        [Parameter (Mandatory = $true)] [AllowEmptyString()] [String]$Message,
        [Parameter (Mandatory = $false)] [ValidateSet("INFO", "ERROR", "WARNING", "EXCEPTION")] [String]$type,
        [Parameter (Mandatory = $false)] [String]$Colour,
        [Parameter (Mandatory = $false)] [String]$Skipnewline
    )

    if (!$Colour) {
        $Colour = "White"
    }

    $timeStamp = Get-Date -Format "MM-dd-yyyy_HH:mm:ss"

    Write-Host -NoNewline -ForegroundColor White " [$timestamp]"
    if ($Skipnewline) {
        Write-Host -NoNewline -ForegroundColor $Colour " $type $Message"        
    }
    else {
        Write-Host -ForegroundColor $colour " $Type $Message" 
    }
    $logContent = '[' + $timeStamp + '] ' + $Type + ' ' + $Message
    Add-Content -Path $logFile $logContent
}
Export-ModuleMember -Function Write-LogMessage

Function Debug-CatchWriter {
    Param (
        [Parameter (Mandatory = $true)] [PSObject]$object
    )

    $lineNumber = $object.InvocationInfo.ScriptLineNumber
    $lineText = $object.InvocationInfo.Line.trim()
    $errorMessage = $object.Exception.Message
    Write-LogMessage -message " Error at Script Line $lineNumber" -colour Red
    Write-LogMessage -message " Relevant Command: $lineText" -colour Red
    Write-LogMessage -message " Error Message: $errorMessage" -colour Red
}
Export-ModuleMember -Function Debug-CatchWriter

#EndRegion Useful Script Functions
