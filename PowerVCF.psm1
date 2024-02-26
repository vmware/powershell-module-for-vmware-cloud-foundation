# Copyright 2023-2024 Broadcom. All Rights Reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Enable communication with self-signed certificates when using Powershell Core. If you require all communications
# to be secure and do not wish to allow communication with self-signed certificates, remove lines 17-36 before
# importing the module.

if ($PSEdition -eq 'Core') {
    $PSDefaultParameterValues.Add("Invoke-RestMethod:SkipCertificateCheck", $true)
}

if ($PSEdition -eq 'Desktop') {
    # Enable communication with self-signed certificates when using Windows Powershell
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

#Region Global Variables

Set-Variable -Name msgVcfApiNotAvailable -Value "This API is not available in the latest versions of VMware Cloud Foundation.:" -Scope Global
Set-Variable -Name msgVcfApiNotSupported -Value "This API is not supported on this version of VMware Cloud Foundation:" -Scope Global
Set-Variable -Name msgVcfApiDeprecated -Value "This API is deprecated on this version of VMware Cloud Foundation:" -Scope Global

#EndRegion Global Variables

#Region APIs for managing Tokens and Initial Connections
Function Request-VCFToken {
    <#
        .SYNOPSIS
        Requests an authentication token from SDDC Manager.

        .DESCRIPTION
        The Request-VCFToken cmdlet connects to the specified SDDC Manager and requests API access and refresh tokens.
        It is required once per session before running all other cmdlets.

        .EXAMPLE
        Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username administrator@vsphere.local -password VMw@re1!
        This example shows how to connect to SDDC Manager to request API access and refresh tokens.

        .EXAMPLE
        Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username admin@local -password VMw@re1!VMw@re1!
        This example shows how to connect to SDDC Manager using local account admin@local.

        .PARAMETER fqdn
        The fully qualified domain name of the SDDC Manager instance.

        .PARAMETER username
        The username to authenticate to the SDDC Manager instance.

        .PARAMETER password
        The password to authenticate to the SDDC Manager instance.

        .PARAMETER skipCertificateCheck
        Switch to skip certificate check when connecting to the SDDC Manager instance.
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
        if (-not("placeholder" -as [type])) {
            add-type -TypeDefinition @"
using System;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

public static class Placeholder {
    public static bool ReturnTrue(object sender,
        X509Certificate certificate,
        X509Chain chain,
        SslPolicyErrors sslPolicyErrors) { return true; }

    public static RemoteCertificateValidationCallback GetDelegate() {
        return new RemoteCertificateValidationCallback(Placeholder.ReturnTrue);
    }
}
"@
        }
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = [placeholder]::GetDelegate()
    }

    $Global:sddcManager = $fqdn
    $headers = @{"Content-Type" = "application/json" }
    $uri = "https://$sddcManager/v1/tokens" # Set URI for executing an API call to validate authentication
    $body = '{"username": "' + $username + '","password": "' + $password + '"}'

    Try {
        # Checking authentication with SDDC Manager
        if ($PSEdition -eq 'Core') {
            $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -Body $body -SkipCertificateCheck # PS Core has -SkipCertificateCheck implemented
            $Global:accessToken = $response.accessToken
            $Global:refreshToken = $response.refreshToken.id
        } else {
            $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -Body $body
            $Global:accessToken = $response.accessToken
            $Global:refreshToken = $response.refreshToken.id
        }
        if ($response.accessToken) {
            Write-Output "Successfully Requested New API Token From SDDC Manager: $sddcManager"
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Request-VCFToken

Function Connect-CloudBuilder {
    <#
        .SYNOPSIS
        Requests an authentication token from a VMware Cloud Builder instance.

        .DESCRIPTION
        The Connect-CloudBuilder cmdlet connects to the specified VMware Cloud Builder instance and stores the
        credentials in a base64 string.

        .EXAMPLE
        Connect-CloudBuilder -fqdn sfo-cb01.sfo.rainpole.io -username admin -password VMware1!
        This example shows how to connect to the VMware Cloud Builder instance.

        .PARAMETER fqdn
        The fully qualified domain name of the VMware Cloud Builder instance.

        .PARAMETER username
        The username to authenticate to the VMware Cloud Builder instance.

        .PARAMETER password
        The password to authenticate to the VMware Cloud Builder instance.

        .PARAMETER skipCertificateCheck
        Switch to skip certificate check when connecting to the VMware Cloud Builder instance.
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
        if (-not("placeholder" -as [type])) {
            add-type -TypeDefinition @"
using System;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

public static class Placeholder {
    public static bool ReturnTrue(object sender,
        X509Certificate certificate,
        X509Chain chain,
        SslPolicyErrors sslPolicyErrors) { return true; }

    public static RemoteCertificateValidationCallback GetDelegate() {
        return new RemoteCertificateValidationCallback(Placeholder.ReturnTrue);
    }
}
"@
        }
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = [placeholder]::GetDelegate()
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
        } else {
            $response = Invoke-WebRequest -Method GET -Uri $uri -Headers $headers
        }
        if ($response.StatusCode -eq 200) {
            Write-Output "Successfully connected to the Cloud Builder Appliance: $cloudBuilder"
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Connect-CloudBuilder
#EndRegion APIs for managing Tokens and Initial Connections


#Region APIs for managing Application Virtual Networks

Function Get-VCFApplicationVirtualNetwork {
    <#
        .SYNOPSIS
        Retrieves Application Virtual Networks (AVN) from SDDC Manager.

        .DESCRIPTION
        cmdlet retrieves the Application Virtual Networks configured in SDDC Manager.

        .EXAMPLE
        Get-VCFApplicationVirtualNetwork
        This example shows how to retrieve a list of Application Virtual Networks.

        .EXAMPLE
        Get-VCFApplicationVirtualNetwork -regionType REGION_A
        This example shows how to retrieve the details of the regionType REGION_A Application Virtual Networks.

        .EXAMPLE
        Get-VCFApplicationVirtualNetwork -id 577e6262-73a9-4825-bdb9-4341753639ce
        This example shows how to retrieve the details of the Application Virtual Networks using the id.

        .PARAMETER regionType
        Specifies the region. One of: REGION_A, REGION_B, X_REGION.

        .PARAMETER id
        Specifies the unique ID of the Application Virtual Network.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateSet("REGION_A", "REGION_B", "X_REGION")] [ValidateNotNullOrEmpty()] [String]$regionType,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if (-not $PsBoundParameters.ContainsKey("regionType") -and (-not $PsBoundParameters.ContainsKey("id"))) {
            $uri = "https://$sddcManager/v1/avns"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
        if ($PsBoundParameters.ContainsKey("regionType")) {
            $uri = "https://$sddcManager/v1/avns?regionType=$regionType"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/avns/avns?id=$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFApplicationVirtualNetwork

Function Add-VCFApplicationVirtualNetwork {
    <#
        .SYNOPSIS
        Creates Application Virtual Networks (AVN) in SDDC Manager and NSX.

        .DESCRIPTION
        The Add-VCFApplicationVirtualNetwork cmdlet creates Application Virtual Networks in SDDC Manager and NSX.

        .EXAMPLE
        Add-VCFApplicationVirtualNetwork -json (Get-Content -Raw .\samples\avns\avnOPverlaySpec.json)
        This example shows how to deploy the Application Virtual Networks using the JSON specification file supplied.

        .EXAMPLE
        Add-VCFApplicationVirtualNetwork -json (Get-Content -Raw .\samples\avns\avnOverlaySpec.json) -validate
        This example shows how to validate the Application Virtual Networks JSON specification file supplied.

        .PARAMETER json
        Specifies the JSON specification to be used.

        .PARAMETER validate
        Specifies to validate the JSON specification file.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$validate
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey("validate")) {
            $uri = "https://$sddcManager/v1/avns/validations"
            $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        } else {
            $uri = "https://$sddcManager/v1/avns"
            $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Add-VCFApplicationVirtualNetwork

#EndRegion APIs for managing Application Virtual Networks


#Region APIs for managing Backup and Restore
Function Get-VCFBackupConfiguration {
    <#
        .SYNOPSIS
        Retrieves the current backup configuration details from SDDC Manager.

        .DESCRIPTION
        The Get-VCFBackupConfiguration cmdlet retrieves the current backup configuration details.

        .EXAMPLE
        Get-VCFBackupConfiguration
        This example retrieves the backup configuration.

        .EXAMPLE
        Get-VCFBackupConfiguration | ConvertTo-Json
        This example retrieves the backup configuration and outputs it in JSON format.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/system/backup-configuration"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response.backupLocations
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFBackupConfiguration

Function Set-VCFBackupConfiguration {
    <#
        .SYNOPSIS
        Configures or updates the backup configuration details for backing up NSX and SDDC Manager.

        .DESCRIPTION
        The Set-VCFBackupConfiguration cmdlet configures or updates the backup configuration details for backing up NSX and SDDC Manager.

        .EXAMPLE
        Set-VCFBackupConfiguration -json (Get-Content -Raw .\samples\backup-restore\backupSpec.json)
        This example shows how to configure the backup configuration.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )


    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/system/backup-configuration"
        $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFBackupConfiguration

Function Start-VCFBackup {
    <#
        .SYNOPSIS
        Starts the backup task in SDDC Manager.

        .DESCRIPTION
        The Start-VCFBackup cmdlet starts the backup task in SDDC Manager.

        .EXAMPLE
        Start-VCFBackup
        This example shows how to start the backup task in SDDC Manager.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $ConfigJson = '{"elements" : [{"resourceType" : "SDDC_MANAGER"}]}'
        $uri = "https://$sddcManager/v1/backups/tasks"
        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $ConfigJson
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-VCFBackup

Function Start-VCFRestore {
    <#
        .SYNOPSIS
        Starts the SDDC Manager restore task.

        .DESCRIPTION
        The Start-VCFRestore cmdlet starts the SDDC Manager restore task.

        .EXAMPLE
        Start-VCFRestore -backupFile "/tmp/vcf-backup-sfo-vcf01-sfo-rainpole-io-yyyy-mm-dd-00-00-00.tar.gz" -passphrase "VMw@re1!VMw@re1!"
        This example shows how to start the SDDC Manager restore task.

        .PARAMETER backupFile
        Specifies the backup file to be used.

        .PARAMETER passphrase
        Specifies the passphrase to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$backupFile,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$passphrase
    )

    Try {
        createBasicAuthHeader
        $ConfigJson = '{ "backupFile": "' + $backupFile + '", "elements": [ {"resourceType": "SDDC_MANAGER"} ], "encryption": {"passphrase": "' + $passphrase + '"}}'
        $uri = "https://$sddcManager/v1/restores/tasks"
        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $ConfigJson
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-VCFRestore

Function Get-VCFRestoreTask {
    <#
        .SYNOPSIS
        Retrieves the status of the restore task.

        .DESCRIPTION
        The Get-VCFRestoreTask cmdlet retrieves the status of the restore task.

        .EXAMPLE
        Get-VCFRestoreTask -id a5788c2d-3126-4c8f-bedf-c6b812c4a753
        This example shows how to retrieve the status of the restore task by unique ID.

        .PARAMETER id
        Specifies the unique ID of the restore task.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        if ($PsBoundParameters.ContainsKey("id")) {
            createBasicAuthHeader
            $uri = "https://$sddcManager/v1/restores/tasks/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFRestoreTask

#EndRegion APIs for managing Backup and Restore


#Region APIs for managing Bundles

Function Get-VCFBundle {
    <#
        .SYNOPSIS
        Retrieves a list of all bundles available to the SDDC Manager instance.

        .DESCRIPTION
        The Get-VCFBundle cmdlet gets all bundles available to the SDDC Manager instance.

        .EXAMPLE
        Get-VCFBundle
        This example shows how to retrieve a list of all bundles available to the SDDC Manager instance.

        .EXAMPLE
        Get-VCFBundle | Select version,downloadStatus,id
        This example shows how to retrieve a list of all bundles available to the SDDC Manager instance and select specific properties.

        .EXAMPLE
        Get-VCFBundle -id 7ef354ab-13a6-4e39-9561-10d2c4de89db
        This example shows how to retrieve a list of details for a specific bundle using the unique ID of the bundle.

        .EXAMPLE
        Get-VCFBundle | Where {$_.description -Match "NSX"}
        This example shows how to retrieve a list of all bundles available to the SDDC Manager instance and filter the results by description.

        .PARAMETER
        Specifies the unique ID of the bundle.
    #>

    Param (
        [Parameter (Mandatory = $false)] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/bundles/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        } else {
            $uri = "https://$sddcManager/v1/bundles"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFBundle

Function Request-VCFBundle {
    <#
        .SYNOPSIS
        Start download of bundle from depot.

        .DESCRIPTION
        The Request-VCFBundle cmdlet starts an immediate download of a bundle from the depot.

        .EXAMPLE
        Request-VCFBundle -id 7ef354ab-13a6-4e39-9561-10d2c4de89db
        This example shows how to start an immediate download of a bundle from the depot using the unique ID of the bundle.

        .PARAMETER id
        Specifies the unique ID of the bundle.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/bundles/$id"
        $body = '{"bundleDownloadSpec": {"downloadNow": true}}'
        $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers	-ContentType 'application/json' -Body $body
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Request-VCFBundle

Function Start-VCFBundleUpload {
    <#
        .SYNOPSIS
        Starts upload of bundle to SDDC Manager.

        .DESCRIPTION
        The Start-VCFBundleUpload cmdlet starts upload of bundle(s) to SDDC Manager

        .EXAMPLE
        Start-VCFBundleUpload -json (Get-Content -Raw .\samples\bundles\bundleUploadSpec.json)
        This example invokes the upload of a bundle onto SDDC Manager by passing a JSON specification file.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/bundles"
        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-VCFBundleUpload

#EndRegion APIs for managing Bundles


#Region APIs for managing CEIP

Function Get-VCFCeip {
    <#
        .SYNOPSIS
        Retrieves the status for the Customer Experience Improvement Program (CEIP) for SDDC Manager, vCenter Server,
        vSAN, and NSX.

        .DESCRIPTION
        The Get-VCFCeip cmdlet retrieves the current setting for the Customer Experience Improvement Program (CEIP)
        of the connected SDDC Manager.

        .EXAMPLE
        Get-VCFCeip
        This example shows how to retrieve the current setting of the Customer Experience Improvement Program for SDDC Manager, vCenter Server, vSAN, and NSX.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/system/ceip"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFCeip

Function Set-VCFCeip {
    <#
        .SYNOPSIS
        Sets the Customer Experience Improvement Program (CEIP) status for SDDC Manager, vCenter Server, vSAN, and NSX.

        .DESCRIPTION
        The Set-VCFCeip cmdlet configures the status for the Customer Experience Improvement Program (CEIP) for
        SDDC Manager, vCenter Server, vSAN, and NSX.

        .EXAMPLE
        Set-VCFCeip -ceipSetting DISABLE
        This example shows how to disable the Customer Experience Improvement Program for SDDC Manager, vCenter Server, vSAN, and NSX.

        .EXAMPLE
        Set-VCFCeip -ceipSetting ENABLE
        This example shows how to enable the Customer Experience Improvement Program for SDDC Manager, vCenter Server, vSAN, and NSX.

        .PARAMETER ceipSetting
        Specifies the configuration of the Customer Experience Improvement Program. One of: ENABLE, DISABLE.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateSet("ENABLE", "DISABLE")] [String]$ceipSetting
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/system/ceip"
        $json = '{"status": "' + $ceipSetting + '"}'
        $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -ContentType 'application/json' -Body $json
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFCeip

#EndRegion APIs for managing CEIP


#Region APIs for managing Certificates

Function Get-VCFCertificateAuthority {
    <#
        .SYNOPSIS
        Retrieves the certificate authority information.

        .DESCRIPTION
        The Get-VCFCertificateAuthority cmdlet retrieves the certificate authority configuration from SDDC Manager.

        .EXAMPLE
        Get-VCFCertificateAuthority
        This example shows how to retrieve the certificate authority configuration from SDDC Manager.

        .EXAMPLE
        Get-VCFCertificateAuthority | ConvertTo-Json
        This example shows how to retrieve the certificate authority configuration from SDDC Manager and convert the output to JSON.

        .EXAMPLE
        Get-VCFCertificateAuthority -caType Microsoft
        This example shows how to retrieve the certificate authority configuration for a Microsoft Certificate Authority from SDDC Manager.

        .PARAMETER caType
        Specifies the certificate authority type. One of: Microsoft, OpenSSL.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateSet("OpenSSL", "Microsoft")] [String] $caType
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey("caType")) {
            $uri = "https://$sddcManager/v1/certificate-authorities/$caType"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        } else {
            $uri = "https://$sddcManager/v1/certificate-authorities"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFCertificateAuthority

Function Remove-VCFCertificateAuthority {
    <#
        .SYNOPSIS
        Removes the certificate authority configuration.

        .DESCRIPTION
        The Remove-VCFCertificateAuthority cmdlet removes the certificate authority configuration from SDDC Manager.

        .EXAMPLE
        Remove-VCFCertificateAuthority
        This example shows how to remove the certificate authority configuration from SDDC Manager.

        .PARAMETER caType
        Specifies the certificate authority type. One of: Microsoft, OpenSSL.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateSet("OpenSSL", "Microsoft")] [String] $caType
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/certificate-authorities/$caType"
        $response = Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFCertificateAuthority

Function Set-VCFMicrosoftCa {
    <#
        .SYNOPSIS
        Configures Microsoft Certificate Authority integration.

        .DESCRIPTION
        The Set-VCFMicrosoftCa cmdlet configures Microsoft Certificate Authority integration with SDDC Manager.

        .EXAMPLE
        Set-VCFMicrosoftCa -serverUrl "https://rpl-dc01.rainpole.io/certsrv" -username Administrator -password "VMw@re1!" -templateName VMware
        This example shows how to configure a Microsoft Certificate Authority integration with SDDC Manager.

        .PARAMETER serverUrl
        Specifies the HTTPS URL for the Microsoft Certificate Authority.

        .PARAMETER username
        Specifies the username used to authenticate to the Microsoft Certificate Authority.

        .PARAMETER password
        Specifies the password used to authenticate to the Microsoft Certificate Authority.

        .PARAMETER templateName
        Specifies the name of the certificate template used on the Microsoft Certificate Authority.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$serverUrl,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$username,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$password,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$templateName
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $json = '{"microsoftCertificateAuthoritySpec": {"secret": "' + $password + '","serverUrl": "' + $serverUrl + '","username": "' + $username + '","templateName": "' + $templateName + '"}}'
        $uri = "https://$sddcManager/v1/certificate-authorities"
        Invoke-RestMethod -Method PUT -Uri $uri -Headers $headers -ContentType 'application/json' -Body $json # This API does not return a response.
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFMicrosoftCa

Function Set-VCFOpensslCa {
    <#
        .SYNOPSIS
        Configures OpenSSL Certificate Authority integration.

        .DESCRIPTION
        The Set-VCFOpensslCa cmdlet configures OpenSSL Certificate Authority integration with SDDC Manager.

        .EXAMPLE
        Set-VCFOpensslCa -commonName "sfo-vcf01.sfo.rainpole.io" -organization Rainpole -organizationUnit "Platform Engineering -locality "San Francisco" -state CA -country US
        This example shows how to configure an OpenSSL Certificate Authority integration with SDDC Manager.

        .PARAMETER commonName
        Specifies the common name for the OpenSSL Certificate Authority.

        .PARAMETER organization
        Specifies the organization name for the OpenSSL Certificate Authority.

        .PARAMETER organizationUnit
        Specifies the organization unit for the OpenSSL Certificate Authority.

        .PARAMETER locality
        Specifies the locality for the OpenSSL Certificate Authority.

        .PARAMETER state
        Specifies the state for the OpenSSL Certificate Authority.

        .PARAMETER country
        Specifies the country for the OpenSSL Certificate Authority.
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
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $json = '{"openSSLCertificateAuthoritySpec": {"commonName": "' + $commonName + '","organization": "' + $organization + '","organizationUnit": "' + $organizationUnit + '","locality": "' + $locality + '","state": "' + $state + '","country": "' + $country + '"}}'
        $uri = "https://$sddcManager/v1/certificate-authorities"
        Invoke-RestMethod -Method PUT -Uri $uri -Headers $headers -ContentType 'application/json' -Body $json # This API does not return a response.
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFOpensslCa

Function Get-VCFCertificateCsr {
    <#
        .SYNOPSIS
        Retrieve the latest generated certificate signing request(s) (CSR) for a workload domain.

        .DESCRIPTION
        The Get-VCFCertificateCsr cmdlet gets the available certificate signing request(s) (CSR) for a workload domain.

        .EXAMPLE
        Get-VCFCertificateCsr -domainName sfo-m01
        This example shows how to retrieve the available certificate signing request(s) (CSR) for a workload domain.

        .EXAMPLE
        Get-VCFCertificateCsr -domainName sfo-m01 | ConvertTo-Json
        This example shows how to retrieve the available certificate signing request(s) (CSR) for a workload domain and convert the output to JSON.

        .PARAMETER domainName
        Specifies the name of the workload domain.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainName
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/domains/$domainName/csrs"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response.elements
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFCertificateCsr

Function Request-VCFCertificateCsr {
    <#
        .SYNOPSIS
        Generate a certificate signing request(s) (CSR) for the selected resource(s) in a workload domain.

        .DESCRIPTION
        The Request-VCFCertificateCsr generates a certificate signing request(s) (CSR) for the selected resource(s)
        in a workload domain.

        .EXAMPLE
        Request-VCFCertificateCsr -domainName MGMT -json (Get-Content -Raw .\samples\certificates\requestCsrSpec.json)
        This example shows how to generate the certificate signing request(s) (CSR) based on the entries within the JSON specification file for resources within the workload domain named MGMT.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainName
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/domains/$domainName/csrs"
        $response = Invoke-RestMethod -Method PUT -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Request-VCFCertificateCsr

Function Get-VCFCertificate {
    <#
        .SYNOPSIS
        Retrieves the latest generated certificate(s) for a workload domain.

        .DESCRIPTION
        The Get-VCFCertificate cmdlet retrieves the latest generated certificate(s) for a workload domain.

        .EXAMPLE
        Get-VCFCertificate -domainName sfo-m01
        This example shows how to retrieve the latest generated certificate(s) for a workload domain.

        .EXAMPLE
        Get-VCFCertificate -domainName sfo-m01 | ConvertTo-Json
        This example shows how to retrieve the latest generated certificate(s) for a workload domain and convert the output to JSON.

        .EXAMPLE
        Get-VCFCertificate -domainName sfo-m01 | Select issuedTo
        TThis example shows how to retrieve the latest generated certificate(s) for a workload domain and select the issuedTo property.

        .EXAMPLE
        Get-VCFCertificate -domainName sfo-m01 -resources
        This example shows how to retrieve the latest generated certificate(s) for a workload domain and retrieve the certificates for all resources in the workload domain.

        .PARAMETER domainName
        Specifies the name of the workload domain.

        .PARAMETER resources
        Specifies retrieving the certificates for the resources.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainName,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$resources
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey("resources")) {
            $uri = "https://$sddcManager/v1/domains/$domainName/resource-certificates"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } else {
            $uri = "https://$sddcManager/v1/domains/$domainName/certificates"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFCertificate

Function Request-VCFCertificate {
    <#
        .SYNOPSIS
        Generate a certificate(s) for the selected resource(s) in a workload domain.

        .DESCRIPTION
        The Request-VCFCertificate cmdlet generates certificate(s) for the selected resource(s) in a workload domain.

        .EXAMPLE
        Request-VCFCertificate -domainName MGMT -json (Get-Content -Raw .\samples\certificates\requestCertificateSpec.json)
        This example shows how to generate the certificate(s) based on the entries within the JSON specification file for resources within the workload domain named MGMT.

        .PARAMETER json
        Specifies the JSON specification to be used.

        .PARAMETER domainName
        Specifies the name of the workload domain.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainName
    )

    if ($PsBoundParameters.ContainsKey("json")) {
        Try {
            $jsonBody = validateJsonInput -json $json
            createHeader # Set the Accept and Authorization headers.
            checkVCFToken # Validate the access token and refresh, if necessary.
            $uri = "https://$sddcManager/v1/domains/$domainName/certificates"
            $response = Invoke-RestMethod -Method PUT -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        } Catch {
            ResponseException -object $_
        }
    }
}
Export-ModuleMember -Function Request-VCFCertificate

Function Set-VCFCertificate {
    <#
        .SYNOPSIS
        Install certificate(s) for the selected resource(s) in a workload domain.

        .DESCRIPTION
        The Set-VCFCertificate cmdlet installs certificate(s) for the selected resource(s) in a workload domain.

        .EXAMPLE
        Set-VCFCertificate -domainName MGMT -json (Get-Content -Raw .\samples\certificates\updateCertificateSpec.json)
        This example shows how to install the certificate(s) for the resources within the domain called MGMT based on the entries within the JSON specification file.

        .PARAMETER json
        Specifies the JSON specification to be used.

        .PARAMETER domainName
        Specifies the name of the workload domain.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainName
    )

    if ($PsBoundParameters.ContainsKey("json")) {
        Try {
            $jsonBody = validateJsonInput -json $json
            createHeader # Set the Accept and Authorization headers.
            checkVCFToken # Validate the access token and refresh, if necessary.
            $uri = "https://$sddcManager/v1/domains/$domainName/certificates"
            $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        } Catch {
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
        Retrieves a list of clusters.

        .DESCRIPTION
        The Get-VCFCluster cmdlet retrieves a list of clusters from SDDC Manager. You can retrieve the clusters by unique ID or name.

        .EXAMPLE
        Get-VCFCluster
        This example shows how to retrieve a list of all clusters.

        .EXAMPLE
        Get-VCFCluster -name wld01-cl01
        This example shows how to retrieve a cluster by name.

        .EXAMPLE
        Get-VCFCluster -id 8423f92e-e4b9-46e7-92f7-befce4755ba2
        This example shows how to retrieve a cluster by unique ID.

        .PARAMETER name
        Specifies the name of the cluster.

        .PARAMETER id
        Specifies the unique ID of the cluster.

        .PARAMETER vdses
        Specifies retrieving the vSphere Distributed Switches (VDS) for the cluster.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$name,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$vdses
    )

    createHeader # Set the Accept and Authorization headers.
    checkVCFToken # Validate the access token and refresh, if necessary.
    Try {
        if ( -not $PsBoundParameters.ContainsKey("name") -and ( -not $PsBoundParameters.ContainsKey("id"))) {
            $uri = "https://$sddcManager/v1/clusters"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            if ($PsBoundParameters.ContainsKey("vdses")) {
                $uri = "https://$sddcManager/v1/clusters/$id/vdses"
            } else {
                $uri = "https://$sddcManager/v1/clusters/$id"
            }
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
        if ($PsBoundParameters.ContainsKey("name")) {
            $uri = "https://$sddcManager/v1/clusters"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            if ($PsBoundParameters.ContainsKey("vdses")) {
                $id = ($response.elements | Where-Object { $_.name -eq $name }).id
                $uri = "https://$sddcManager/v1/clusters/$id/vdses"
                $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
                $response
            } else {
                $response.elements | Where-Object { $_.name -eq $name }
            }
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFCluster

Function New-VCFCluster {
    <#
        .SYNOPSIS
        Creates a cluster in a workload domains.

        .DESCRIPTION
        The New-VCFCluster cmdlet connects to the creates a cluster in a workload domain from a JSON specification file.

        .EXAMPLE
        New-VCFCluster -json .\samples\clusters\clusterSpec.json
        This example shows how to create a cluster in a workload domain from a JSON specification file.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        # Validate the JSON specification file.
        $response = Validate-VCFClusterSpec -json $jsonBody
        # the validation API does not currently support polling with a task ID
        Start-Sleep -Seconds 5
        # Submit the job only if the JSON validation task finished with executionStatus of COMPLETED and resultStatus of SUCCEEDED.
        if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
            Try {
                Write-Output "Task validation completed successfully, invoking cluster task on SDDC Manager"
                $uri = "https://$sddcManager/v1/clusters"
                $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
                $response
            } Catch {
                ResponseException -object $_
            }
        } else {
            Write-Error "The validation task completed the run with the following problems: $($response.validationChecks.errorResponse.message)"
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFCluster

Function Set-VCFCluster {
    <#
        .SYNOPSIS
        Expands or compacts a cluster by adding or removing a host(s). A cluster can also be marked for deletion.

        .DESCRIPTION
        The Set-VCFCluster cmdlet can be used to expand or compact a cluster by adding or removing a host(s).
        A cluster can also be marked for deletion. Before a cluster can be removed it must first be marked for deletion.

        .EXAMPLE
        Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 -json .\samples\clusters\clusterExpansionSpec.json
        This example shows how to expand a cluster by adding a host(s) using a JSON specification file.

        .EXAMPLE
        Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 -json .\Cluster\clusterCompactionSpec.json
        This example shows how to compact a cluster by removing a host(s) using a JSON specification file.

        .EXAMPLE
        Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 -markForDeletion
        This example shows how to mark a cluster for deletion.

        .PARAMETER id
        Specifies the unique ID of the cluster.

        .PARAMETER json
        Specifies the JSON specification to be used.

        .PARAMETER markForDeletion
        Specifies the cluster is to be marked for deletion.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$markForDeletion
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ( -not $PsBoundParameters.ContainsKey("json") -and ( -not $PsBoundParameters.ContainsKey("markForDeletion"))) {
            Throw "You must include either -json or -markForDeletion"
        }

        $jsonBody = validateJsonInput -json $json   # validate input file and format
        $response = Validate-VCFUpdateClusterSpec -clusterid $id -json $jsonBody # validate the JSON provided meets the cluster specifications format
        # the validation API does not currently support polling with a task ID
        Start-Sleep -Seconds 5
        # Submit the job only if the JSON validation task finished with executionStatus of COMPLETED and resultStatus of SUCCEEDED.
        if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
            Try {
                Write-Output "Task validation completed successfully. Invoking cluster task on SDDC Manager"
                $uri = "https://$sddcManager/v1/clusters/$id/"
                $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
                $response
            } Catch {
                ResponseException -object $_
            }
        } else {
            Write-Error "The validation task completed the run with the following problems: $($response.validationChecks.errorResponse.message)"
        }

        if ($PsBoundParameters.ContainsKey("markForDeletion") -and ($PsBoundParameters.ContainsKey("id"))) {
            $jsonBody = '{"markForDeletion": true}'
            $uri = "https://$sddcManager/v1/clusters/$id/"
            $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFCluster

Function Remove-VCFCluster {
    <#
        .SYNOPSIS
        Removes a cluster from a workload domain.

        .DESCRIPTION
        The Remove-VCFCluster cmdlet removes a cluster from a workload domain.
        Before a cluster can be deleted it must first be marked for deletion.

        .EXAMPLE
        Remove-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1
        This example shows how to remove a cluster from a workload domain by unique ID.

        .PARAMETER id
        Specifies the unique ID of the cluster.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    createHeader # Set the Accept and Authorization headers.
    checkVCFToken # Validate the access token and refresh, if necessary.
    Try {
        $uri = "https://$sddcManager/v1/clusters/$id"
        $response = Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFCluster

Function Get-VCFClusterValidation {
    <#
        .SYNOPSIS
        Retrieves the status of the validation task for the cluster JSON specification.

        .DESCRIPTION
        The Get-VCFClusterValidation cmdlet retrieves the status of the validation task for the cluster JSON specification.

        .EXAMPLE
        Get-VCFClusterValidation -id 001235d8-3e40-4a5a-8a89-09985dac1434
        This example shows how to retrieve validation task for the cluster JSON specification by unique ID.

        .PARAMETER id
        Specifies the unique ID of the validation task.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/clusters/validations/$id"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFClusterValidation

#EndRegion APIs for managing Clusters


#Region APIs for managing Credentials

Function Get-VCFCredential {
    <#
        .SYNOPSIS
        Retrieves a list of credentials.

        .DESCRIPTION
        The Get-VCFCredential cmdlet retrieves a list of credentials from the SDDC Manager database. The cmdlet can be
        used to retrieve all credentials, or a specific credential by resourceName, resourceType, or id.

        .EXAMPLE
        Get-VCFCredential
        This example shows how to retrieve a list of credentials.

        .EXAMPLE
        Get-VCFCredential -resourceType VCENTER
        This example shows how to retrieve a list of credentials for a specific resourceType.

        .EXAMPLE
        Get-VCFCredential -resourceName sfo01-m01-esx01.sfo.rainpole.io
        This example shows how to retrieve the credential for a specific resourceName (FQDN).

        .EXAMPLE
        Get-VCFCredential -id 3c4acbd6-34e5-4281-ad19-a49cb7a5a275
        This example shows how to retrieve the credential using the unique ID of the credential.

        .PARAMETER resourceName
        Specifies the resource name of the credential.

        .PARAMETER resourceType
        Specifies the resource type of the credential. One of: VCENTER, PSC, ESXI, BACKUP, NSXT_MANAGER, NSXT_EDGE, VRSLCM, WSA, VROPS, VRLI, VRA.

        .PARAMETER id
        Specifies the unique ID of the credential.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$resourceName,
        [Parameter (Mandatory = $false)] [ValidateSet("VCENTER", "PSC", "ESXI", "BACKUP", "NSXT_MANAGER", "NSXT_EDGE", "VRSLCM", "WSA", "VROPS", "VRLI", "VRA")] [ValidateNotNullOrEmpty()] [String]$resourceType,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey("resourceName")) {
            $uri = "https://$sddcManager/v1/credentials?resourceName=$resourceName"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } elseif ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/credentials/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        } elseif ($PsBoundParameters.ContainsKey("resourceType") ) {
            $uri = "https://$sddcManager/v1/credentials?resourceType=$resourceType"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } else {
            $uri = "https://$sddcManager/v1/credentials"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFCredential

Function Set-VCFCredential {
    <#
        .SYNOPSIS
        Updates or rotate a credential.

        .DESCRIPTION
        The Set-VCFCredential cmdlet updates or rotates a credential.
        Credentials can be updated with a specified password(s) or rotated using system generated password(s).

        .EXAMPLE
        Set-VCFCredential -json .\samples\credentials\updateCredentialSpec.json
        This example shows how to update a credential using a JSON specification file.

        .EXAMPLE
        Set-VCFCredential -json .\samples\credentials\rotateCredentialSpec.json
        This example shows how to rotate a credential using a JSON specification file.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/credentials"
        $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFCredential

Function Set-VCFCredentialAutoRotatePolicy {
    <#
        .SYNOPSIS
        Updates a credential auto rotate policy.

        .DESCRIPTION
        The Set-VCFCredentialAutoRotatePolicy cmdlet updates the auto rotate policy for a credential.
        Credentials can be be set to auto rotate using system generated password(s).

        .EXAMPLE
        Set-VCFCredentialAutoRotatePolicy -resourceName sfo01-m01-vc01.sfo.rainpole.io -resourceType VCENTER -credentialType SSH -username root -autoRotate ENABLED -frequencyInDays 90
        This example shows how to enable the auto rotate policy for a specific resource.

        .EXAMPLE
        Set-VCFCredentialAutoRotatePolicy -resourceName sfo01-m01-vc01.sfo.rainpole.io -resourceType VCENTER -credentialType SSH -username root -autoRotate DISABLED
        This example shows how to disable the auto rotate policy for a specific resource.

        .PARAMETER resourceName
        The name of the resource for which the credential auto rotate policy is to be set.

        .PARAMETER resourceType
        The type of the resource for which the credential auto rotate policy is to be set. One of: VCENTER, PSC, ESXI, BACKUP, NSXT_MANAGER, NSXT_EDGE, VRSLCM, WSA, VROPS, VRLI, VRA.

        .PARAMETER credentialType
        The type of the credential for which the auto rotate policy is to be set. One of: SSH, API, SSO, AUDIT.

        .PARAMETER username
        The username of the credential for which the auto rotate policy is to be set.

        .PARAMETER autoRotate
        Enable or disable the auto rotate policy.

        .PARAMETER frequencyInDays
        The frequency in days for the auto rotate policy. This parameter is required only if the autoRotate parameter is set to ENABLED.
    #>

    Param (
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$resourceName,
        [Parameter(Mandatory = $true)] [ValidateSet('VCENTER', 'PSC', 'ESXI', 'BACKUP', 'NSXT_MANAGER', 'NSXT_EDGE', 'VRSLCM', 'WSA', 'VROPS', 'VRLI', 'VRA')] [ValidateNotNullOrEmpty()] [String]$resourceType,
        [Parameter(Mandatory = $true)] [ValidateSet('SSH', 'API', 'SSO', 'AUDIT')] [ValidateNotNullOrEmpty()] [String]$credentialType,
        [Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$username,
        [Parameter(Mandatory = $true)] [ValidateSet('ENABLED', 'DISABLED')][ValidateNotNullOrEmpty()] [String]$autoRotate,
        [Parameter(Mandatory = $false)] [ValidateScript({ $autoRotate -eq 'ENABLED' -or $_ -eq $null })] [Int]$frequencyInDays
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/credentials"
        $elements = @(
            @{
                resourceName = $resourceName
                resourceType = $resourceType
                credentials  = @(
                    @{
                        credentialType = $credentialType
                        username       = $username
                    }
                )
            }
        )
        if ($autoRotate -eq 'ENABLED') {
            $autoRotatePolicy = @{
                frequencyInDays        = $frequencyInDays
                enableAutoRotatePolicy = $true
            }
        } else {
            $autoRotatePolicy = @{
                enableAutoRotatePolicy = $false
            }
        }
        $body = @{
            operationType    = 'UPDATE_AUTO_ROTATE_POLICY'
            elements         = $elements
            autoRotatePolicy = $autoRotatePolicy
        }
        $body = $body | ConvertTo-Json -Depth 4 -Compress
        $task = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -ContentType 'application/json' -Body $body
        Do {
            Start-Sleep -Seconds 2
            $task = Get-VCFCredentialTask -id $task.id
        } While ($task.status -eq 'IN_PROGRESS')
        if ($task.Status -eq 'FAILED') {
            Throw "The credential task ($($task.id)) failed with an error."
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFCredentialAutoRotatePolicy

Function Get-VCFCredentialTask {
    <#
        .SYNOPSIS
        Retrieves a list of credential tasks in reverse chronological order.

        .DESCRIPTION
        The Get-VCFCredentialTask cmdlet retrieves a list of credential tasks in reverse chronological order.
        You can retrieve the credential tasks by unique ID, status, or resource credentials.

        .EXAMPLE
        Get-VCFCredentialTask
        This example shows how to retrieve a list of all credentials tasks.

        .EXAMPLE
        Get-VCFCredentialTask -id 7534d35d-98fb-43de-bcf7-2776beb6fcc3
        This example shows how to retrieve the credential tasks for a specific task by unique ID.

        .EXAMPLE
        Get-VCFCredentialTask -id 7534d35d-98fb-43de-bcf7-2776beb6fcc3 -resourceCredentials
        This example shows how to retrieve resource credentials for a credential task by unique ID.

        .EXAMPLE
        Get-VCFCredentialTask -status SUCCESSFUL
        This example shows how to retrieve credentials tasks with a specific status.

        .PARAMETER id
        Specifies the unique ID of the credential task.

        .PARAMETER resourceCredentials
        Specifies retrieving the resource credentials for a credential task.

        .PARAMETER status
        Specifies the status of the credential task. One of: SUCCESSFUL, FAILED, USER_CANCELLED.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$resourceCredentials,
        [Parameter (Mandatory = $false)] [ValidateSet("SUCCESSFUL", "FAILED", "USER_CANCELLED")] [String]$status

    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/credentials/tasks/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        } elseif ($PsBoundParameters.ContainsKey("id") -and ($PsBoundParameters.ContainsKey("resourceCredentials"))) {
            $uri = "https://$sddcManager/v1/credentials/tasks/$id/resource-credentials"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        } elseif ($PsBoundParameters.ContainsKey("status")) {
            $uri = "https://$sddcManager/v1/credentials/tasks"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements | Where-Object { $_.status -eq $status }
        } elseif ( -not $PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/credentials/tasks"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFCredentialTask

Function Stop-VCFCredentialTask {
    <#
        .SYNOPSIS
        Stops a failed rotate/update password task.

        .DESCRIPTION
        The Stop-VCFCredentialTask cmdlet stops a failed rotate/update password task.
        You can stop a failed rotate/update password task by unique ID.

        .EXAMPLE
        Stop-VCFCredentialTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d
        This example shows how to cancel a failed rotate or update password task by unique ID.

        .PARAMETER id
        Specifies the unique ID of the credential task.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/credentials/tasks/$id"
        } else {
            Throw "The unique ID of the credential task must be provided."
        }
        $response = Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers -ContentType 'application/json'
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Stop-VCFCredentialTask

Function Restart-VCFCredentialTask {
    <#
        .SYNOPSIS
        Restarts a failed rotate/update password task.

        .DESCRIPTION
        The Restart-VCFCredentialTask cmdlet restarts a failed rotate/update password task.
        You can restart a failed rotate/update password task by unique ID and JSON specification file.

        .EXAMPLE
        Restart-VCFCredentialTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d -json .\samples\credentials\updateCredentialSpec.json
        This example shows how to update passwords of a resource type using a JSON specification file.

        .PARAMETER id
        Specifies the unique ID of the credential task.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/credentials/tasks/$id"
        } else {
            Throw "The unique ID of the credential task must be provided."
        }
        $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Restart-VCFCredentialTask

Function Get-VCFCredentialExpiry {
    <#
        .SYNOPSIS
        Retrieves the password expiry details of credentials.

        .DESCRIPTION
        The Get-VCFCredentialExpiry cmdlet retrieves the password expiry details of credentials.
        You can retrieve the password expiry details of credentials by resource name, resource type, or user ID.

        .EXAMPLE
        Get-VCFCredentialExpiry
        This example shows how to retrieve a list of all credentials with their password expiry details.

        .EXAMPLE
        Get-VCFCredentialExpiry -id 511906b0-e406-46b3-9f5d-38ece1501077
        This example shows how to retrieve password expiry details of the credential by unique ID.

        .EXAMPLE
        Get-VCFCredentialExpiry -resourceName sfo-m01-vc01.sfo.rainpole.io
        This example shows how to retrieve password expiry details by resource name.

        .EXAMPLE
        Get-VCFCredentialExpiry -resourceType VCENTER
        This example shows how to retrieve a list of credentials with their password expiry details by resource type.

        .PARAMETER resourceName
        Specifies the name of the resource.

        .PARAMETER resourceType
        Specifies the type of the resource. One of: VCENTER, PSC, ESXI, BACKUP, NSXT_MANAGER, NSXT_EDGE, VRSLCM, WSA, VROPS, VRLI, VRA.

        .PARAMETER id
        Specifies the unique ID of the credential.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$resourceName,
        [Parameter (Mandatory = $false)] [ValidateSet("VCENTER", "PSC", "ESXI", "BACKUP", "NSXT_MANAGER", "NSXT_EDGE", "VRSLCM", "WSA", "VROPS", "VRLI", "VRA")] [ValidateNotNullOrEmpty()] [String]$resourceType,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/credentials/ui?includeExpiryOnly=true"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        if ($PsBoundParameters.ContainsKey("resourceName")) {
            $response.elements | Where-Object {$_.resource.resourceName -eq $resourceName}
        } elseif ($PsBoundParameters.ContainsKey("id")) {
            $response.elements | Where-Object {$_.id -eq $id}
        } elseif ($PsBoundParameters.ContainsKey("resourceType") ) {
            $response.elements | Where-Object {$_.resource.resourceType -eq $resourceType}
        } else {
            $response.elements
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFCredentialExpiry

#EndRegion APIs for managing Credentials


#Region APIs for managing Depot Settings

Function Get-VCFDepotCredential {
    <#
        .SYNOPSIS
        Retrieves the configurations for the depot configured in the SDDC Manager instance.

        .DESCRIPTION
        The Get-VCFDepotCredential cmdlet retrieves the configurations for the depot configured in the SDDC Manager instance.

        .EXAMPLE
        Get-VCFDepotCredential
        This example shows how to retrieve the credentials for VMware Customer Connect.

        .EXAMPLE
        Get-VCFDepotCredential -vxrail
        This example shows how to retrieve the credentials for Dell EMC Support.

        .PARAMETER vxrail
        Specifies that the cmdlet retrieves the credentials for Dell EMC Support.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$vxrail
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/system/settings/depot"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        if ($PsBoundParameters.ContainsKey('vxrail')) {
            $response.dellEmcSupportAccount
        } else {
            $response.vmwareAccount
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFDepotCredential

Function Set-VCFDepotCredential {
    <#
        .SYNOPSIS
        Updates the configuration for the depot of the connected SDDC Manager.

        .DESCRIPTION
        The Set-VCFDepotCredential cmdlet updates the configuration for the depot of the connected SDDC Manager.

        .EXAMPLE
        Set-VCFDepotCredential -username "support@rainpole.io" -password "VMw@re1!"
        This example sets the credentials for VMware Customer Connect.

        .EXAMPLE
        Set-VCFDepotCredential -vxrail -username "support@rainpole.io" -password "VMw@re1!"
        This example sets the credentials for Dell EMC Support.

        .PARAMETER username
        Specifies the username for the depot.

        .PARAMETER password
        Specifies the password for the depot.

        .PARAMETER vxrail
        Specifies that the cmdlet sets the credentials for Dell EMC Support.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$username,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$password,
        [Parameter (ParameterSetName = 'vxrail', Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$vxrail
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/system/settings/depot"
        if ($PsBoundParameters.ContainsKey('vxrail')) {
            if (-not $PsBoundParameters.ContainsKey('username') -and (-not $PsBoundParameters.ContainsKey('password'))) {
                Throw 'You must enter a username and password for Dell EMC Support.'
            }
        } elseif (-not $PsBoundParameters.ContainsKey('username') -and (-not $PsBoundParameters.ContainsKey('password'))) {
            Throw 'You must enter a username and password for VMware Customer Connect.'
        }

        if ($PsBoundParameters.ContainsKey('vxrail')) {
            $ConfigJson = '{"dellEmcSupportAccount": {"username": "' + $username + '","password": "' + $password + '"}}'
        } else {
            $ConfigJson = '{"vmwareAccount": {"username": "' + $username + '","password": "' + $password + '"}}'
        }

        $response = Invoke-RestMethod -Method PUT -Uri $uri -Headers $headers -ContentType 'application/json' -Body $ConfigJson
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFDepotCredential

#EndRegion APIs for managing Depot Settings


#Region APIs for managing Domains

Function Get-VCFWorkloadDomain {
    <#
        .SYNOPSIS
        Retrieves a list of workload domains.

        .DESCRIPTION
        The Get-VCFWorkloadDomain cmdlet retrieves a list of workload domains from the SDDC Manager.
        You can filter the list by name or unique ID. You can also retrieve endpoints of a workload domain.

        .EXAMPLE
        Get-VCFWorkloadDomain
        This example shows how to retrieve a list of all workload domains.

        .EXAMPLE
        Get-VCFWorkloadDomain -name sfo-wld01
        This example shows how to retrieve a workload domain by name.

        .EXAMPLE
        Get-VCFWorkloadDomain -id 8423f92e-e4b9-46e7-92f7-befce4755ba2
        This example shows how to retrieve a workload domain by unique ID.

        .EXAMPLE
        Get-VCFWorkloadDomain -id 8423f92e-e4b9-46e7-92f7-befce4755ba2 -endpoints | ConvertTo-Json
        This example shows how to retrieve endpoints of a workload domain by unique ID and convert the output to JSON.

        .PARAMETER name
        Specifies the name of the workload domain.

        .PARAMETER id
        Specifies the unique ID of the workload domain.

        .PARAMETER endpoints
        Specifies to retrieve endpoints of the workload domain.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$name,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$endpoints
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey("name")) {
            $uri = "https://$sddcManager/v1/domains"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements | Where-Object { $_.name -eq $name }
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/domains/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
        if ( -not $PsBoundParameters.ContainsKey("name") -and ( -not $PsBoundParameters.ContainsKey("id"))) {
            $uri = "https://$sddcManager/v1/domains"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
        if ( $PsBoundParameters.ContainsKey("id") -and ( $PsBoundParameters.ContainsKey("endpoints"))) {
            $uri = "https://$sddcManager/v1/domains/$id/endpoints"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFWorkloadDomain

Function New-VCFWorkloadDomain {
    <#
        .SYNOPSIS
        Creates a workload domain.

        .DESCRIPTION
        The New-VCFWorkloadDomain cmdlet creates a workload domain from a JSON specification file.

        .EXAMPLE
        New-VCFWorkloadDomain -json .\samples\domains\domainSpec.json
        This example shows how to create a workload domain from a JSON specification file.

        .EXAMPLE
        New-VCFWorkloadDomain -json .\samples\domains\domainSpec.json -validate
        This example shows how to validate workload domain JSON specification file supplied.

        .PARAMETER json
        Specifies the JSON specification to be used.

        .PARAMETER validate
        Validate the JSON specification file.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$validate
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.

        if ( -Not $PsBoundParameters.ContainsKey("validate")) {
            Do {
                $response = Validate-WorkloadDomainSpec -json $jsonBody # Validate the JSON specification file. # the validation API does not currently support polling with a task ID
            }
            Until ($response.executionStatus -eq "COMPLETED")
            # Submit the job only if the JSON validation task completed with an executionStatus of COMPLETED and a resultStatus of SUCCEEDED.
            if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
                Write-Output "Task validation completed successfully. Invoking Workload Domain Creation on SDDC Manager"
                $uri = "https://$sddcManager/v1/domains"
                $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
                Return $response
            } else {
                Write-Error "The validation task completed the run with the following problems:"
                Write-Output $response.validationChecks.errorResponse.message
            }
        } elseif ($PsBoundParameters.ContainsKey("validate")) {
            Do {
                $response = Validate-WorkloadDomainSpec -json $jsonBody # Validate the JSON specification file. # the validation API does not currently support polling with a task ID
            }
            Until ($response.executionStatus -eq "COMPLETED")
            Return $response.validationChecks
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFWorkloadDomain

Function Set-VCFWorkloadDomain {
    <#
        .SYNOPSIS
        Marks a workload domain for deletion.

        .DESCRIPTION
        The Set-VCFWorkloadDomain cmdlet marks a workload domain for deletion.
        Before a workload domain can be removed it must first be marked for deletion.

        .EXAMPLE
        Set-VCFWorkloadDomain -id fbdcf199-c086-43aa-9071-5d53b5c5b99d
        This example shows how to mark a workload domain for deletion.

        .PARAMETER id
        Specifies the unique ID of the workload domain.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/domains/$id"
        $body = '{"markForDeletion": true}'
        Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -ContentType 'application/json' -Body $body # This API does not return a response.
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFWorkloadDomain

Function Remove-VCFWorkloadDomain {
    <#
        .SYNOPSIS
        Removes a workload domain.

        .DESCRIPTION
        The Remove-VCFWorkloadDomain cmdlet removes a workload domain from the SDDC Manager.
        You can specify the workload domain by unique ID.
        Before a workload domain can be deleted it must first be marked for deletion.

        .EXAMPLE
        Remove-VCFWorkloadDomain -id fbdcf199-c086-43aa-9071-5d53b5c5b99d
        This example shows how to remove a workload domain by unique ID.

        .PARAMETER id
        Specifies the unique ID of the workload domain.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    createHeader # Set the Accept and Authorization headers.
    checkVCFToken # Validate the access token and refresh, if necessary.
    Try {
        $uri = "https://$sddcManager/v1/domains/$id"
        $response = Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFWorkloadDomain

#EndRegion APIs for managing Domains


#Region APIs for managing Federation

Function Get-VCFFederation {
    <#
        .SYNOPSIS
        Retrieves the details for a federation.

        .DESCRIPTION
        The Get-VCFFederation cmdlet retrieves the details for a federation from SDDC Manager.

        .EXAMPLE
        Get-VCFFederation
        This example shows how to retrieve the details for a federation from SDDC Manager.

        .EXAMPLE
        Get-VCFFederation | ConvertTo-Json
        This example shows how to retrieve the details for a federation from SDDC Manager and convert the output to JSON.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ((Get-VCFManager -version) -ge '4.4.0') {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        } elseif ((Get-VCFManager -version) -ge '4.3.0' -and (Get-VCFManager -version) -lt '4.4.0') {
            Write-Warning "$msgVcfApiDeprecated $(Get-VCFManager -version)"
            $uri = "https://$sddcManager/v1/sddc-federation"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        } else {
            Write-Output "$msgVcfApiNotAvailable $(Get-VCFManager -version)"
            $uri = "https://$sddcManager/v1/sddc-federation"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFFederation

Function Set-VCFFederation {
    <#
        .SYNOPSIS
        Bootstraps the creation of a federation.

        .DESCRIPTION
        The Set-VCFFederation cmdlet bootstraps the creation of a federation in SDDC Manager.

        .EXAMPLE
        Set-VCFFederation -json (Get-Content -Raw .\samples\federation\federationSpec.json)
        This example shows how to bootstrap the creation of a federation using a JSON specification file.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ((Get-VCFManager -version) -ge '4.4.0') {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        } elseif ((Get-VCFManager -version) -ge '4.3.0' -and (Get-VCFManager -version) -lt '4.4.0') {
            Write-Warning "$msgVcfApiDeprecated $(Get-VCFManager -version)"
            $uri = "https://$sddcManager/v1/sddc-federation"
            $response = Invoke-RestMethod -Method PUT -Uri $uri -Headers $headers -ContentType 'application/json' -Body $json
            $response
        } else {
            Write-Output "$msgVcfApiNotAvailable $(Get-VCFManager -version)"
            $uri = "https://$sddcManager/v1/sddc-federation"
            $response = Invoke-RestMethod -Method PUT -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFFederation

Function Remove-VCFFederation {
    <#
        .SYNOPSIS
        Removes a federation from SDDC Manager.

        .DESCRIPTION
        The Remove-VCFFederation cmdlet removes a federation from SDDC Manager.

        .EXAMPLE
        Remove-VCFFederation
        This example shows how to remove a federation from SDDC Manager.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ((Get-VCFManager -version) -ge '4.4.0') {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        } elseif ((Get-VCFManager -version) -ge '4.3.0' -and (Get-VCFManager -version) -lt '4.4.0') {
            Write-Warning "$msgVcfApiDeprecated $(Get-VCFManager -version)"
            $uri = "https://$sddcManager/v1/sddc-federation"
            # Verify that the connected SDDC Manager is a controller and the only one present in the federation
            $sddcs = Get-VCFFederation | Select-Object memberDetails
            foreach ($sddc in $sddcs) {
                if ($sddc.memberDetails.role -eq 'CONTROLLER') {
                    $controller++
                    if ($sddc.memberDetails.role -eq 'MEMBER') {
                        $member++
                    }
                }
            }
            if ($controller -gt 1) {
                Throw 'More than one federation controller exists. Remove additional controllers.'
            }
            if ($member -gt 0) {
                Throw 'Federation members still exist. Remove all members and any additional controllers.'
            }
            $response = Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers
            $response
        } else {
            Write-Output "$msgVcfApiNotAvailable $(Get-VCFManager -version)"
            $uri = "https://$sddcManager/v1/sddc-federation"
            # Verify that the connected SDDC Manager is a controller and the only one present in the federation
            $sddcs = Get-VCFFederation | Select-Object memberDetails
            foreach ($sddc in $sddcs) {
                if ($sddc.memberDetails.role -eq 'CONTROLLER') {
                    $controller++
                    if ($sddc.memberDetails.role -eq 'MEMBER') {
                        $member++
                    }
                }
            }
            if ($controller -gt 1) {
                Throw 'More than one federation controller exists. Remove additional controllers.'
            }
            if ($member -gt 0) {
                Throw 'Federation members still exist. Remove all members and any additional controllers.'
            }
            $response = Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFFederation

#EndRegion APIs for managing Federation


#Region APIs for managing Federation Members

Function Get-VCFFederationMember {
    <#
        .SYNOPSIS
        Retrieves the information about the members of a federation.

        .DESCRIPTION
        GThe Get-VCFFederationMember cmdlet retrieves information about all the members of a federation from SDDC Manager.

        .EXAMPLE
        Get-VCFFederationMember
        This example shows how to retrieve the information about the members of a federation from SDDC Manager.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ((Get-VCFManager -version) -ge '4.4.0') {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        } elseif ((Get-VCFManager -version) -ge '4.3.0' -and (Get-VCFManager -version) -lt '4.4.0') {
            Write-Warning "$msgVcfApiDeprecated $(Get-VCFManager -version)"
            $uri = "https://$sddcManager/v1/sddc-federation/members"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            if (!$response.federationName) {
                Throw 'Failed to get members. No Federation found.'
            } else {
                $response.memberDetail
            }
        } else {
            Write-Output "$msgVcfApiNotAvailable $(Get-VCFManager -version)"
            $uri = "https://$sddcManager/v1/sddc-federation/members"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            if (!$response.federationName) {
                Throw 'Failed to get members. No Federation found.'
            } else {
                $response.memberDetail
            }
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFFederationMember

Function New-VCFFederationInvite {
    <#
        .SYNOPSIS
        Invites a member to join an existing federation.

        .DESCRIPTION
        The New-VCFFederationInvite cmdlet invites a member to join an existing federation controller.

        .EXAMPLE
        New-VCFFederationInvite -inviteeFqdn lax-vcf01.lax.rainpole.io -inviteeRole MEMBER
        This example shows how to invite a member to join an existing federation controller.

        .PARAMETER inviteeFqdn
        Specifies the fully qualified domain name (FQDN) of the member to invite to join the federation.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$inviteeFqdn,
        [Parameter (Mandatory = $true)] [ValidateSet("MEMBER", "CONTROLLER")] [String]$inviteeRole
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ((Get-VCFManager -version) -ge '4.4.0') {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        } elseif ((Get-VCFManager -version) -ge '4.3.0' -and (Get-VCFManager -version) -lt '4.4.0') {
            Write-Warning "$msgVcfApiDeprecated $(Get-VCFManager -version)"
            $uri = "https://$sddcManager/v1/sddc-federation/membership-tokens"
            $sddcMemberRole = Get-VCFFederationMember
            if ($sddcMemberRole.memberDetail.role -ne "CONTROLLER" -and $sddcMemberRole.memberDetail.fqdn -ne $sddcManager) {
                Throw "$sddcManager is not the Federation controller. Invitatons to join Federation can only be sent from the Federation controller."
            } else {
                $inviteeDetails = @{
                    inviteeRole = $inviteeRole
                    inviteeFqdn = $inviteeFqdn

                }
                $ConfigJson = $inviteeDetails | ConvertTo-Json
                $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -Body $ConfigJson -ContentType 'application/json'
                $response
            }
        } else {
            Write-Warning "This API is not available in the latest versions of VMware Cloud Foundation."
            $uri = "https://$sddcManager/v1/sddc-federation/membership-tokens"
            $sddcMemberRole = Get-VCFFederationMember
            if ($sddcMemberRole.memberDetail.role -ne 'CONTROLLER' -and $sddcMemberRole.memberDetail.fqdn -ne $sddcManager) {
                Throw "$sddcManager is not the Federation controller. Invitatons to join Federation can only be sent from the Federation controller."
            } else {
                $inviteeDetails = @{
                    inviteeRole = $inviteeRole
                    inviteeFqdn = $inviteeFqdn
                }
                $ConfigJson = $inviteeDetails | ConvertTo-Json
                $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -Body $ConfigJson -ContentType 'application/json'
                $response
            }
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFFederationInvite

Function Join-VCFFederation {
    <#
        .SYNOPSIS
        Join an SDDC Manager instance to an existing federation.

        .DESCRIPTION
        The Join-VCFFederation cmdlet joins an SDDC Manager instance to an existing federation.

        .EXAMPLE
        Join-VCFFederation -json (Get-Content -Raw .\samples\federation\joinFederationSpec.json)
        This example shows how to join an SDDC Manager instance to an existing federation.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ((Get-VCFManager -version) -ge '4.4.0') {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        } elseif ((Get-VCFManager -version) -ge '4.3.0' -and (Get-VCFManager -version) -lt '4.4.0') {
            if (!(Test-Path $json)) {
                Throw "The JSON specification file was not found: $json"
            } else {
                Write-Warning "$msgVcfApiDeprecated $(Get-VCFManager -version)"
                $ConfigJson = (Get-Content -Raw $json) # Reads the JSON specification file contents into the variable.
                $uri = "https://$sddcManager/v1/sddc-federation/members"
                $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $ConfigJson
                $response
                $taskId = $response.taskId # Get the task id from the response.
                # Keep checking until executionStatus is not IN_PROGRESS, then return the response.
                Do {
                    $uri = "https://$sddcManager/v1/sddc-federation/tasks/$taskId"
                    $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers -ContentType 'application/json'
                    Start-Sleep -Second 5
                } While ($response.status -eq "IN_PROGRESS")
                $response
            }
        } else {
            if (!(Test-Path $json)) {
                Throw 'JSON File Not Found'
            } else {
                $ConfigJson = (Get-Content -Raw $json) # Reads the JSON specification file contents into the variable.
                $uri = "https://$sddcManager/v1/sddc-federation/members"
                $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $ConfigJson
                $response
                $taskId = $response.taskId # Get the task id from the response.
                # Keep checking until executionStatus is not IN_PROGRESS, then return the response.
                Do {
                    $uri = "https://$sddcManager/v1/sddc-federation/tasks/$taskId"
                    $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers -ContentType 'application/json'
                    Start-Sleep -Seconds 5
                } While ($response.status -eq 'IN_PROGRESS')
                $response
            }
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Join-VCFFederation

#EndRegion APIs for managing Federation Members


#Region APIs for managing Federation Tasks

Function Get-VCFFederationTask {
    <#
        .SYNOPSIS
        Retrieves the status of operations tasks in a federation.

        .DESCRIPTION
        The Get-VCFFederationTask cmdlet retrieves the status of operations tasks in a federation from SDDC Manager.

        .EXAMPLE
        Get-VCFFederationTask -id f6f38f6b-da0c-4ef9-9228-9330f3d30279
        This example shows how to retrieve the status of operations tasks in a federation from SDDC Manager.

        .PARAMETER id
        Specifies the unique ID of the federation task.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ((Get-VCFManager -version) -ge '4.4.0') {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        } elseif ((Get-VCFManager -version) -ge '4.3.0' -and (Get-VCFManager -version) -lt '4.4.0') {
            Write-Warning "$msgVcfApiDeprecated $(Get-VCFManager -version)"
            $uri = "https://$sddcManager/v1/sddc-federation/tasks/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        } else {
            Write-Output "$msgVcfApiNotAvailable $(Get-VCFManager -version)"
            $uri = "https://$sddcManager/v1/sddc-federation/tasks/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFFederationTask

#EndRegion APIs for managing Federation Tasks


#Region APIs for managing FIPS

Function Get-VCFFipsMode {
    <#
        .SYNOPSIS
        Retrieves the status for FIPS mode.

        .DESCRIPTION
        The Get-VCFFipsMode cmdlet retrieves the status for FIPS mode on the VMware Cloud Foundation instance.

        .EXAMPLE
        Get-VCFFipsMode
        This example shows how to retrieve the status for FIPS mode on the VMware Cloud Foundation instance.
    #>

    Try {
        if ((Get-VCFManager -version) -ge '4.3.0') {
            createHeader # Set the Accept and Authorization headers.
            checkVCFToken # Validate the access token and refresh, if necessary.
            $uri = "https://$sddcManager/v1/system/security/fips"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        } else {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFFipsMode

#EndRegion APIs for managing FIPS


#Region APIs for managing Hosts

Function Get-VCFHost {
    <#
        .SYNOPSIS
        Retrieves a list of ESXi hosts.

        .DESCRIPTION
        The Get-VCFHost cmdlet retrieves a list of ESXi hosts. You can retrieve the hosts by unique ID, status, or FQDN.

        - ASSIGNED: Hosts that are assigned to a workload domain.
        - UNASSIGNED_USEABLE: Hosts that are available to be assigned to a workload domain.
        - UNASSIGNED_UNUSEABLE: Hosts that are currently not assigned to any domain and are not available to be assigned
        to a workload domain.

        .EXAMPLE
        Get-VCFHost
        This example shows how to retrieve all ESXi hosts, regardless of status.

        .EXAMPLE
        Get-VCFHost -Status ASSIGNED
        This example shows how to retrieve all ESXi hosts with a specific status.

        .EXAMPLE
        Get-VCFHost -id edc4f372-aab5-4906-b6d8-9b96d3113304
        This example shows how to retrieve an ESXi host by unique ID.

        .EXAMPLE
        Get-VCFHost -fqdn sfo01-m01-esx01.sfo.rainpole.io
        This example shows how to retrieve an ESXi host by FQDN.

        .PARAMETER fqdn
        Specifies the fully qualified domain name (FQDN) of the ESXi host.

        .PARAMETER status
        Specifies the status of the ESXi host. One of: ASSIGNED, UNASSIGNED_USEABLE, UNASSIGNED_UNUSEABLE.

        .PARAMETER id
        Specifies the unique ID of the ESXi host.
    #>

    [CmdletBinding(DefaultParametersetname = "Default")]

    Param (
        [Parameter (Mandatory = $false, ParameterSetName = "fqdn")] [ValidateNotNullOrEmpty()] [String]$fqdn,
        [Parameter (Mandatory = $false, ParameterSetName = "status")] [ValidateSet('ASSIGNED', 'UNASSIGNED_USEABLE', 'UNASSIGNED_UNUSEABLE', IgnoreCase = $false)] [String]$Status,
        [Parameter (Mandatory = $false, ParameterSetName = "id")] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/hosts"

        Switch ( $PSCmdlet.ParameterSetName ) {
            "id" {
                # Add id to uri.
                $uri += "/$id"
            }
            "status" {
                # Add status to uri.
                $uri += "?status=$status"
            }
        }

        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers

        Switch ( $PSCmdlet.ParameterSetName ) {
            "id" {
                # When there is an id, it is directly the response.
                $response
            }
            "fqdn" {
                # When there is an fqdn, we need to filter the response.
                $response.elements | Where-Object { $_.fqdn -eq $fqdn }
            }
            Default {
                $response.elements
            }
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFHost

Function New-VCFCommissionedHost {
    <#
        .SYNOPSIS
        Commission a list of ESXi hosts.

        .DESCRIPTION
        The New-VCFCommissionedHost cmdlet commissions a list of ESXi hosts.

        .EXAMPLE
        New-VCFCommissionedHost -json (Get-Content -Raw .\samples\hosts\commissionHostsSpec.json)
        This example shows how to commission a list of ESXi hosts using a JSON specification file.

        .EXAMPLE
        New-VCFCommissionedHost -json (Get-Content -Raw .\samples\hosts\commissionHostSpec.json) -validate
        This example shows how to validate the ESXi host JSON specification file.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$validate
    )

    $json_content = $json
    $json_content = $json_content | ConvertFrom-Json
    
    # If the sample JSON payload from the SDDC Manager UO is used, transform to API specification.
    if ($json.contains("hostfqdn")) {
        $newjson_content = @()
        foreach ($jsoninfo in $json_content.hostsSpec) { 
            $fqdn = $jsoninfo.hostfqdn
            $networkPoolName = $jsoninfo.networkPoolName
            $password = $jsoninfo.password
            $username = $jsoninfo.username
            $storageType = $jsoninfo.storageType
            $networkId = Get-VCFNetworkPool -name $networkPoolName
            $newjson_content += New-Object PSObject -Property @{
                'fqdn'            = $fqdn
                'networkPoolId'   = $networkId.id
                'networkPoolName' = $networkPoolName
                'password'        = $password
                'storageType'     = $storageType
                'username'        = $username
            }
        }   
        $jsonvalidation = ConvertTo-Json @($newjson_content) 
        $jsonBody = validateJsonInput -json $jsonvalidation
    } else {
        # If the JSON payload is already in the API specification, validate.
        $jsonBody = validateJsonInput -json $json       
    }
    
    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ( -Not $PsBoundParameters.ContainsKey("validate")) {
            $response = Validate-CommissionHostSpec -json $jsonBody # Validate the JSON specification file.
            $taskId = $response.id # Get the task id from the validation function.
            Do {
                # Keep checking until executionStatus is not IN_PROGRESS
                $uri = "https://$sddcManager/v1/hosts/validations/$taskId"
                $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers -ContentType 'application/json'
            } While ($response.executionStatus -eq "IN_PROGRESS")
            # Submit the job only if the JSON validation task completed with an executionStatus of COMPLETED and a resultStatus of SUCCEEDED.
            if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
                Write-Output "Task validation completed successfully. Invoking host(s) commissioning on SDDC Manager"
                $uri = "https://$sddcManager/v1/hosts/"
                $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
                Return $response
            } else {
                Write-Error "The validation task completed the run with the following problems:"
                Write-Output $response.validationChecks.errorResponse
            }
        } elseif ($PsBoundParameters.ContainsKey("validate")) {
            $response = Validate-CommissionHostSpec -json $jsonBody # Validate the JSON specification file.
            $taskId = $response.id # Get the task id from the validation function.
            Do {
                # Keep checking until executionStatus is not IN_PROGRESS
                $uri = "https://$sddcManager/v1/hosts/validations/$taskId"
                $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers -ContentType 'application/json'
            } While ($response.executionStatus -eq "IN_PROGRESS")
            if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
                Write-Output "Task validation completed successfully."
                Return $response
            } else {
                Write-Error "The validation task completed the run with the following problems:" 
                Write-Output $response.validationChecks.errorResponse
            }
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFCommissionedHost

Function Remove-VCFCommissionedHost {
    <#
        .SYNOPSIS
        Decommissions a list of ESXi hosts.

        .DESCRIPTION
        The Remove-VCFCommissionedHost cmdlet decommissions a list of ESXi hosts.

        .EXAMPLE
        Remove-VCFCommissionedHost -json (Get-Content -Raw .\samples\hosts\decommissionHostsSpec.json)
        This example shows how to decommission a list of ESXi hosts using a JSON specification file.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/hosts"
        $response = Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFCommissionedHost

#EndRegion APIs for managing Hosts


#Region APIs for managing License Keys

Function Get-VCFLicenseKey {
    <#
        .SYNOPSIS
        Retrieves license keys.

        .DESCRIPTION
        The Get-VCFLicenseKey cmdlet retrieves license keys. You can filter the list by key, product type, and status.

        .EXAMPLE
        Get-VCFLicenseKey
        This example shows how to retrieve a list of all license keys.

        .EXAMPLE
        Get-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
        This example shows how to retrieve a specific license key by key.

        .EXAMPLE
        Get-VCFLicenseKey -productType VCENTER
        This example shows how to retrieve a license by product type.

        .EXAMPLE
        Get-VCFLicenseKey -status EXPIRED
        This example shows how to retrieve a license by status.

        .PARAMETER key
        Specifies the license key.

        .PARAMETER productType
        Specifies the product type. One of: VCENTER, VSAN, ESXI, NSXT, SDDC_MANAGER.

        .PARAMETER status
        Specifies the status of the license key. One of: EXPIRED, ACTIVE, NEVER_EXPIRES.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$key,
        [Parameter (Mandatory = $false)] [ValidateSet("VCENTER", "VSAN", "ESXI", "NSXT", "SDDC_MANAGER")] [String]$productType,
        [Parameter (Mandatory = $false)] [ValidateSet("EXPIRED", "ACTIVE", "NEVER_EXPIRES")] [String]$status
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey("key")) {
            $uri = "https://$sddcManager/v1/license-keys/$key"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
        if ($PsBoundParameters.ContainsKey("productType")) {
            $uri = "https://$sddcManager/v1/license-keys?productType=$productType"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("status")) {
            $uri = "https://$sddcManager/v1/license-keys?licenseKeyStatus=$status"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
        if ( -not $PsBoundParameters.ContainsKey("key") -and ( -not $PsBoundParameters.ContainsKey("productType")) -and ( -not $PsBoundParameters.ContainsKey("status"))) {
            $uri = "https://$sddcManager/v1/license-keys"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFLicenseKey

Function New-VCFLicenseKey {
    <#
        .SYNOPSIS
        Adds a license key.

        .DESCRIPTION
        The New-VCFLicenseKey cmdlet adds a new license key to SDDC Manager.

        .EXAMPLE
        New-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA" -productType VCENTER -description "vCenter Server License"
        This example shows how to add a license key to SDDC Manager.

        .PARAMETER key
        Specifies the license key to add.

        .PARAMETER productType
        Specifies the product type for the license key. One of: SDDC_MANAGER, VCENTER, VSAN, ESXI, NSXT, WCP.

        .PARAMETER description
        Specifies the description for the license key.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$key,
        [Parameter (Mandatory = $true)] [ValidateSet("VCENTER", "VSAN", "ESXI", "WCP", "NSXT", "SDDC_MANAGER")] [String]$productType,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$description
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $jsonBody = '{ "key" : "' + $key + '", "productType" : "' + $productType + '", "description" : "' + $description + '" }'
        $uri = "https://$sddcManager/v1/license-keys"
        Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody # This API does not return a response.
        Get-VCFLicenseKey -key $key
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFLicenseKey

Function Remove-VCFLicenseKey {
    <#
        .SYNOPSIS
        Removes a license key.

        .DESCRIPTION
        The Remove-VCFLicenseKey cmdlet removes a license key from SDDC Manager.
        A license key can only be removed if the key is not in use.

        .EXAMPLE
        Remove-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
        This example shows how to remove a license key.

        .PARAMETER key
        Specifies the license key to remove.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$key
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/license-keys/$key"
        Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers # This API does not return a response..
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFLicenseKey

Function Get-VCFLicenseMode {
    <#
        .SYNOPSIS
        Retrieves the current license mode.

        .DESCRIPTION
        The Get-VCFLicenseMode cmdlet retrieves the current license mode.

        .EXAMPLE
        Get-VCFLicenseMode
        This example shows how to retrieve the current license mode.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/licensing-info"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFLicenseMode

#EndRegion APIs for managing License Keys


#Region APIs for managing Network Pools

Function Get-VCFNetworkPool {
    <#
        .SYNOPSIS
        Retrieves a list of all network pools.

        .DESCRIPTION
        The Get-VCFNetworkPool cmdlet retrieves a list of all network pools.

        .EXAMPLE
        Get-VCFNetworkPool
        This example shows how to retrieve a list of all network pools.

        .EXAMPLE
        Get-VCFNetworkPool -name sfo01-networkpool
        This example shows how to retrieve a network pool by name.

        .EXAMPLE
        Get-VCFNetworkPool -id 40b0b36d-36d6-454c-814b-ba8bf9b383e3
        This example shows how to retrieve a network pool by unique ID.

        .PARAMETER name
        Specifies the name of the network pool.

        .PARAMETER id
        Specifies the unique ID of the network pool.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$name,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ( -not $PsBoundParameters.ContainsKey("name") -and ( -not $PsBoundParameters.ContainsKey("id"))) {
            $uri = "https://$sddcManager/v1/network-pools"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/network-pools/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
        if ($PsBoundParameters.ContainsKey("name")) {
            $uri = "https://$sddcManager/v1/network-pools"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements | Where-Object { $_.name -eq $name }
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFNetworkPool

Function New-VCFNetworkPool {
    <#
        .SYNOPSIS
        Adds a network pool.

        .DESCRIPTION
        The New-VCFNetworkPool cmdlet adds a network pool.

        .EXAMPLE
        New-VCFNetworkPool -json (Get-Content -Raw .\samples\network-pools\networkPoolSpec.json)
        This example shows how to add a network pool using a JSON specification file.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/network-pools"
        Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody # This API does not return a response.
        # Sending GET to validate the Network Pool creation was successful
        $validate = $jsonBody | ConvertFrom-Json
        $poolName = $validate.name
        Get-VCFNetworkPool -name $poolName
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFNetworkPool

Function Remove-VCFNetworkPool {
    <#
        .SYNOPSIS
        Removes a network pool.

        .DESCRIPTION
        The Remove-VCFNetworkPool cmdlet removes a network pool.

        .EXAMPLE
        Remove-VCFNetworkPool -id 7ee7c7d2-5251-4bc9-9f91-4ee8d911511f
        This example shows how to remove a network pool by unique ID.

        .PARAMETER id
        Specifies the unique ID of the network pool.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/network-pools/$id"
        Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers # This API does not return a response..
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFNetworkPool

Function Get-VCFNetworkIPPool {
    <#
        .SYNOPSIS
        Retrieves a list of all networks of a network pool.

        .DESCRIPTION
        The Get-VCFNetworkIPPool cmdlet retrieves a list of all networks of a network pool.

        .EXAMPLE
        Get-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52
        This example shows how to retrieve a list of all networks of a network pool by unique ID.

        .EXAMPLE
        Get-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkId c2197368-5b7c-4003-80e5-ff9d3caef795
        This example shows how to retrieve a list of details for a specific network associated to the network pool using the unique ID of the network pool and the unique ID of the network.

        .PARAMETER id
        Specifies the unique ID of the network pool.

        .PARAMETER networkId
        Specifies the unique ID of the network.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$networkId
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey("id") -and $PsBoundParameters.ContainsKey("networkId")) {
            $uri = "https://$sddcManager/v1/network-pools/$id/networks/$networkid"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        } else {
            $uri = "https://$sddcManager/v1/network-pools/$id/networks"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFNetworkIPPool

Function Add-VCFNetworkIPPool {
    <#
        .SYNOPSIS
        Adds an IP Pool to the an existing network of a network pool.

        .DESCRIPTION
        The Add-VCFNetworkIPPool mdlet adds an IP pool to an existing network of a network pool.

        .EXAMPLE
        Add-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkid c2197368-5b7c-4003-80e5-ff9d3caef795 -ipStart 192.168.110.61 -ipEnd 192.168.110.64
        This example shows how create an IP pool on the existing network of a network pool using the unique ID of the network pool, the unique ID of the network, and the start and end IP addresses for the new IP range.

        .PARAMETER id
        Specifies the unique ID of the target network pool.

        .PARAMETER networkid
        Specifies the unique ID of the target network.

        .PARAMETER ipStart
        Specifies the start IP address for the new IP range.

        .PARAMETER ipEnd
        Specifies the end IP address for the new IP range.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$networkid,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$ipStart,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$ipEnd
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/network-pools/$id/networks/$networkid/ip-pools"
        $body = '{"end": "' + $ipEnd + '","start": "' + $ipStart + '"}'
        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $body
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Add-VCFNetworkIPPool

Function Remove-VCFNetworkIPPool {
    <#
        .SYNOPSIS
        Removes an IP pool from the network of a network pool.

        .DESCRIPTION
        The Remove-VCFNetworkIPPool cmdlet removes an IP pool assigned to an existing network within a network pool.

        .EXAMPLE
        Remove-VCFNetworkIPPool -id 917bcf8f-93e8-4b84-9627-471899c05f52 -networkid c2197368-5b7c-4003-80e5-ff9d3caef795 -ipStart 192.168.110.61 -ipEnd 192.168.110.64
        This example shows how remove an IP pool on the existing network for a given network pool.

        .PARAMETER id
        Specifies the unique ID of the network pool.

        .PARAMETER networkid
        Specifies the unique ID of the network.

        .PARAMETER ipStart
        Specifies the start IP address of the IP pool.

        .PARAMETER ipEnd
        Specifies the end IP address of the IP pool.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$networkid,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$ipStart,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$ipEnd
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/network-pools/$id/networks/$networkid/ip-pools"
        $body = '{"end": "' + $ipEnd + '","start": "' + $ipStart + '"}'
        $response = Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers -ContentType 'application/json' -Body $body
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFNetworkIPPool

#EndRegion APIs for managing Network Pools


#Region APIs for managing NSX Manager Clusters

Function Get-VCFNsxtCluster {
    <#
        .SYNOPSIS
        Retrieves a list of NSX Manager cluster managed by SDDC Manager.

        .DESCRIPTION
        The Get-VCFNsxtCluster cmdlet retrieves a list of NSX Manager clusters managed by SDDC Manager.

        .EXAMPLE
        Get-VCFNsxtCluster
        This example shows how to retrieve the list of NSX Manager clusters managed by SDDC Manager.

        .EXAMPLE
        Get-VCFNsxtCluster -id d189a789-dbf2-46c0-a2de-107cde9f7d24
        This example shows how to retrieve the NSX Manager cluster managed by SDDC Manager by unique ID.

        .EXAMPLE
        Get-VCFNsxtCluster | Select vipfqdn
        This example shows how to retrieve the NSX Manager clusters managed by SDDC Manager and select the VIP FQDN.

        .PARAMETER id
        Specifies the unique ID of the NSX Manager cluster.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if (-not $PsBoundParameters.ContainsKey("id") -and (-not $PsBoundParameters.ContainsKey("domainId"))) {
            $uri = "https://$sddcManager/v1/nsxt-clusters"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/nsxt-clusters/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFNsxtCluster

#EndRegion APIs for managing NSX Manager Clusters


#Region APIs for managing NSX Edge Clusters

Function Get-VCFEdgeCluster {
    <#
        .SYNOPSIS
        Retrieves a list of NSX Edge clusters managed by SDDC Manager.

        .DESCRIPTION
        The Get-VCFEdgeCluster cmdlet retrieves a list of NSX Edge clusters managed by SDDC Manager.

        .EXAMPLE
        Get-VCFEdgeCluster
        This example shows how to retrieve the list of NSX Edge clusters managed by SDDC Manager.

        .EXAMPLE
        Get-VCFEdgeCluster -id b4e3b2c4-31e8-4816-b1c5-801e848bef09
        This example shows how to retrieve an NSX Edge cluster managed by SDDC Manager by unique ID.

        .PARAMETER id
        Specifies the unique ID of the NSX Edge cluster.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ( -not $PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/edge-clusters"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/edge-clusters/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFEdgeCluster

Function New-VCFEdgeCluster {
    <#
        .SYNOPSIS
        Creates an NSX Edge cluster managed by SDDC Manager.

        .DESCRIPTION
        The New-VCFEdgeCluster cmdlet creates an NSX Edge cluster managed by SDDC Manager.

        .EXAMPLE
        New-VCFEdgeCluster -json (Get-Content -Raw .\samples\nsx\nsx-edge-clusters\edgeClusterSpec.json)
        This example shows how to create an NSX Edge cluster using a JSON specification file.

        .EXAMPLE
        New-VCFEdgeCluster -json (Get-Content -Raw .\samples\nsx\nsx-edge-clusters\edgeClusterSpec.json)-validate
        This example shows how to validate the NSX Edge cluster JSON specification file.

        .PARAMETER json
        Specifies the JSON specification to be used.

        .PARAMETER validate
        Specifies to validate the JSON specification file.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$validate
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ( -Not $PsBoundParameters.ContainsKey("validate")) {
            $response = Validate-EdgeClusterSpec -json $jsonBody # Validate the JSON specification file.
            $taskId = $response.id # Get the task id from the validation function.
            Do {
                # Keep checking until executionStatus is not IN_PROGRESS.
                $uri = "https://$sddcManager/v1/edge-clusters/validations/$taskId"
                $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers -ContentType 'application/json'
            } While ($response.executionStatus -eq "IN_PROGRESS")
            # Submit the job only if the JSON validation task completed with an executionStatus of COMPLETED and resultStatus of SUCCEEDED.
            if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
                Write-Output "Task validation completed successfully. Invoking NSX Edge cluster deployment."
                $uri = "https://$sddcManager/v1/edge-clusters"
                $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
                Return $response
            } else {
                Write-Error "The validation task completed the run with the following error: $($response.validationChecks.errorResponse.message)"
            }
        } elseif ($PsBoundParameters.ContainsKey("validate")) {
            $response = Validate-EdgeClusterSpec -json $jsonBody # Validate the JSON specification file.
            $taskId = $response.id # Get the task id from the validation function.
            Do {
                # Keep checking until executionStatus is not IN_PROGRESS.
                $uri = "https://$sddcManager/v1/edge-clusters/validations/$taskId"
                $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers -ContentType 'application/json'
            } While ($response.executionStatus -eq "IN_PROGRESS")
            if ($response.executionStatus -eq "COMPLETED" -and $response.resultStatus -eq "SUCCEEDED") {
                Write-Output "Task validation completed successfully."
                Return $response
            } else {
                Write-Error "The validation task completed the run with the following errors: $($response.validationChecks.errorResponse.message)"
            }
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFEdgeCluster

#EndRegion APIs for managing NSX Edge Clusters


#Region APIs for managing Personalities

Function Get-VCFPersonality {
    <#
        .SYNOPSIS
        Retrieves the vSphere Lifecycle Manager personalities.

        .DESCRIPTION
        The Get-VCFPersonality cmdlet gets the vSphere Lifecycle Manager personalities which are available via depot access.

        .EXAMPLE
        Get-VCFPersonality
        This example shows how to retrieve a list of all vSphere Lifecycle Manager personalities availble in the depot.

        .EXAMPLE
        Get-VCFPersonality -id b4e3b2c4-31e8-4816-b1c5-801e848bef09
        This example shows how to retrieve a vSphere Lifecycle Manager personality by unique ID.

        .EXAMPLE
        Get-VCFPersonality -name vSphere-8.0U1
        This example shows how to retrieve a vSphere Lifecycle Manager personality by name.

        .PARAMETER id
        Specifies the unique ID of the vSphere Lifecycle Manager personality.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$name
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.

        if ((-Not $PsBoundParameters.ContainsKey('id')) -and (-Not $PsBoundParameters.ContainsKey('name'))) {
            $uri = "https://$sddcManager/v1/personalities"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/personalities/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }    
        if ($PsBoundParameters.ContainsKey("name")) {
            $uri = "https://$sddcManager/v1/personalities?personalityName=$name"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            # depending on the composition of the image, the response body may or may not contain elements
            if (!$response.elements) {
                $response
            } else {
                $response.elements
            }     
        }    
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFPersonality

Function New-VCFPersonality {
    <#
        .SYNOPSIS
        Creates a vSphere Lifecycle Manager personality/image in the SDDC Manager inventory from an existing vLCM image based cluster.

        .DESCRIPTION
        The New-VCFPersonality creates a vSphere Lifecycle Manager personalities/image in the SDDC Manager inventory from an existing vLCM cluster.

        .EXAMPLE
        New-VCFPersonality -name "vSphere 8.0U1" -vCenterId 6c7c3aaa-79cb-42fd-ade3-353f682cb1dc -clusterId "domain-c44"
        This example shows how to add a new vSphere Lifecycle Manager personality/image in the SDDC Manager inventory from an existing vLCM image based cluster.
        Retrieve the cluster ID from vCenter Server using $clusterId = (Get-Cluster -Name 'vLCM-Cluster').ExtensionData.MoRef.Value

        .PARAMETER name
        Specifies the image name.

        .PARAMETER vCenterId
        Specifies the unique ID of the vCenter Server from which the cluster image will be imported.

        .PARAMETER clusterId
        Specifies the unique ID of the vSphere cluster from which the image will be imported. Can be the vSphere MOID or cluster ID in SDDC Manager.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$name,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$vCenterId,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$clusterId
    )

    $Global:body = '{
        "uploadMode" : "REFERRED",
        "uploadSpecReferredMode" : {
        "vCenterId" : "'+ $vCenterId + '",
        "clusterId" : "'+ $clusterId + '"
  },
  "name" : "'+ $name + '"
    }'

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/personalities"
        $response = Invoke-RestMethod -Method POST -ContentType 'application/json'  -Uri $uri -Headers $headers -Body $body
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFPersonality

#EndRegion APIs for managing Personalities


#Region APIs for managing PSCs

Function Get-VCFPSC {
    <#
        .SYNOPSIS
        Retrieves a list of Platform Services Controllers.

        .DESCRIPTION
        The Get-VCFPSC cmdlet retrieves a list of all Platform Services Controllers.

        .EXAMPLE
        Get-VCFPSC
        This example shows how to retrieve a list of all Platform Services Controllers.

        .EXAMPLE
        Get-VCFPSC -id b4e3b2c4-31e8-4816-b1c5-801e848bef09
        This example shows how to retrieve a Platform Services Controller by unique ID.

        .PARAMETER id
        Specifies the unique ID of the Platform Services Controller.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ( -not $PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/pscs"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/pscs/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFPSC

#EndRegion APIs for managing PSCs


#Region APIs for managing Releases

Function Get-VCFRelease {
    <#
        .SYNOPSIS
        Retrieves a list of releases.

        .DESCRIPTION
        The Get-VCFRelease cmdlet returns all releases with options to return releases for a specified workload domain
        ID, releases for a specified version, all future releases for a specified version, all applicable releases for
        a specified target release, or all future releases for a specified workload domain ID.

        .EXAMPLE
        Get-VCFRelease
        This example shows how to retrieve a list of all releases.

        .EXAMPLE
        Get-VCFRelease -domainId 1a2b3c4d-5e6f-7g8h-9i0j-1k2l3m4n5o6p
        This example shows how to retrieve a list of all releases for a specified workload domain ID.

        .EXAMPLE
        Get-VCFRelease -versionEquals 4.4.1.0
        This example shows how to retrieve a release for a specified version.

        .EXAMPLE
        Get-VCFRelease -versionGreaterThan 4.4.1.0
        This example shows how to retrieve all future releases for a specified version.

        .EXAMPLE
        Get-VCFRelease -vxRailVersionEquals 4.4.1.0
        This example shows how to retrieve the release for a specified version on VxRail.

        .EXAMPLE
        Get-VCFRelease -vxRailVersionGreaterThan 4.4.1.0
        This example shows how to retrieve all future releases for a specified version on VxRail.

        .EXAMPLE
        Get-VCFRelease -applicableForVersion 4.4.1.0
        This example shows how to retrieve all applicable target releases for a version.

        .EXAMPLE
        Get-VCFRelease -applicableForVxRailVersion 4.4.1.0
        This example shows how to retrieve all applicable target releases for a version on VxRail.

        .EXAMPLE
        Get-VCFRelease -futureReleases -domainId 1a2b3c4d-5e6f-7g8h-9i0j-1k2l3m4n5o6p
        This example shows how to retrieve all future releases for a specified workload domain.

        .PARAMETER domainId
        Specifies the unique ID of the workload domain.

        .PARAMETER versionEquals
        Specifies the exact version of the release.

        .PARAMETER versionGreaterThan
        Specifies the version of the release to be greater than.

        .PARAMETER vxRailVersionEquals
        Specifies the exact version of the release on VxRail.

        .PARAMETER vxRailVersionGreaterThan
        Specifies the version of the release on VxRail to be greater than.

        .PARAMETER applicableForVersion
        Specifies the version of the release for which applicable target releases are to be retrieved.

        .PARAMETER applicableForVxRailVersion
        Specifies the version of the release on VxRail for which applicable target releases are to be retrieved.

        .PARAMETER futureReleases
        Specifies all future releases.
    #>

    [CmdletBinding(DefaultParametersetName = 'default')][OutputType('System.Management.Automation.PSObject')]

    Param (
        [Parameter (ParameterSetName = 'default', Mandatory = $false)]
        [Parameter (ParameterSetName = 'futureReleases', Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainId,
        [Parameter (ParameterSetName = 'versionEquals', Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$versionEquals,
        [Parameter (ParameterSetName = 'versionGreaterThan', Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$versionGreaterThan,
        [Parameter (ParameterSetName = 'vxRailVersionEquals', Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$vxRailVersionEquals,
        [Parameter (ParameterSetName = 'vxRailVersionGreaterThan', Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$vxRailVersionGreaterThan,
        [Parameter (ParameterSetName = 'vxRailVersionGreaterThan', Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$applicableForVersion,
        [Parameter (ParameterSetName = 'applicableForVxRailVersion', Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$applicableForVxRailVersion,
        [Parameter (ParameterSetName = 'futureReleases', Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$futureReleases
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ((Get-VCFManager -version) -ge '4.1.0' -and (-not $PsBoundParameters.ContainsKey('domainId')) -and (-not $PsBoundParameters.ContainsKey('versionEquals')) -and (-not $PsBoundParameters.ContainsKey('versionGreaterThan')) -and (-not $PsBoundParameters.ContainsKey('vxRailVersionEquals')) -and (-not $PsBoundParameters.ContainsKey('vxRailVersionGreaterThan')) -and (-not $PsBoundParameters.ContainsKey('applicableForVersion')) -and (-not $PsBoundParameters.ContainsKey('applicableForVxRailVersion')) -and (-not $PsBoundParameters.ContainsKey('futureReleases'))) {
            $uri = "https://$sddcManager/v1/releases"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } elseif ((Get-VCFManager -version) -ge '4.1.0' -and ($PsBoundParameters.ContainsKey('domainId')) -and (-not $PsBoundParameters.ContainsKey('futureReleases'))) {
            $uri = "https://$sddcManager/v1/releases?domainId=$domainId"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } elseif ((Get-VCFManager -version) -ge '4.1.0' -and ($PsBoundParameters.ContainsKey('versionEquals'))) {
            $uri = "https://$sddcManager/v1/releases?versionEq=$versionEquals"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } elseif ((Get-VCFManager -version) -ge '4.1.0' -and ($PsBoundParameters.ContainsKey('versionGreaterThan'))) {
            $uri = "https://$sddcManager/v1/releases?versionGt=$versionGreaterThan"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } elseif ((Get-VCFManager -version) -ge '4.1.0' -and ($PsBoundParameters.ContainsKey('applicableForVersion'))) {
            $uri = "https://$sddcManager/v1/releases?applicableForVersion=$applicableForVersion"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } elseif ((Get-VCFManager -version) -ge '4.4.0' -and ($PsBoundParameters.ContainsKey('vxRailVersionEquals'))) {
            $uri = "https://$sddcManager/v1/releases?vxRailVersionEq=$vxRailVersionEquals"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } elseif ((Get-VCFManager -version) -ge '4.4.0' -and ($PsBoundParameters.ContainsKey('vxRailVersionGreaterThan'))) {
            $uri = "https://$sddcManager/v1/releases?vxRailVersionGt=$vxRailVersionGreaterThan"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } elseif ((Get-VCFManager -version) -ge '4.4.0' -and ($PsBoundParameters.ContainsKey('applicableForVxRailVersion'))) {
            $uri = "https://$sddcManager/v1/releases?applicableForVxRailVersion=$applicableForVxRailVersion"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } elseif ((Get-VCFManager -version) -ge '4.4.0' -and ($PsBoundParameters.ContainsKey('futureReleases')) -and ($PsBoundParameters.ContainsKey('domainId'))) {
            $uri = "https://$sddcManager/v1/releases?getFutureReleases=true&domainId=$domainId"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } else {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFRelease

#EndRegion APIs for managing Releases


#Region APIs for managing SDDC (Cloud Builder)

Function Get-CloudBuilderSDDC {
    <#
        .SYNOPSIS
        Retrieves a list of management domain deployment tasks from VMware Cloud Builder.

        .DESCRIPTION
        The Get-CloudBuilderSDDC cmdlet retrieves a list of all SDDC deployments from VMware Cloud Builder.

        .EXAMPLE
        Get-CloudBuilderSDDC
        This example shows how to retrieve a list of all SDDC deployments from VMware Cloud Builder.

        .EXAMPLE
        Get-CloudBuilderSDDC -id 51cc2d90-13b9-4b62-b443-c1d7c3be0c23
        This example shows how to retrieve a SDDC deployment from VMware Cloud Builder by unique ID.

        .PARAMETER id
        Specifies the unique ID of the management domain deployment task.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createBasicAuthHeader # Sets the Basic Authenication header.
        if ( -not $PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$cloudBuilder/v1/sddcs"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } elseif ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$cloudBuilder/v1/sddcs/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-CloudBuilderSDDC

Function Start-CloudBuilderSDDC {
    <#
        .SYNOPSIS
        Starts a management domain deployment task on VMware Cloud Builder.

        .DESCRIPTION
        The Start-CloudBuilderSDDC cmdlet starts a management domain deployment task on VMware Cloud Builder using a JSON specification file.

        .EXAMPLE
        Start-CloudBuilderSDDC -json .\samples\sddc\sddcSpec.json
        This example shows how to start a management domain deployment task on VMware Cloud Builder using a JSON specification file.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createBasicAuthHeader # Sets the Basic Authenication header.
        $uri = "https://$cloudBuilder/v1/sddcs"
        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-CloudBuilderSDDC

Function Restart-CloudBuilderSDDC {
    <#
        .SYNOPSIS
        Retry a failed management domain deployment task on VMware Cloud Builder.

        .DESCRIPTION
        The Restart-CloudBuilderSDDC cmdlet retries a failed management domain deployment task on VMware Cloud Builder.

        .EXAMPLE
        Restart-CloudBuilderSDDC -id bedf19f8-9dfe-4c60-aae4-bca986a65a31
        This example shows how to retry a deployment on VMware Cloud Builder based on the ID.

        .EXAMPLE
        Restart-CloudBuilderSDDC -id bedf19f8-9dfe-4c60-aae4-bca986a65a31 -json .\samples\SDDC\SddcSpec.json
        This example shows how to retry a deployment on VMware Cloud Builder based on the ID and an updated JSON specification file.

        .PARAMETER id
        Specifies the unique ID of the management domain deployment task.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createBasicAuthHeader # Sets the Basic Authenication header.
        if ($PsBoundParameters.ContainsKey("id") -and ($PsBoundParameters.ContainsKey("json"))) {
            validateJsonInput # Calls validateJsonInput Function to check the JSON file provided exists
            $uri = "https://$cloudBuilder/v1/sddcs/$id"
            $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        } elseif ($PsBoundParameters.ContainsKey("id") -and (-not $PsBoundParameters.ContainsKey("json"))) {
            $uri = "https://$cloudBuilder/v1/sddcs/$id"
            $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Restart-CloudBuilderSDDC

Function Get-CloudBuilderSDDCValidation {
    <#
        .SYNOPSIS
        Retrieves a list of management domain validations tasks from VMware Cloud Builder.

        .DESCRIPTION
        The Get-CloudBuilderSDDCValidation cmdlet cmdlet retrieves a list of all SDDC validations
        from VMware Cloud Builder.

        .EXAMPLE
        Get-CloudBuilderSDDCValidation
        This example shows how to retrieve a list of all SDDC validations from VMware Cloud Builder.

        .EXAMPLE
        Get-CloudBuilderSDDCValidation -id 1ff80635-b878-441a-9e23-9369e1f6e5a3
        This example shows how to retrieve a SDDC validation from VMware Cloud Builder by unique ID.

        .PARAMETER id
        Specifies the unique ID of the management domain validation task.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createBasicAuthHeader # Sets the Basic Authenication header.
        if ( -not $PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$cloudBuilder/v1/sddcs/validations"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } elseif ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$cloudBuilder/v1/sddcs/validations/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-CloudBuilderSDDCValidation

Function Start-CloudBuilderSDDCValidation {
    <#
        .SYNOPSIS
        Start the validation of a management domain JSON specification file on VMware Cloud Builder.

        .DESCRIPTION
        The Start-CloudBuilderSDDCValidation cmdlet starts the validation of a management domain JSON specification file on VMware Cloud Builder.

        .EXAMPLE
        Start-CloudBuilderSDDCValidation -json .\samples\SDDC\SddcSpec.json
        This example shows how to start the validation of a management domain JSON specification file on VMware Cloud Builder.

        .EXAMPLE
        Start-CloudBuilderSDDCValidation -json .\samples\SDDC\SddcSpec.json -validation LICENSE_KEY_VALIDATION
        This example shows how to start the validation of a specific item in a management domain JSON specification file on VMware Cloud Builder.

        .PARAMETER json
        Specifies the JSON specification to be used.

        .PARAMETER validation
        Specifies the validation to be performed.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateSet("JSON_SPEC_VALIDATION", "LICENSE_KEY_VALIDATION", "TIME_SYNC_VALIDATION", "NETWORK_IP_POOLS_VALIDATION", "NETWORK_CONFIG_VALIDATION", "MANAGEMENT_NETWORKS_VALIDATION", "ESXI_VERSION_VALIDATION", "ESXI_HOST_READINESS_VALIDATION", "PASSWORDS_VALIDATION", "HOST_IP_DNS_VALIDATION", "CLOUDBUILDER_READY_VALIDATION", "VSAN_AVAILABILITY_VALIDATION", "NSXT_NETWORKS_VALIDATION", "AVN_NETWORKS_VALIDATION", "SECURE_PLATFORM_AUDIT")] [String]$validation
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createBasicAuthHeader # Sets the Basic Authenication header.
        if (-not $PsBoundParameters.ContainsKey("validation")) {
            $uri = "https://$cloudBuilder/v1/sddcs/validations"
            $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        }
        if ($PsBoundParameters.ContainsKey("validation")) {
            $uri = "https://$cloudBuilder/v1/sddcs/validations?name=$validation"
            $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-CloudBuilderSDDCValidation

Function Stop-CloudBuilderSDDCValidation {
    <#
        .SYNOPSIS
        Stop the in-progress validation of a management domain JSON specification file on VMware Cloud Builder.

        .DESCRIPTION
        The Stop-CloudBuilderSDDCValidation cmdlet stops the in-progress validation of a management domain JSON
        specification file on VMware Cloud Builder.

        .EXAMPLE
        Stop-CloudBuilderSDDCValidation -id bedf19f8-9dfe-4c60-aae4-bca986a65a31
        This example shows how to stop a validation on VMware Cloud Builder based on the ID.

        .PARAMETER id
        Specifies the unique ID of the management domain validation task.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createBasicAuthHeader # Sets the Basic Authenication header.
        $uri = "https://$cloudBuilder/v1/sddcs/validations/$id"
        $response = Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Stop-CloudBuilderSDDCValidation

Function Restart-CloudBuilderSDDCValidation {
    <#
        .SYNOPSIS
        Retry a failed management domain validation task on VMware Cloud Builder.

        .DESCRIPTION
        The Restart-CloudBuilderSDDCValidation retries a failed management domain validation task
        on VMware Cloud Builder.

        .EXAMPLE
        Restart-CloudBuilderSDDCValidation -id bedf19f8-9dfe-4c60-aae4-bca986a65a31
        This example shows how to retry a validation on VMware Cloud Builder based on the ID.

        .PARAMETER id
        Specifies the unique ID of the management domain validation task.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createBasicAuthHeader # Sets the Basic Authenication header.
        $uri = "https://$cloudBuilder/v1/sddcs/validations/$id"
        $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Restart-CloudBuilderSDDCValidation

#EndRegion APIs for managing SDDC (Cloud Builder)


#Region APIs for managing SDDC Manager

Function Get-VCFManager {
    <#
        .SYNOPSIS
        Retrieves a list of SDDC Managers.

        .DESCRIPTION
        The Get-VCFManager cmdlet retrieves a list of SDDC Managers.

        .EXAMPLE
        Get-VCFManager
        This example shows how to retrieve a list of SDDC Managers.

        .EXAMPLE
        Get-VCFManager -id 60d6b676-47ae-4286-b4fd-287a888fb2d0
        This example shows how to return the details for a specific SDDC Manager based on the domain ID of a workload domain.

        .EXAMPLE
        Get-VCFManager -domainId 1a6291f2-ed54-4088-910f-ead57b9f9902
        This example shows how to return the details for a specific SDDC Manager based on a workload domains unique ID

        .EXAMPLE
        Get-VCFManager -version
        This example shows how to return the SDDC Manager version in `x.y.z` format.

        .EXAMPLE
        Get-VCFManager -build
        This example shows how to return the SDDC Manager build number in `xxxxxxx` format.

        .PARAMETER id
        Specifies the unique ID of the SDDC Manager.

        .PARAMETER domainId
        Specifies the unique ID of the workload domain.

        .PARAMETER version
        Specifies to return the SDDC Manager version in `x.y.z` format.

        .PARAMETER build
        Specifies to return the SDDC Manager build number in `xxxxxxx` format.
        #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$domainId,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$version,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$build
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.

        $patternVersion = '^(\d+\.\d+\.\d+\.\d+)'
        $patternBuild = '(\d+)$'

        if ($PsBoundParameters.ContainsKey('version') -and ($PsBoundParameters.ContainsKey('build')) ) {
            Write-Error 'You can only specify one of the following parameters: version, build.'
            Break
        } else {
            if ($PsBoundParameters.ContainsKey('id')) {
                $uri = "https://$sddcManager/v1/sddc-managers/$id"
                $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
                $vcfVersion = $response.version
                if ($PsBoundParameters.ContainsKey('version')) {
                    $matches = [regex]::Match($vcfVersion, $patternVersion)
                    $versionNumber = $matches.Groups[1].Value
                    $versionNumber
                } elseif ($PsBoundParameters.ContainsKey('build')) {
                    $matches = [regex]::Match($vcfVersion, $patternBuild)
                    $buildNumber = $matches.Groups[1].Value
                    $buildNumber
                } else {
                    $response
                }
            }
            if (-not $PsBoundParameters.ContainsKey('id') -and (-not $PsBoundParameters.ContainsKey('domainId')) ) {
                $uri = "https://$sddcManager/v1/sddc-managers"
                $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
                $vcfVersion = $response.elements.version
                if ($PsBoundParameters.ContainsKey('version')) {
                    $matches = [regex]::Match($vcfVersion, $patternVersion)
                    $versionNumber = $matches.Groups[1].Value
                    $versionNumber
                } elseif ($PsBoundParameters.ContainsKey('build')) {
                    $matches = [regex]::Match($vcfVersion, $patternBuild)
                    $buildNumber = $matches.Groups[1].Value
                    $buildNumber
                } else {
                    $response.elements
                }
            }
            if ($PsBoundParameters.ContainsKey('domainId')) {
                $uri = "https://$sddcManager/v1/sddc-managers/?domain=$domainId"
                $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
                $vcfVersion = $response.elements.version
                if ($PsBoundParameters.ContainsKey('version')) {
                    $matches = [regex]::Match($vcfVersion, $patternVersion)
                    $versionNumber = $matches.Groups[1].Value
                    $versionNumber
                } elseif ($PsBoundParameters.ContainsKey('build')) {
                    $matches = [regex]::Match($vcfVersion, $patternBuild)
                    $buildNumber = $matches.Groups[1].Value
                    $buildNumber
                } else {
                    $response.elements
                }
            }
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFManager

#EndRegion APIs for managing SDDC Manager


#Region APIs for managing Services

Function Get-VCFService {
    <#
        .SYNOPSIS
        Retrieves a list of services running on SDDC Manager.

        .DESCRIPTION
        The Get-VCFService cmdlet retrieves the list of services running on SDDC Manager.

        .EXAMPLE
        Get-VCFService
        This example shows how to retrieve a list of all services running on SDDC Manager.

        .EXAMPLE
        Get-VCFService -id 4e416419-fb82-409c-ae37-32a60ba2cf88
        This example shows how to return the details for a specific service running on SDDC Manager by unique ID.

        .PARAMETER id
        Specifics the unique ID of the service running on SDDC Manager.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey('id')) {
            $uri = "https://$sddcManager/v1/vcf-services/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
        if (-not $PsBoundParameters.ContainsKey('id')) {
            $uri = "https://$sddcManager/v1/vcf-services"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFService

#EndRegion APIs for managing Services


#Region APIs for managing SOS

Function Get-VCFHealthSummaryTask {
    <#
        .SYNOPSIS
        Retrieves the Health Summary tasks.

        .DESCRIPTION
        The Get-VCFHealthSummaryTask cmdlet retrieves the Health Summary tasks.

        .EXAMPLE
        Get-VCFHealthSummaryTask
        This example shows how to retrieve the Health Summary tasks.

        .EXAMPLE
        Get-VCFHealthSummaryTask -id <task_id>
        This example shows how to retrieve the Health Summary task by unique ID.

        .PARAMETER id
        Specifies the unique ID of the Health Summary task.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        if ((Get-VCFManager -version) -ge "4.4.0") {
            createHeader # Set the Accept and Authorization headers.
            checkVCFToken # Validate the access token and refresh, if necessary.
            if ($PsBoundParameters.ContainsKey("id")) {
                $uri = "https://$sddcManager/v1/system/health-summary/$id"
                $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
                $response
            } else {
                $uri = "https://$sddcManager/v1/system/health-summary"
                $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
                $response.elements
            }
        } else {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFHealthSummaryTask

Function Request-VCFHealthSummaryBundle {
    <#
        .SYNOPSIS
        Downloads the Health Summary bundle.

        .DESCRIPTION
        The Request-VCFHealthSummaryBundle cmdlet downloads the Health Summary bundle.

        .EXAMPLE
        Request-VCFHealthSummaryBundle -id <id>
        This example shows how to download a Health Summary bundle.

        .PARAMETER id
        Specifies the unique ID of the Health Summary task.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        if ((Get-VCFManager -version) -ge "4.4.0") {
            checkVCFToken # Validate the access token and refresh, if necessary.
            $vcfHeaders = @{"Accept" = "application/octet-stream" }
            $vcfHeaders.Add("ContentType", "application/octet-stream")
            $vcfHeaders.Add("Authorization", "Bearer $accessToken")
            $uri = "https://$sddcManager/v1/system/health-summary/$id/data"
            Invoke-RestMethod -Method GET -Uri $uri -Headers $vcfHeaders -OutFile "health-summary-$id.tar"
        } else {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Request-VCFHealthSummaryBundle

Function Start-VCFHealthSummary {
    <#
        .SYNOPSIS
        Starts the Health Summary checks.

        .DESCRIPTION
        The Start-VCFHealthSummary cmdlet starts the Health Summary checks.

        .EXAMPLE
        Start-VCFHealthSummary -json (Get-Content -Raw .\samples\sos\healthSummarySpec.json)
        This example shows how to start the Health Summary checks using the JSON specification file.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        if ((Get-VCFManager -version) -ge "4.4.0") {
            $jsonBody = validateJsonInput -json $json
            createHeader # Set the Accept and Authorization headers.
            checkVCFToken # Validate the access token and refresh, if necessary.
            $uri = "https://$sddcManager/v1/system/health-summary"
            $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        } else {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-VCFHealthSummary

Function Get-VCFSupportBundleTask {
    <#
        .SYNOPSIS
        Retrieves the support bundle tasks.

        .DESCRIPTION
        The Get-VCFSupportBundleTask cmdlet retrieves the support bundle tasks.

        .EXAMPLE
        Get-VCFSupportBundleTask
        This example shows how to retrieve the support bundle tasks.

        .EXAMPLE
        Get-VCFSupportBundleTask -id <task_id>
        This example shows how to retrieve the support bundle tasks based on the unique ID.

        .PARAMETER id
        Specifies the unique ID of the support bundle task.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        if ((Get-VCFManager -version) -ge "4.4.0") {
            createHeader # Set the Accept and Authorization headers.
            checkVCFToken # Validate the access token and refresh, if necessary.
            if ($PsBoundParameters.ContainsKey("id")) {
                $uri = "https://$sddcManager/v1/system/support-bundles/$id"
                $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
                $response
            } else {
                $uri = "https://$sddcManager/v1/system/support-bundles"
                $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
                $response.elements
            }
        } else {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFSupportBundleTask

Function Request-VCFSupportBundle {
    <#
        .SYNOPSIS
        Downloads the support bundle.

        .DESCRIPTION
        The Request-VCFSupportBundle cmdlet downloads the support bundle.

        .EXAMPLE
        Request-VCFSupportBundle -id 12345678-1234-1234-1234-123456789012
        This example shows how to download the support bundle by unique ID.

        .PARAMETER id
        Specifies the unique ID of the support bundle task.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        if ((Get-VCFManager -version) -ge "4.4.0") {
            checkVCFToken # Validate the access token and refresh, if necessary.
            $vcfHeaders = @{"Accept" = "application/octet-stream" }
            $vcfHeaders.Add("Authorization", "Bearer $accessToken")
            $uri = "https://$sddcManager/v1/system/support-bundles/$id/data"
            Invoke-RestMethod -Method GET -Uri $uri -Headers $vcfHeaders -OutFile "support-bundle-$id.tar"
        } else {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Request-VCFSupportBundle

Function Start-VCFSupportBundle {
    <#
        .SYNOPSIS
        Starts the support bundle generation.

        .DESCRIPTION
        The Start-VCFSupportBundle cmdlet starts the support bundle generation.

        .EXAMPLE
        Start-VCFSupportBundle -json (Get-Content -Raw .\samples\sos\supportBundleSpec.json)
        This example shows how to start the support bundle generation using a JSON specification file.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        if ((Get-VCFManager -version) -ge "4.4.0") {
            $jsonBody = validateJsonInput -json $json
            createHeader # Set the Accept and Authorization headers.
            checkVCFToken # Validate the access token and refresh, if necessary.
            $uri = "https://$sddcManager/v1/system/support-bundles"
            $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        } else {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-VCFSupportBundle

#EndRegion APIs for managing SOS


#Region APIs for managing System Prechecks

Function Start-VCFSystemPrecheck {
    <#
        .SYNOPSIS
        Starts the system level health check.

        .DESCRIPTION
        The Start-VCFSystemPrecheck cmdlet performs system level health checks and upgrade pre-checks.

        .EXAMPLE
        Start-VCFSystemPrecheck -json (Get-Content -Raw .\samples\system-prechecks\precheckSpec.json)
        This example shows how to perform system level health checks and upgrade pre-checks using the JSON specification file.

        .PARAMETER json
        Specifies the JSON specification to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/system/prechecks"
        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-VCFSystemPrecheck

Function Get-VCFSystemPrecheckTask {
    <#
        .SYNOPSIS
        Retrieves the status of a system level precheck task.

        .DESCRIPTION
        The Get-VCFSystemPrecheckTask cmdlet retrieves the status of a system level precheck task that can be polled
        and monitored.

        .EXAMPLE
        Get-VCFSystemPrecheckTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d
        This example shows how to retrieve the status of a system level precheck task by unique ID.

        .EXAMPLE
        Get-VCFSystemPrecheckTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d -failureOnly
        This example shows how to retrieve only failed subtasks from the system level precheck task by unique ID.

        .PARAMETER id
        Specifies the unique ID of the system level precheck task.

        .PARAMETER failureOnly
        Specifies to return only the failed subtasks.
      
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$failureOnly
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/system/prechecks/tasks/$id"
    
        Do {
            # Keep checking until status is not IN_PROGRESS
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers -ContentType 'application/json'
            Start-Sleep -Seconds 2
        } While ($response.status -eq "IN_PROGRESS")
        
        if ($response.status -eq "FAILED" -and $PsBoundParameters.ContainsKey("failureOnly")) {
            $failed_task = $response.subTasks | Where-Object { $_.status -eq "FAILED" }
            $failed_subtask = $failed_task.stages | Where-Object { $_.status -eq "FAILED" }
            $failed_subtask
        } else {
            $response
        }
        
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFSystemPrecheckTask

#EndRegion APIs for managing System Prechecks


#Region APIs for managing Tasks

Function Get-VCFTask {
    <#
        .SYNOPSIS
        Retrieves a list of tasks.

        .DESCRIPTION
        The Get-VCFTask cmdlet retrieves a list of tasks from the SDDC Manager.

        .EXAMPLE
        Get-VCFTask
        This example shows how to retrieve all tasks.

        .EXAMPLE
        Get-VCFTask -id 7e1c2eee-3177-4e3b-84db-bfebc83f386a
        This example shows how to retrieve a task by unique ID.

        .EXAMPLE
        Get-VCFTask -status SUCCESSFUL
        This example shows how to retrieve all tasks with a specific status.

        .PARAMETER id
        Specifies the unique ID of the task.

        .PARAMETER status
        Specifies the status of the task. One of: SUCCESSFUL, FAILED.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateSet("SUCCESSFUL", "FAILED")] [String]$status
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ( -not $PsBoundParameters.ContainsKey("id") -and ( -not $PsBoundParameters.ContainsKey("status"))) {
            $uri = "https://$sddcManager/v1/tasks/"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/tasks/$id"
            Try {
                $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            } Catch {
                if ($_.Exception.Message -eq "The remote server returned an error: (404) Not Found.") {
                    Write-Error "Task with ID $id not found."
                } else {
                    ResponseException -object $_
                }
            }
            $response
        } elseif ($PsBoundParameters.ContainsKey("status")) {
            $uri = "https://$sddcManager/v1/tasks/"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements | Where-Object { $_.status -eq $status }
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFTask

Function Restart-VCFTask {
    <#
        .SYNOPSIS
        Retries a previously failed task.

        .DESCRIPTION
        The Restart-VCFTask cmdlet retries a previously failed task based on the unique ID of the task.

        .EXAMPLE
        Restart-VCFTask -id 7e1c2eee-3177-4e3b-84db-bfebc83f386a
        This example shows how to restart a task by unique ID.

        .PARAMETER id
        Specifies the unique ID of the task.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/tasks/$id"
        $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Restart-VCFTask

#EndRegion APIs for managing Tasks


#Region APIs for managing Access and Refresh Token (Not Exported)

Function checkVCFToken {
    if (!$accessToken) {
        Write-Error "API Access Token Required. Request an Access Token by running Request-VCFToken"
        Break
    } else {
        $expiryDetails = Get-JWTDetail $accessToken
        if ($expiryDetails.timeToExpiry.Hours -eq 0 -and $expiryDetails.timeToExpiry.Minutes -lt 2) {
            Write-Output "API Access Token Expired. Requesting a new access token with current refresh token."
            $headers = @{"Accept" = "application/json" }
            $headers.Add("Content-Type", "application/json")
            $uri = "https://$sddcManager/v1/tokens/access-token/refresh"
            $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -Body $refreshToken
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
            0 { Break }
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
            0 { Break }
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

#EndRegion APIs for managing Access and Refresh Token (Not Exported)


#Region APIs for managing Upgradables

Function Get-VCFUpgradable {
    <#
        .SYNOPSIS
        Retrieves a list of upgradables.

        .DESCRIPTION
        The Get-VCFUpgradable cmdlet retrieves a list of upgradables from SDDC Manager.

        .EXAMPLE
        Get-VCFUpgradable
        This example shows how to retrieve the list of upgradables from SDDC Manager.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/system/upgradables"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers -ContentType 'application/json'
        $response.elements
    } Catch {
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
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ( -not $PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/upgrades"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/upgrades/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
    } Catch {
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

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/upgrades"

        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Start-VCFUpgrade

#EndRegion APIs for managing Upgrades


#Region APIs for managing Users

Function Get-VCFUser {
    <#
        .SYNOPSIS
        Retrieves a list of users, groups, and service users.

        .DESCRIPTION
        The Get-VCFUser cmdlet retrieves a list of users, groups, and service users from SDDC Manager.

        .EXAMPLE
        Get-VCFUser
        This example shows how to retrieve a list of users, groups, and service users from SDDC Manager.

        .EXAMPLE
        Get-VCFUser -type USER
        This example shows how to retrieve a list of users from SDDC Manager.

        .EXAMPLE
        Get-VCFUser -type GROUP
        This example shows how to retrieve a list of groups from SDDC Manager.

        .EXAMPLE
        Get-VCFUser -type SERVICE
        This example shows how to retrieve a list of service users from SDDC Manager.

        .EXAMPLE
        Get-VCFUser -domain rainpole.io
        This example shows how to retrieve a list of users, groups, and service users from an authentication domain.

        .PARAMETER type
        Specifies the type of user to retrieve. One of: USER, GROUP, SERVICE.

        .PARAMETER domain
        Specifies the authentication domain to retrieve users from.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateSet("USER", "GROUP", "SERVICE")] [String]$type,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$domain
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/users"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        if ($PsBoundParameters.ContainsKey("type")) {
            $response.elements | Where-Object { $_.type -eq $type }
        } elseif ($PsBoundParameters.ContainsKey("domain")) {
            $response.elements | Where-Object { $_.domain -eq $domain }
        } else {
            $response.elements
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFUser

Function New-VCFUser {
    <#
        .SYNOPSIS
        Adds a new user.

        .DESCRIPTION
        The New-VCFUser cmdlet adds a new user to SDDC Manager with a specified role.

        .EXAMPLE
        New-VCFUser -user vcf-admin@rainpole.io -role ADMIN
        This example shows how to add a new user with a specified role.

        .PARAMETER user
        Specifies the name of the user.

        .PARAMETER role
        Specifies the role for the user. One of: ADMIN, OPERATOR, VIEWER.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$user,
        [Parameter (Mandatory = $true)] [ValidateSet("ADMIN", "OPERATOR", "VIEWER")] [String]$role
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/users"
        # Get the Role ID.
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
        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $body
        $response.elements
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFUser

Function New-VCFServiceUser {
    <#
        .SYNOPSIS
        Adds a service user.

        .DESCRIPTION
        The New-VCFServiceUser cmdlet adds a service user to SDDC Manager with a specified role.

        .EXAMPLE
        New-VCFServiceUser -user svc-user@rainpole.io -role ADMIN
        This example shows how to add a service user with a specified role.

        .PARAMETER user
        Specifies the name of the service user.

        .PARAMETER role
        Specifies the role for the service user. One of: ADMIN, OPERATOR, VIEWER.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$user,
        [Parameter (Mandatory = $true)] [ValidateSet("ADMIN", "OPERATOR", "VIEWER")] [String]$role
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/users"
        # Get the Role ID.
        $roleID = Get-VCFRole | Where-object { $_.name -eq $role } | Select-Object -ExpandProperty id
        $body = '[ {
            "name" : "'+ $user + '",
            "type" : "SERVICE",
            "role" : {
            "id" : "'+ $roleID + '"
        }
        }]'
        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $body
        $response.elements
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFServiceUser

Function Get-VCFRole {
    <#
        .SYNOPSIS
        Retrieves a list of roles.

        .DESCRIPTION
        The Get-VCFRole cmdlet retrieves a list of roles from SDDC Manager.

        .EXAMPLE
        Get-VCFRole
        This example shows how to retrieve a list of roles from SDDC Manager.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/roles"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response.elements
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFRole

Function Remove-VCFUser {
    <#
        .SYNOPSIS
        Removes a user.

        .DESCRIPTION
        The Remove-VCFUser cmdlet removes a user from SDDC Manager.

        .EXAMPLE
        Remove-VCFUser -id c769fcc5-fb61-4d05-aa40-9c7786163fb5
        This example shows how to remove a user from SDDC Manager.

        .PARAMETER id
        Specifies the unique ID of the user to remove.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/users/$id"
        $response = Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers -ContentType 'application/json'
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Remove-VCFUser

Function New-VCFGroup {
    <#
        .SYNOPSIS
        Adds a new group with a specified role.

        .DESCRIPTION
        The New-VCFGroup cmdlet adds a new group with a specified role to SDDC Manager.

        .EXAMPLE
        New-VCFGroup -group ug-vcf-group -domain rainpole.io -role ADMIN
        This example shows how to add a new group with a specified role.

        .PARAMETER group
        Specifies the name of the group.

        .PARAMETER domain
        Specifies the authentication domain for the group.

        .PARAMETER role
        Specifies the role for the group in the SDDC Manager. One of: ADMIN, OPERATOR, VIEWER.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$group,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domain,
        [Parameter (Mandatory = $true)] [ValidateSet("ADMIN", "OPERATOR", "VIEWER")] [String]$role
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/users"
        # Get the Role ID.
        $roleID = Get-VCFRole | Where-object { $_.name -eq $role } | Select-Object -ExpandProperty id
        $body = '[{
            "name" : "'+ $group + '",
            "domain" : "'+ $domain.ToUpper() + '",
            "type" : "GROUP",
            "role" : {
            "id" : "'+ $roleID + '"
        }
        }]'
        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $body
        $response.elements
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function New-VCFGroup

#EndRegion APIs for managing Users


#Region APIs for managing DNS and NTP Configuration

Function Get-VCFConfigurationDNS {
    <#
        .SYNOPSIS
        Retrieves the DNS configuration.

        .DESCRIPTION
        The Get-VCFConfigurationDNS cmdlet retrieves the DNS configuration from SDDC Manager.

        .EXAMPLE
        Get-VCFConfigurationDNS
        This example shows how to retrieve the DNS configuration from SDDC Manager.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/system/dns-configuration"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response.dnsServers
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFConfigurationDNS

Function Get-VCFConfigurationDNSValidation {
    <#
        .SYNOPSIS
        Retrieves the status of the validation of the DNS configuration.

        .DESCRIPTION
        The Get-VCFConfigurationDNSValidation cmdlet retrieves the status of the validation of the DNS configuration.
        JSON

        .EXAMPLE
        Get-VCFConfigurationDNSValidation -id d729fcc5-fb61-2d05-aa40-9c7686163fa1
        This example shows how to retrieve the status of the validation of the DNS configuration.

        .PARAMETER id
        Specifies the unique ID of the validation task.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/system/dns-configuration/validations/$id"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFConfigurationDNSValidation

Function Set-VCFConfigurationDNS {
    <#
        .SYNOPSIS
        Sets the DNS configuration for all systems managed by SDDC Manager.

        .DESCRIPTION
        The Set-VCFConfigurationDNS cmdlet sets the DNS configuration for all systems managed by SDDC Manager.

        .EXAMPLE
        Set-VCFConfigurationDNS -json $jsonSpec
        This example shows how to configure the DNS Servers for all systems managed by SDDC Manager using a variable

        .EXAMPLE
        Set-VCFConfigurationDNS -json (Get-Content -Raw .\samples\dns-ntp\dnsSpec.json)
        This example shows how to set the DNS configuration for all systems managed by SDDC Manager using a JSON specification file.

        .EXAMPLE
        Set-VCFConfigurationDNS -json (Get-Content -Raw .\samples\dns-ntp\dnsSpec.json) -validate
        This example shows how to validate the DNS configuration.

        .PARAMETER json
        Specifies the JSON specification to be used.

        .PARAMETER validate
        Specifies to validate the JSON specification file.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$validate
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey("validate")) {
            $uri = "https://$sddcManager/v1/system/dns-configuration/validations"
            $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        } else {
            $uri = "https://$sddcManager/v1/system/dns-configuration"
            $response = Invoke-RestMethod -Method PUT -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFConfigurationDNS

Function Get-VCFConfigurationNTP {
    <#
        .SYNOPSIS
        Retrieves the NTP configuration.

        .DESCRIPTION
        The Get-VCFConfigurationNTP cmdlet retrieves the NTP configuration from SDDC Manager.

        .EXAMPLE
        Get-VCFConfigurationNTP
        This example shows how to retrieve the NTP configuration from SDDC Manager.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/system/ntp-configuration"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response.ntpServers
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFConfigurationNTP

Function Get-VCFConfigurationNTPValidation {
    <#
        .SYNOPSIS
        Retrieves the status of the validation of the NTP configuration.

        .DESCRIPTION
        The Get-VCFConfigurationNTPValidation cmdlet retrieves the status of the validation of the NTP configuration.

        .EXAMPLE
        Get-VCFConfigurationNTPValidation -id a749fcc5-fb61-2d05-aa40-9c7686164fc2
        This example shows how to retrieve the status of the validation of the NTP configuration.

        .PARAMETER id
        Specifies the unique ID of the validation task.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/system/ntp-configuration/validations/$id"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFConfigurationNTPValidation

Function Set-VCFConfigurationNTP {
    <#
        .SYNOPSIS
        Sets the NTP configuration for all systems managed by SDDC Manager.

        .DESCRIPTION
        The Set-VCFConfigurationNTP cmdlet sets the NTP configuration for all systems managed by SDDC Manager.

        .EXAMPLE
        Set-VCFConfigurationNTP (Get-Content -Raw .\samples\dns-ntp\ntpSpec.json)
        This example shows how to set the NTP configuration for all systems managed by SDDC Manager using a JSON specification file.

        .EXAMPLE
        Set-VCFConfigurationNTP -json (Get-Content -Raw .\samples\dns-ntp\ntpSpec.json) -validate
        This example shows how to validate the NTP configuration.

        .PARAMETER json
        Specifies the JSON specification to be used.

        .PARAMETER validate
        Specifies to validate the JSON specification file.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$validate
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey("validate")) {
            $uri = "https://$sddcManager/v1/system/ntp-configuration/validations"
            $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        } else {
            $uri = "https://$sddcManager/v1/system/ntp-configuration"
            $response = Invoke-RestMethod -Method PUT -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFConfigurationNTP

#EndRegion APIs for managing DNS and NTP


#Region APIs for managing Proxy Configuration

Function Get-VCFProxy {
    <#
        .SYNOPSIS
        Gets the proxy configuration for the SDDC Manager.

        .DESCRIPTION
        The Get-VCFProxy cmdlet retrieves the proxy configuration of the SDDC Manager.

        .EXAMPLE
        Get-VCFProxy
        This example shows how to get the proxy configuration of the SDDC Manager.
    #>

    Try {
        if ((Get-VCFManager -version) -ge '4.5.0') {
            createHeader
            checkVCFToken
            $uri = "https://$sddcManager/v1/system/proxy-configuration"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers -ContentType 'application/json'
            $response
        } else {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFProxy

Function Set-VCFProxy {
    <#
        .SYNOPSIS
        Sets the proxy configuration for the SDDC Manager.

        .DESCRIPTION
        The Set-VCFProxy cmdlet sets the proxy configuration of the SDDC Manager.
        Note: This cmdlet will not clear the proxy configuration.

        .EXAMPLE
        Set-VCFProxy -status ENABLED -proxyHost proxy.rainpole.io -proxyPort 3128
        This example shows how to enable the proxy configuration of the SDDC Manager.

        .EXAMPLE
        Set-VCFProxy -status DISABLED
        This example shows how to disable the proxy configuration of the SDDC Manager.

        .PARAMETER status
        Enable or disable the proxy configuration.

        .PARAMETER proxyHost
        The fully qualified domain name or IP address of the proxy.

        .PARAMETER proxyPort
        The port number of the proxy.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateSet("ENABLED", "DISABLED")] [ValidateNotNullOrEmpty()] [String]$status,
        [Parameter (Mandatory = $false, ParameterSetName = 'proxy')] [ValidateNotNullOrEmpty()] [String]$proxyHost,
        [Parameter (Mandatory = $false, ParameterSetName = 'proxy')] [ValidateNotNullOrEmpty()] [ValidateRange(1,65535)] [Int]$proxyPort
    )

    Try {
        if ((Get-VCFManager -version) -ge '4.5.0') {
            if ($status -eq "ENABLED") { $isEnabled = $true } else { $isEnabled = $false }
            if ($isEnabled -eq $false -and ($proxyHost -or $proxyPort)) {
                Write-Warning "The proxy host and port should not be specified when disabling the proxy configuration."
                Break
            } elseif ($isEnabled -eq $true -and (!$proxyHost -or !$proxyPort)) {
                Write-Error "The proxy host and port must be specified when enabling the proxy configuration."
                Break
            } elseif ($isEnabled -eq $true -and ($proxyHost -ne $null -and $proxyPort -ne $null)) {
                if ($PSVersionTable.PSEdition -eq 'Core') {
                    $connection = Test-Connection -TargetName $proxyHost -TcpPort $proxyPort -Quiet
                    if (!$connection) {
                        Write-Error "The proxy host $proxyHost is not reachable on port TCP $proxyPort."
                    }
                } elseif ($PSVersionTable.PSEdition -eq 'Desktop') {
                    $OriginalProgressPreference = $Global:ProgressPreference
                    $Global:ProgressPreference = 'SilentlyContinue'
                    $testConnection = Test-NetConnection -ComputerName $proxyHost -Port $proxyPort -WarningAction SilentlyContinue
                    $Global:ProgressPreference = $OriginalProgressPreference
                    $connection = $testConnection.TcpTestSucceeded
                    if (!$connection) {
                        Write-Error "The proxy host $proxyHost is not reachable on port TCP $proxyPort."
                    }
                }
            } else {
                $connection = $true
            }

            if ($connection) {
                createHeader
                checkVCFToken
                $uri = "https://$sddcManager/v1/system/proxy-configuration"
                $body = @{
                    "isEnabled" = $isEnabled
                }
                if ($isEnabled -eq $true -and ($proxyHost -ne $null -and $proxyPort -ne $null)) {
                    $body.Add("host", $proxyHost)
                    $body.Add("port", $proxyPort)
                }
                $body = $body | ConvertTo-Json -Depth 4 -Compress
                Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -ContentType 'application/json' -Body $body
            }
        } else {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Set-VCFProxy

#EndRegion APIs for managing Proxy Configuration


#Region APIs for managing vCenter Server

Function Get-VCFvCenter {
    <#
        .SYNOPSIS
        Retrieves a list of vCenter Servers instances managed by SDDC Manager.

        .DESCRIPTION
        The Get-VCFvCenter cmdlet retrieves a list of vCenter Servers instances managed by SDDC Manager.

        .EXAMPLE
        Get-VCFvCenter
        This example shows how to retrieve a list of all vCenter Server instances managed by SDDC Manager.

        .EXAMPLE
        Get-VCFvCenter -id d189a789-dbf2-46c0-a2de-107cde9f7d24
        This example shows how to return the details of a vCenter Server instance managed by SDDC Manager by its unique ID.

        .EXAMPLE
        Get-VCFvCenter -domain 1a6291f2-ed54-4088-910f-ead57b9f9902
        This example shows how to return the details of a vCenter Server instance managed by SDDC Manager by unique ID of its workload domain.

        .EXAMPLE
        Get-VCFvCenter | select fqdn
        This example shows how to retrieve a list of all vCenter Servers managed by SDDC Manager and display only their FQDN.

        .PARAMETER id
        Specifies the unique ID of the vCenter Server instance.

        .PARAMETER domainId
        Specifies the unique ID of the workload domain.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$domainId
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if (-not $PsBoundParameters.ContainsKey("id") -and (-not $PsBoundParameters.ContainsKey("domainId"))) {
            $uri = "https://$sddcManager/v1/vcenters"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
        if ($PsBoundParameters.ContainsKey("id")) {
            $uri = "https://$sddcManager/v1/vcenters/$id"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response
        }
        if ($PsBoundParameters.ContainsKey("domainId")) {
            $uri = "https://$sddcManager/v1/vcenters/?domain=$domainId"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFvCenter

#EndRegion APIs for managing vCenter Server


#Region APIs for managing Aria Suite Lifecycle

Function Get-VCFVrslcm {
    <#
        .SYNOPSIS
        Retrieves information about Aria Suite Lifecycle deployment in VMware Cloud Foundation mode.

        .DESCRIPTION
        The Get-VCFVrslcm cmdlet retrieves information about Aria Suite Lifecycke deployment in VMware Cloud Foundation mode.

        .EXAMPLE
        Get-VCFVrslcm
        This example shows how to retrieve information about Aria Suite Lifecycle deployment in VMware Cloud Foundation mode.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/vrslcms"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response.elements
    } Catch {
        ResponseException -object $_
    }
}
New-Alias -Name Get-VCFAriaLifecycle -Value Get-VCFVrslcm
Export-ModuleMember -Function Get-VCFVrslcm -Alias Get-VCFAriaLifecycle

Function New-VCFVrslcm {
    <#
        .SYNOPSIS
        Deploys Aria Suite Lifecycle in the management domain in VMware Cloud Foundation mode.

        .DESCRIPTION
        The New-VCFVrslcm cmdlet deploys Aria Suite Lifecycle in the management domain in VMware Cloud Foundation mode.

        .EXAMPLE
        New-VCFVrslcm -json .\samples\deployAriaLifecycleAvnVlanSpec.json
        This example shows how to deploy Aria Suite Lifecycle using a JSON specification file.

        .EXAMPLE
        New-VCFVrslcm -json .\samples\deployAriaLifecycleAvnVlanSpec.json -validate
        This example shows how to validate a JSON specification file.

        .PARAMETER json
        Specifies the JSON specification file to be used.

        .PARAMETER validate
        Specifies to validate the JSON specification file.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$validate
    )

    Try {
        $jsonBody = validateJsonInput -json $json
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.

        if ( -not $PsBoundParameters.ContainsKey("validate")) {
            $uri = "https://$sddcManager/v1/vrslcms"
            $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        } elseif ($PsBoundParameters.ContainsKey("validate")) {
            $uri = "https://$sddcManager/v1/vrslcms/validations"
            $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
            $response
        }
    } Catch {
        ResponseException -object $_
    }
}
New-Alias -Name New-VCFAriaLifecycle -Value New-VCFVrslcm
Export-ModuleMember -Function New-VCFVrslcm -Alias New-VCFAriaLifecycle

Function Remove-VCFVrslcm {
    <#
        .SYNOPSIS
        Removes a failed Aria Suite Lifecycle deployment.

        .DESCRIPTION
        The Remove-VCFVrslcm cmdlet removes a failed Aria Suite Lifecycle deployment in VMware Cloud Foundation mode.

        .EXAMPLE
        Remove-VCFVrslcm
        This example shows how to remove a failed Aria Suite Lifecycle deployment.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/vrslcm"
        $response = Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers
        $response
    } Catch {
        ResponseException -object $_
    }
}
New-Alias -Name Remove-VCFAriaLifecycle -Value Remove-VCFVrslcm
Export-ModuleMember -Function Remove-VCFVrslcm -Alias Remove-VCFAriaLifecycle

Function Reset-VCFVrslcm {
    <#
        .SYNOPSIS
        Redeploys Aria Suite Lifecycle in the management domain in VMware Cloud Foundation mode.

        .DESCRIPTION
        The Reset-VCFVrslcm cmdlet redeploys Aria Suite Lifecycle in the management domain in VMware Cloud Foundation
        mode.

        .EXAMPLE
        Reset-VCFVrslcm
        This example shows how to redeploy Aria Suite Lifecycle in the management domain in VMware Cloud Foundation mode.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/vrslcm"
        $response = Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers
        $response
    } Catch {
        ResponseException -object $_
    }
}
New-Alias -Name Reset-VCFAriaLifecycle -Value Reset-VCFVrslcm
Export-ModuleMember -Function Reset-VCFVrslcm -Alias Reset-VCFAriaLifecycle

#EndRegion APIs for managing Aria Suite Lifecycle


#Region APIs for managing Aria Operations

Function Get-VCFVrops {
    <#
        .SYNOPSIS
        Retrieves information about Aria Operations deployment in VMware Cloud Foundation mode.

        .DESCRIPTION
        The Get-VCFVrops cmdlet retrieves information about Aria Operations deployment in VMware Cloud Foundation mode.

        .EXAMPLE
        Get-VCFVrops
        This example shows how to retrieve information about Aria Operations deployment in VMware Cloud Foundation mode.

        .EXAMPLE
        Get-VCFVrops -domains
        This example shows how to retrieve information workload domains connected to Aria Operations.

        .PARAMETER domains
        Specifies to list the connected workload domains.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [Switch]$domains
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        if ($PsBoundParameters.ContainsKey("domains")) {
            $uri = "https://$sddcManager/v1/vrops/domains"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        } else {
            $uri = "https://$sddcManager/v1/vropses"
            $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            $response.elements
        }
    } Catch {
        ResponseException -object $_
    }
}
New-Alias -Name Get-VCFAriaOperations -Value Get-VCFVrops
Export-ModuleMember -Function Get-VCFVrops -Alias Get-VCFAriaOperations

Function Get-VCFVropsConnection {
    <#
        .SYNOPSIS
        Retrieves the connection status for all workload domain connected to an Aria Operations deployment
        in VMware Cloud Foundation mode.

        .DESCRIPTION
        The Get-VCFVropsConnection cmdlet retrieves the connection status for all workload domain connected
        to an Aria Operations deployment in VMware Cloud Foundation mode.

        .EXAMPLE
        Get-VCFVropsConnection
        This example shows how to retrieve the connection status for all workload domain connected to a Aria Operations deployment in VMware Cloud Foundation mode.
    #>

    Try {
        createHeader # See access token and refresh, if necessary.t the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/vrops/domains"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response.elements
    } Catch {
        ResponseException -object $_
    }
}
New-Alias -Name Get-VCFAriaOperationsConnection -Value Get-VCFVropsConnection
Export-ModuleMember -Function Get-VCFVropsConnection -Alias Get-VCFAriaOperationsConnection

Function Set-VCFVropsConnection {
    <#
        .SYNOPSIS
        Connects or disconnects workload domains to Aria Operations.

        .DESCRIPTION
        The Set-VCFVrops cmdlet connects or disconnects workload domains to Aria Operations.

        .EXAMPLE
        Set-VCFVrops -domainId <domain-id> -status ENABLED
        This example shows how to connect a workload domain to Aria Operations.

        .EXAMPLE
        Set-VCFVrops -domainId <domain-id> -status DISABLED
        This example shows how to disconnect a workload domain from Aria Operations.

        .PARAMETER domainId
        Specifies the unique ID of the workload domain.

        .PARAMETER status
        Specifies the status. One of: ENABLED, DISABLED.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainId,
        [Parameter (Mandatory = $true)] [ValidateSet("ENABLED", "DISABLED")] [ValidateNotNullOrEmpty()] [String]$status
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $body = '{"domainId": "' + $domainId + '","status": "' + $status + '"}'
        $uri = "https://$sddcManager/v1/vrops/domains"
        $response = Invoke-RestMethod -Method PUT -Uri $uri -Headers $headers -Body $body -ContentType 'application/json'
        $response
    } Catch {
        ResponseException -object $_
    }
}
New-Alias -Name Set-VCFAriaOperationsConnection -Value Set-VCFVropsConnection
Export-ModuleMember -Function Set-VCFVropsConnection -Alias Set-VCFAriaOperationsConnection

#EndRegion APIs for managing Aria Operations


#Region APIs for managing Aria Operations for Logs

Function Get-VCFVrli {
    <#
        .SYNOPSIS
        Retrieves information about Aria Operations for Logs deployment in VMware Cloud Foundation mode.

        .DESCRIPTION
        Retrieves information about Aria Operations for Logs deployment in VMware Cloud Foundation mode.

        .EXAMPLE
        Get-VCFVrli
        This example shows how to retrieve information about Aria Operations for Logs deployment in VMware Cloud Foundation mode.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/vrlis"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response.elements
    } Catch {
        ResponseException -object $_
    }
}
New-Alias -Name Get-VCFAriaOperationsLogs -Value Get-VCFVrli
Export-ModuleMember -Function Get-VCFVrli -Alias Get-VCFAriaOperationsLogs

Function Get-VCFVrliConnection {
    <#
        .SYNOPSIS
        Retrieves the connection status for all workload domain connections to Aria Operations for Logs.

        .DESCRIPTION
        The Get-VCFVrliConnection cmdlet retrieves the connection status for all workload domain connections to Aria Operations for Logs.

        .EXAMPLE
        Get-VCFVrliConnection
        This example shows how to retrieve the connection status for all workload domain connections to Aria Operations for Logs.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/vrli/domains"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response.elements
    } Catch {
        ResponseException -object $_
    }
}
New-Alias -Name Get-VCFAriaOperationsLogsConnection -Value Get-VCFVrliConnection
Export-ModuleMember -Function Get-VCFVrliConnection -Alias Get-VCFAriaOperationsLogsConnection

Function Set-VCFVrliConnection {
    <#
        .SYNOPSIS
        Connects or disconnects workload domains to Aria Operations for Logs.

        .DESCRIPTION
        The Set-VCFVrliConnection cmdlet connects or disconnects workload domains to Aria Operations for Logs.

        .EXAMPLE
        Set-VCFVrliConnection -domainId <domain-id> -status ENABLED
        This example shows how to connect a workload domain to Aria Operations for Logs.

        .EXAMPLE
        Set-VCFVrliConnection -domainId <domain-id> -status DISABLED
        This example shows how to disconnect a workload domain from Aria Operations for Logs.

        .PARAMETER domainId
        Specifies the unique ID of the workload domain.

        .PARAMETER status
        Specifies the status. One of: ENABLED, DISABLED.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$domainId,
        [Parameter (Mandatory = $true)] [ValidateSet("ENABLED", "DISABLED")] [ValidateNotNullOrEmpty()] [String]$status
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $json = '{"domainId": "' + $domainId + '","status": "' + $status + '"}'
        $uri = "https://$sddcManager/v1/vrli/domains"
        $response = Invoke-RestMethod -Method 'PUT' -Uri $uri -Headers $headers -Body $json -ContentType 'application/json'
        $response
    } Catch {
        ResponseException -object $_
    }
}
New-Alias -Name Set-VCFAriaOperationsLogsConnection -Value Set-VCFVrliConnection
Export-ModuleMember -Function Set-VCFVrliConnection -Alias Set-VCFAriaOperationsLogsConnection

#EndRegion APIs for managing Aria Operations for Logs


#Region APIs for managing Aria Automation

Function Get-VCFVra {
    <#
        .SYNOPSIS
        Retrieves information about an Aria Automation deployment in VMware Cloud Foundation mode.

        .DESCRIPTION
        The Get-VCFVra cmdlet retrieves information about an Aria Automation deployment in VMware Cloud Foundation mode.

        .EXAMPLE
        Get-VCFVra
        This example shows how to retrieve information about an Aria Automation deployment in VMware Cloud Foundation mode.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/vras"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response.elements
    } Catch {
        ResponseException -object $_
    }
}
New-Alias -Name Get-VCFAriaAutomation -Value Get-VCFVra
Export-ModuleMember -Function Get-VCFVra -Alias Get-VCFAriaAutomation

#EndRegion APIs for managing Aria Automation


#Region APIs for managing Workspace ONE Access

Function Get-VCFWsa {
    <#
        .SYNOPSIS
        Retrieves information about Workspace ONE Access deployment in VMware Cloud Foundation mode.

        .DESCRIPTION
        The Get-VCFWsa cmdlet retrieves information about Workspace ONE Access deployment in VMware Cloud Foundation mode.

        .EXAMPLE
        Get-VCFWsa
        This example shows how to retrieve information about Workspace ONE Access deployment in VMware Cloud Foundation mode.
    #>

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/wsas"
        $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
        $response.elements
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Get-VCFWsa

#EndRegion APIs for managing Workspace ONE Access


#Region APIs for managing Identity Providers

Function Get-VCFIdentityProvider {
    <#
        .SYNOPSIS
        Retrieves a list of all identity providers or the details of a specific identity provider.

        .DESCRIPTION
        The Get-VCFIdentityProvider cmdlet retrieves a list of all identity providers or the details of a specific
        identity provider.

        .EXAMPLE
        Get-VCFIdentityProvider
        This example shows how to retrieve the details of all identity providers.

        .EXAMPLE
        Get-VCFIdentityProvider -id 3e250ddd-07ec-4923-a161-ab6e9aa588181
        This example shows how to retrieve the details of a specific identity provider.

        .PARAMETER id
        Specifies the unique ID of the identity provider.
    #>

    Param (
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$id
    )

    Try {
        if ((Get-VCFManager -version) -ge '4.5.0') {
            createHeader # Set the Accept and Authorization headers.
            checkVCFToken # Validate the access token and refresh, if necessary.
            if ($PsBoundParameters.ContainsKey("id")) {
                $uri = "https://$sddcManager/v1/identity-providers/$id"
                Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
            } else {
                $uri = "https://$sddcManager/v1/identity-providers"
                (Invoke-RestMethod -Method GET -Uri $uri -Headers $headers).elements
            }
        } else {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        }
    } Catch {
        ResponseException -Object $_
    }
}
Export-ModuleMember -Function Get-VCFIdentityProvider

Function Remove-VCFIdentityProvider {
    <#
        .SYNOPSIS
        Removes an identity provider.

        .DESCRIPTION
        The Remove-VCFIdentityProvider cmdlet removes an identity provider.

        .EXAMPLE
        Remove-VCFIdentityProvider -type Embedded -domainName sfo.rainpole.io.
        This example shows how to remove an embedded identity provider with a specific domain name.

        .EXAMPLE
        Remove-VCFIdentityProvider -type "Microsoft ADFS".
        This example shows how to remove an external identity provider.

        .PARAMETER type
        Specifies the type of the identity provider. One of: Embedded, Microsoft ADFS.

        .PARAMETER domainName
        Specifies the domain name of the identity provider.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateSet("Embedded","Microsoft ADFS")] [String]$type,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$domainName
    )

    Try {
        if ((Get-VCFManager -version) -ge '4.5.0') {
            createHeader # Set the Accept and Authorization headers.
            checkVCFToken # Validate the access token and refresh, if necessary.
            if ($type -eq "Embedded") {
                $id = (Get-VCFIdentityProvider | Where-Object {$_.type -eq $type}).id
                $uri = "https://$sddcManager/v1/identity-providers/$id/identity-sources/$domainName"
            } elseif ($type -eq "Microsoft ADFS") {
                $id = (Get-VCFIdentityProvider | Where-Object {$_.type -eq $type}).id
                $uri = "https://$sddcManager/v1/identity-providers/$id"
            }
            Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers # This API does not return a response.
        } else {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        }
    } Catch {
        ResponseException -Object $_
    }
}
Export-ModuleMember -Function Remove-VCFIdentityProvider

Function New-VCFIdentityProvider {
    <#
        .SYNOPSIS
        Configures an identity provider.

        .DESCRIPTION
        The New-VCFIdentityProvider cmdlet configures an embedded or external identity provider from a
        JSON specification file.

        .EXAMPLE
        New-VCFIdentityProvider -type Embedded -json .\samples\idp\embeddedIdpSpec.json
        This example shows how to configure an embedded identity provider from the JSON specification file.

        .EXAMPLE
        New-VCFIdentityProvider -type "Microsoft ADFS" -json .\samples\idp\externalIdpSpec.json
        This example shows how to configure an external identity provider from the JSON specification file.

        .PARAMETER type
        Specifies the type of the identity provider. One of: Embedded, Microsoft ADFS.

        .PARAMETER json
        Specifies the JSON specification file to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateSet("Embedded","Microsoft ADFS")] [String]$type,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        if ((Get-VCFManager -version) -ge '4.5.0') {
            createHeader # Set the Accept and Authorization headers.
            checkVCFToken # Validate the access token and refresh, if necessary.
            if ($type -eq "Embedded") {
                $jsonBody = validateJsonInput -json $json
                $id = (Get-VCFIdentityProvider | Where-Object {$_.type -eq $type}).id
                $uri = "https://$sddcManager/v1/identity-providers/$id/identity-sources"
            } elseif ($type -eq "Microsoft ADFS") {
                $jsonBody = validateJsonInput -json $json
                $uri = "https://$sddcManager/v1/identity-providers"
            }
            Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody
        } else {
            Write-Warning "$msgVcfApiNotSupported $(Get-VCFManager -version)"
        }
    } Catch {
        ResponseException -Object $_
    }
}
Export-ModuleMember -Function New-VCFIdentityProvider

Function Update-VCFIdentityProvider {
    <#
        .SYNOPSIS
        Updates an identity provider.

        .DESCRIPTION
        The Update-VCFIdentityProvider cmdlet updates the configuration of an embedded or external identity provider from a JSON specification file.

        .EXAMPLE
        Update-VCFIdentityProvider -type Embedded -domainName sfo.rainpole.io -json .\samples\idp\embeddedIdpSpec.json
        This example shows how to update the configuration of an embedded identity provider from the JSON specification file for a specific domain name.

        .EXAMPLE
        Update-VCFIdentityProvider -type "Microsoft ADFS" -json .\samples\idp\externalIdpSpec.json
        This example shows how to update the configuration of "Microsoft ADFS" identity provider from the JSON specification file.

        .PARAMETER type
        Specifies the type of the identity provider. One of: Embedded, Microsoft ADFS.

        .PARAMETER domainName
        Specifies the domain name of the identity provider.

        .PARAMETER json
        Specifies the JSON specification file to be used.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateSet("Embedded","Microsoft ADFS")] [String]$type,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$domainName,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$json
    )

    Try {
        if ((Get-VCFManager -version) -ge '4.5.0') {
            createHeader # Set the Accept and Authorization headers.
            checkVCFToken # Validate the access token and refresh, if necessary.
            if ($type -eq "Embedded") {
                $jsonBody = validateJsonInput -json $json
                $id = (Get-VCFIdentityProvider | Where-Object {$_.type -eq $type}).id
                $uri = "https://$sddcManager/v1/identity-providers/$id/identity-sources/$domainName"
            } elseif ($type -eq "Microsoft ADFS") {
                $jsonBody = validateJsonInput -json $json
                $id = (Get-VCFIdentityProvider | Where-Object {$_.type -eq $type}).id
                $uri = "https://$sddcManager/v1/identity-providers/$id"
            }
            Invoke-RestMethod -Method PATCH -Uri $uri -Headers $headers -ContentType 'application/json' -Body $jsonBody # This API does not return a response.
        } else {
            Write-Warning $msgVcfApiNotSupported $(Get-VCFManager -version)
        }
    } Catch {
        ResponseException -Object $_
    }
}
Export-ModuleMember -Function Update-VCFIdentityProvider

#EndRegion APIs for managing Identity Providers

#Region APIs for managing Validations (Not Exported)

# The following functions are not exported since they are used internally by the cmdlets that manage the validations.

# No need to include the validateJsonInput on the validation functions since it is invoked directly on all the cmdlet functions that have a json parameter
# The validation performed by SDDC Manager is on a different level from validating the raw JSON file path and/or syntax.

Function Validate-CommissionHostSpec {

    Param (
        [Parameter (Mandatory = $true)] [object]$json
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/hosts/validations"
        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $json
        Return $response
    } Catch {
        ResponseException -object $_
    }
}

Function Validate-WorkloadDomainSpec {

    Param (
        [Parameter (Mandatory = $true)] [object]$json
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/domains/validations"
        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $json
        Return $response
    } Catch {
        ResponseException -object $_
    }
}

Function Validate-VCFClusterSpec {

    Param (
        [Parameter (Mandatory = $true)] [object]$json
    )
    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/clusters/validations"
        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $json
    } Catch {
        ResponseException -object $_
    }
    Return $response
}

Function Validate-VCFUpdateClusterSpec {

    Param (
        [Parameter (Mandatory = $true)] [object]$clusterid,
        [Parameter (Mandatory = $true)] [object]$json
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/clusters/$clusterid/validations"
        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $json
    } Catch {
        ResponseException -object $_
    }
    Return $response
}

Function Validate-EdgeClusterSpec {

    Param (
        [Parameter (Mandatory = $true)] [object]$json
    )

    Try {
        createHeader # Set the Accept and Authorization headers.
        checkVCFToken # Validate the access token and refresh, if necessary.
        $uri = "https://$sddcManager/v1/edge-clusters/validations"
        $response = Invoke-RestMethod -Method POST -Uri $uri -Headers $headers -ContentType 'application/json' -Body $json
    } Catch {
        ResponseException -object $_
    }
    Return $response
}
#EndRegion APIs for managing Validations (Not Exported)


#Region Utility Functions (Exported)

Function Invoke-VCFCommand {
    <#
        .SYNOPSIS
        Run a command on SDDC Manager.

        .DESCRIPTION
        The Invoke-VCFCommand cmdlet runs a command within the SDDC Manager appliance.

        .EXAMPLE
        Invoke-VCFCommand -server sfo-vcf01.sfo.rainpole.io -user admin@local -pass VMw@re1!VMw@re1! -vmUser vcf -vmPass VMw@re1! -command "echo Hello World."
        This example runs the command provided on the SDDC Manager appliance as the vcf user.

        .PARAMETER server
        The fully qualified domain name of the SDDC Manager.

        .PARAMETER user
        The username to authenticate to the SDDC Manager.

        .PARAMETER pass
        The password to authenticate to the SDDC Manager.

        .PARAMETER vmUser
        The username to authenticate to the virtual machine.

        .PARAMETER vmPass
        The password to authenticate to the virtual machine.

        .PARAMETER command
        The command to run on the virtual machine.
    #>

    Param (
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$server,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$user,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$pass,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$vmUser,
        [Parameter (Mandatory = $false)] [ValidateNotNullOrEmpty()] [String]$vmPass,
        [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$command
    )

    $vcfWorkloadDomainDetails = Get-VCFWorkloadDomain | Where-Object { $_.type -eq "MANAGEMENT" }
    $vcenterServerDetails = Get-VCFvCenter | Where-Object { $_.fqdn -eq $vcfWorkloadDomainDetails.vcenters.fqdn }

    if ($PSVersionTable.PSEdition -eq 'Core') {
        if (!($status = Test-Connection -TargetName $vcfWorkloadDomainDetails.vcenters.fqdn -TcpPort 443 -Quiet)) {
            Throw "Unable to connect to Management Domain vCenter Server ($vcfWorkloadDomainDetails.vcenters.fqdn)."
        }
    } elseif ($PSVersionTable.PSEdition -eq 'Desktop') {
        $OriginalProgressPreference = $Global:ProgressPreference; $Global:ProgressPreference = 'SilentlyContinue'
        if (!($status = Test-NetConnection -ComputerName $vcfWorkloadDomainDetails.vcenters.fqdn -Port 443 -WarningAction SilentlyContinue)) {
            $Global:ProgressPreference = $OriginalProgressPreference
            Throw "Unable to connect to Management Domain vCenter Server ($vcfWorkloadDomainDetails.vcenters.fqdn)."
        }
        $Global:ProgressPreference = $OriginalProgressPreference
    }

    $vcfDetail = Get-VCFRelease -domainId $vcfWorkloadDomainDetails.id

    if ( ($vcfDetail.version).Split("-")[0] -ge "4.5.0.0") {
        $pscCredentialDetails = Get-VCFCredential | Where-Object { $_.resource.resourceType -eq "PSC" -and ($_.username).Split('@')[-1] -eq $vcfWorkloadDomainDetails.ssoName }
    } else {
        $pscCredentialDetails = Get-VCFCredential | Where-Object { $_.resource.resourceType -eq "PSC" }
    }

    Connect-VIServer -Server $vcenterServerDetails.fqdn -User $pscCredentialDetails.username -Password $pscCredentialDetails.password -WarningAction SilentlyContinue | Out-Null

    if ($DefaultVIServer.Name -ne $vcenterServerDetails.fqdn) {
        Throw "Unable to authenticate to Management Domain vCenter Server ($vcfWorkloadDomainDetails.vcenters.fqdn), check credentials and try again."
    }

    Try {
        $output = Invoke-VMScript -VM ($server.Split(".")[0]) -ScriptText $command -GuestUser $vmUser -GuestPassword $vmPass -Server $vcenterServerDetails.fqdn
        $output
    } Catch {
        throw "Error executing command: $_"
    } Finally {
        Disconnect-VIServer -Server $vcenterServerDetails.fqdn -Confirm:$false -WarningAction SilentlyContinue | Out-Null
    }
}
Export-ModuleMember -Function Invoke-VCFCommand


#EndRegion Utility Functions (Exported)


#Region Utility Functions (Not Exported)

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

    # Check if module is imported into the current session.
    if (Get-Module -Name $moduleName) {
        $searchResult = "ALREADY_IMPORTED"
    } else {
        # If module is not imported, check if available on disk and try to import.
        if (Get-Module -ListAvailable | Where-Object { $_.Name -eq $moduleName }) {
            Try {
                Write-Output "Module $moduleName not loaded, importing now please wait..."
                Import-Module $moduleName
                Write-Output "Module $moduleName imported successfully."
                $searchResult = "IMPORTED"
            } Catch {
                $searchResult = "IMPORT_FAILED"
            }
        } else {
            # If module is not imported & not available on disk, try the PowerShell Gallery then install and import.
            if (Find-Module -Name $moduleName | Where-Object { $_.Name -eq $moduleName }) {
                Try {
                    Write-Output "Module $moduleName was missing, installing now please wait..."
                    Install-Module -Name $moduleName -Force -Scope CurrentUser
                    Write-Output "Importing module $moduleName, please wait..."
                    Import-Module $moduleName
                    Write-Output "Module $moduleName installed and imported"
                    $searchResult = "INSTALLED_IMPORTED"
                } Catch {
                    $searchResult = "INSTALLIMPORT_FAILED"
                }
            } else {
                # If module is not imported, not available, and not in the PowerShell Gallery then abort.
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

    # Check if the file path is valid. If not, evaluate if the variable was passed as JSON string.
    if (!(Test-Path $json)) {

        # File path invalid.
        # Check if the JSON was passed directly as string by converting to an object.

        Try {
            $jsonPSobject = ConvertFrom-Json $json -ErrorAction Stop;
            $jsonValid = $true;
        } Catch {
            $jsonValid = $false;
            $ConfigJson = $json # Load the raw and wrong JSON content for function return.
        }

        if ($jsonValid) {
            # JSON parameter was passed as a string. Convert back from object to JSON.
            # The validity of the JSON string format has been already validated by the ConvertFrom-Json cmdlet.
            $ConfigJson = $json
            Write-Verbose "The JSON parameter was passed as a valid JSON string notation."
            $ConfigJson # Return validated JSON.
        } else {
            ResponseException -object $_
            $ConfigJson # Return an unvalidated JSON before throwing.
            Throw "The provided JSON parameter couldn't be validated as file path nor as JSON string. Please check the file path or JSON string formatting again."
        }
    } else {
        # JSON parameter was passed as file path.
        # Reads the file content and loads it.
        $ConfigJson = (Get-Content -Raw $json)

        # Validate the JSON string format.
        Try {
            $jsonPSobject = ConvertFrom-Json  $ConfigJson -ErrorAction Stop;
            $jsonValid = $true;
        } Catch {
            $jsonValid = $false;
        }

        if ($jsonValid) {
            Write-Verbose "JSON file found. JSON string format was valid and content has been stored into a variable."
            Write-Verbose $ConfigJson
            $ConfigJson # Return validated JSON.
        } else {
            $ConfigJson # Return an unvalidated JSON before throwing.
            Throw "The provided JSON file path was valid; however, it could not be converted from JSON. Please check the formatting of the input."
        }
    }
}
#EndRegion Utility Functions (Not Exported)


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
    } else {
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


#Region JSON Export Functions
Function Export-VCFManagementDomainJsonSpec {

    Param (
        [Parameter (Mandatory = $true)] [String]$workbook,
        [Parameter (Mandatory = $true)] [String]$jsonPath
    )
    # Confirm the presence of ImportExcel module
    if (!(Get-InstalledModule -name "ImportExcel"  -MinimumVersion 7.8.5 -ErrorAction SilentlyContinue)) {
        Write-Host " ImportExcel PowerShell module not found. Please install manually" -ForegroundColor Yellow
    } else {
        Write-Output " ImportExcel PowerShell module found" -ForegroundColor Green
    }

    $Global:vcfVersion = @("v4.3.x", "v4.4.x", "v4.5.x", "v5.0.x", "v5.1.x")
    Try {
        
        $module = "Management Domain JSON Spec"
        Write-Output "Starting the Process of Generating the $module"
        $pnpWorkbook = Open-ExcelPackage -Path $Workbook

        if ($pnpWorkbook.Workbook.Names["vcf_version"].Value -notin $vcfVersion) {
            Write-Output "Planning and Preparation Workbook Provided Not Supported"
            Break
        }

        if ($pnpWorkbook.Workbook.Names["vcf_plus_result"].Value -eq "Included") {
            $nsxtLicense = ""
            $esxLicense = ""
            $vsanLicense = ""
            $vcenterLicense = ""
        } else {
            $nsxtLicense = $pnpWorkbook.Workbook.Names["nsxt_license"].Value
            $esxLicense = $pnpWorkbook.Workbook.Names["esx_std_license"].Value
            $vsanLicense = $pnpWorkbook.Workbook.Names["vsan_license"].Value
            $vcenterLicense = $pnpWorkbook.Workbook.Names["vc_license"].Value
        }

        # Check if management vm network is being used
        if (!($pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_vm_cidr"]) -or $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_vm_cidr"].Value -eq "Value Missing") {
            $esxMgmtCidr = ($pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_cidr"].Value.split("/"))[1]
            $vmMgmtCidr = ($pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_cidr"].Value.split("/"))[1]
        } else {
            $esxMgmtCidr = ($pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_cidr"].Value.split("/"))[1]
            $vmMgmtCidr = ($pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_vm_cidr"].Value.split("/"))[1]   
        }
        
        $esxManagmentMaskObject = ([IPAddress] ([Convert]::ToUInt64((("1" * $esxMgmtCidr) + ("0" * (32 - $esxMgmtCidr))), 2)))
        $vmManagmentMaskObject = ([IPAddress] ([Convert]::ToUInt64((("1" * $vmMgmtCidr) + ("0" * (32 - $vmMgmtCidr))), 2)))

        $ntpServers = New-Object System.Collections.ArrayList
        if ($pnpWorkbook.Workbook.Names["region_dns2_ip"].Value -eq "n/a") {
            [Array]$ntpServers = $pnpWorkbook.Workbook.Names["region_dns1_ip"].Value
        } else {
            [Array]$ntpServers = $pnpWorkbook.Workbook.Names["region_dns1_ip"].Value, $pnpWorkbook.Workbook.Names["region_dns2_ip"].Value
        }

        $dnsObject = @()
        $dnsObject += [pscustomobject]@{
            'domain'              = $pnpWorkbook.Workbook.Names["region_ad_parent_fqdn"].Value
            'subdomain'           = $pnpWorkbook.Workbook.Names["region_ad_child_fqdn"].Value
            'nameserver'          = $pnpWorkbook.Workbook.Names["region_dns1_ip"].Value
            'secondaryNameserver' = $pnpWorkbook.Workbook.Names["region_dns2_ip"].Value
        }

        $rootUserObject = @()
        $rootUserObject += [pscustomobject]@{
            'username' = "root"
            'password' = $pnpWorkbook.Workbook.Names["sddc_mgr_root_password"].Value
        }

        $secondUserObject = @()
        $secondUserObject += [pscustomobject]@{
            'username' = "vcf"
            'password' = $pnpWorkbook.Workbook.Names["sddc_mgr_vcf_password"].Value
        }

        $restApiUserObject = @()
        $restApiUserObject += [pscustomobject]@{
            'username' = "admin"
            'password' = $pnpWorkbook.Workbook.Names["sddc_mgr_admin_local_password"].Value
        }

        $sddcManagerObject = @()
        $sddcManagerObject += [pscustomobject]@{
            'hostname'            = $pnpWorkbook.Workbook.Names["sddc_mgr_hostname"].Value
            'ipAddress'           = $pnpWorkbook.Workbook.Names["sddc_mgr_ip"].Value
            'netmask'             = $vmManagmentMaskObject.IPAddressToString
            'localUserPassword'   = $pnpWorkbook.Workbook.Names["sddc_mgr_admin_local_password"].Value
            rootUserCredentials   = ($rootUserObject | Select-Object -Skip 0)
            restApiCredentials    = ($restApiUserObject | Select-Object -Skip 0)
            secondUserCredentials = ($secondUserObject | Select-Object -Skip 0)
        }

        $vmnics = New-Object System.Collections.ArrayList
        [Array]$vmnics = $($pnpWorkbook.Workbook.Names["primary_vds_vmnics"].Value.Split(',')[0]), $($pnpWorkbook.Workbook.Names["primary_vds_vmnics"].Value.Split(',')[1])

        $networks = New-Object System.Collections.ArrayList
        if ($pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_vm_pg"].Value -eq "Value Missing") {
            [Array]$networks = "MANAGEMENT", "VMOTION", "VSAN"
        } else {
            [Array]$networks = "MANAGEMENT", "VMOTION", "VSAN", "VM_MANAGEMENT"
        }

        $vmotionIpObject = @()
        $vmotionIpObject += [pscustomobject]@{
            'startIpAddress' = $pnpWorkbook.Workbook.Names["mgmt_az1_vmotion_pool_start_ip"].Value
            'endIpAddress'   = $pnpWorkbook.Workbook.Names["mgmt_az1_vmotion_pool_end_ip"].Value
        }

        $vsanIpObject = @()
        $vsanIpObject += [pscustomobject]@{
            'startIpAddress' = $pnpWorkbook.Workbook.Names["mgmt_az1_vsan_pool_start_ip"].Value
            'endIpAddress'   = $pnpWorkbook.Workbook.Names["mgmt_az1_vsan_pool_end_ip"].Value
        }

        $vmotionMtu = $pnpWorkbook.Workbook.Names["mgmt_az1_vmotion_mtu"].Value -as [string]
        $vsanMtu = $pnpWorkbook.Workbook.Names["mgmt_az1_vsan_mtu"].Value -as [string]
        $dvsMtu = [INT]$pnpWorkbook.Workbook.Names["primary_vds_mtu"].Value

        $networkObject = @()
        $networkObject += [pscustomobject]@{
            'networkType'  = "MANAGEMENT"
            'subnet'       = $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_cidr"].Value
            'vlanId'       = $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_vlan"].Value -as [string]
            'mtu'          = $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_mtu"].Value -as [string]
            'gateway'      = $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_gateway_ip"].Value
            'portGroupKey' = $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_pg"].Value
        }
        $networkObject += [pscustomobject]@{
            'networkType'          = "VMOTION"
            'subnet'               = $pnpWorkbook.Workbook.Names["mgmt_az1_vmotion_cidr"].Value
            includeIpAddressRanges = $vmotionIpObject
            'vlanId'               = $pnpWorkbook.Workbook.Names["mgmt_az1_vmotion_vlan"].Value -as [string]
            'mtu'                  = $pnpWorkbook.Workbook.Names["mgmt_az1_vmotion_mtu"].Value -as [string]
            'gateway'              = $pnpWorkbook.Workbook.Names["mgmt_az1_vmotion_gateway_ip"].Value
            'portGroupKey'         = $pnpWorkbook.Workbook.Names["mgmt_az1_vmotion_pg"].Value
        }
        $networkObject += [pscustomobject]@{
            'networkType'          = "VSAN"
            'subnet'               = $pnpWorkbook.Workbook.Names["mgmt_az1_vsan_cidr"].Value
            includeIpAddressRanges = $vsanIpObject
            'vlanId'               = $pnpWorkbook.Workbook.Names["mgmt_az1_vsan_vlan"].Value -as [string]
            'mtu'                  = $pnpWorkbook.Workbook.Names["mgmt_az1_vsan_mtu"].Value -as [string]
            'gateway'              = $pnpWorkbook.Workbook.Names["mgmt_az1_vsan_gateway_ip"].Value
            'portGroupKey'         = $pnpWorkbook.Workbook.Names["mgmt_az1_vsan_pg"].Value
        }
        if ($pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_vm_pg"].Value -ne "Value Missing") {
            $networkObject += [pscustomobject]@{
                'networkType'  = "VM_MANAGEMENT"
                'subnet'       = $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_vm_cidr"].Value
                'vlanId'       = $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_vm_vlan"].Value -as [string]
                'mtu'          = $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_vm_mtu"].Value -as [string]
                'gateway'      = $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_vm_gateway_ip"].Value
                'portGroupKey' = $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_vm_pg"].Value
            }
        }

        $nsxtManagerObject = @()
        $nsxtManagerObject += [pscustomobject]@{
            'hostname' = $pnpWorkbook.Workbook.Names["mgmt_nsxt_mgra_hostname"].Value
            'ip'       = $pnpWorkbook.Workbook.Names["mgmt_nsxt_mgra_ip"].Value
        }
        if ($singleNSXTManager -eq "N") {
            $nsxtManagerObject += [pscustomobject]@{
                'hostname' = $pnpWorkbook.Workbook.Names["mgmt_nsxt_mgrb_hostname"].Value
                'ip'       = $pnpWorkbook.Workbook.Names["mgmt_nsxt_mgrb_ip"].Value
            }
            $nsxtManagerObject += [pscustomobject]@{
                'hostname' = $pnpWorkbook.Workbook.Names["mgmt_nsxt_mgrc_hostname"].Value
                'ip'       = $pnpWorkbook.Workbook.Names["mgmt_nsxt_mgrc_ip"].Value
            }
        }

        $vlanTransportZoneObject = @()
        $vlanTransportZoneObject += [pscustomobject]@{
            'zoneName'    = $pnpWorkbook.Workbook.Names["mgmt_sddc_domain"].Value + "-tz-vlan01"
            'networkName' = "netName-vlan"
        }

        $overlayTransportZoneObject = @()
        $overlayTransportZoneObject += [pscustomobject]@{
            'zoneName'    = $pnpWorkbook.Workbook.Names["mgmt_sddc_domain"].Value + "-tz-overlay01"
            'networkName' = "netName-overlay"
        }

        $edgeNode01interfaces = @()
        $edgeNode01interfaces += [pscustomobject]@{
            'name'          = $pnpWorkbook.Workbook.Names["mgmt_sddc_domain"].Value + "-uplink01-tor1"
            'interfaceCidr' = $pnpWorkbook.Workbook.Names["mgmt_en1_edge_overlay_interface_ip_1_ip"].Value
        }
        $edgeNode01interfaces += [pscustomobject]@{
            'name'          = $pnpWorkbook.Workbook.Names["mgmt_sddc_domain"].Value + "-uplink01-tor2"
            'interfaceCidr' = $pnpWorkbook.Workbook.Names["mgmt_en1_edge_overlay_interface_ip_2_ip"].Value
        }

        $edgeNode02interfaces = @()
        $edgeNode02interfaces += [pscustomobject]@{
            'name'          = $pnpWorkbook.Workbook.Names["mgmt_sddc_domain"].Value + "-uplink01-tor1"
            'interfaceCidr' = $pnpWorkbook.Workbook.Names["mgmt_en2_edge_overlay_interface_ip_1_ip"].Value
        }
        $edgeNode02interfaces += [pscustomobject]@{
            'name'          = $pnpWorkbook.Workbook.Names["mgmt_sddc_domain"].Value + "-uplink01-tor2"
            'interfaceCidr' = $pnpWorkbook.Workbook.Names["mgmt_en2_edge_overlay_interface_ip_2_ip"].Value

        }
        
        $edgeNodeObject = @()
        $edgeNodeObject += [pscustomobject]@{
            'edgeNodeName'     = $pnpWorkbook.Workbook.Names["mgmt_en1_fqdn"].Value.Split(".")[0]
            'edgeNodeHostname' = $pnpWorkbook.Workbook.Names["mgmt_en1_fqdn"].Value
            'managementCidr'   = $pnpWorkbook.Workbook.Names["input_mgmt_en1_ip"].Value + "/" + $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_cidr"].Value.Split("/")[-1]
            'edgeVtep1Cidr'    = $pnpWorkbook.Workbook.Names["input_mgmt_en1_edge_overlay_interface_ip_1_ip"].Value + "/" + $pnpWorkbook.Workbook.Names["input_mgmt_edge_overlay_cidr"].Value.Split("/")[-1]
            'edgeVtep2Cidr'    = $pnpWorkbook.Workbook.Names["input_mgmt_en1_edge_overlay_interface_ip_2_ip"].Value + "/" + $pnpWorkbook.Workbook.Names["input_mgmt_edge_overlay_cidr"].Value.Split("/")[-1]
            interfaces         = $edgeNode01interfaces
        }        
        $edgeNodeObject += [pscustomobject]@{
            'edgeNodeName'     = $pnpWorkbook.Workbook.Names["mgmt_en2_fqdn"].Value.Split(".")[0]
            'edgeNodeHostname' = $pnpWorkbook.Workbook.Names["mgmt_en2_fqdn"].Value
            'managementCidr'   = $pnpWorkbook.Workbook.Names["input_mgmt_en2_ip"].Value + "/" + $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_cidr"].Value.Split("/")[-1]
            'edgeVtep1Cidr'    = $pnpWorkbook.Workbook.Names["input_mgmt_en2_edge_overlay_interface_ip_1_ip"].Value + "/" + $pnpWorkbook.Workbook.Names["input_mgmt_edge_overlay_cidr"].Value.Split("/")[-1]
            'edgeVtep2Cidr'    = $pnpWorkbook.Workbook.Names["input_mgmt_en2_edge_overlay_interface_ip_2_ip"].Value + "/" + $pnpWorkbook.Workbook.Names["input_mgmt_edge_overlay_cidr"].Value.Split("/")[-1]
            interfaces         = $edgeNode02interfaces
        }
        
        $edgeServicesObject = @()
        $edgeServicesObject += [pscustomobject]@{
            'tier0GatewayName' = $pnpWorkbook.Workbook.Names["mgmt_tier0_name"].Value
            'tier1GatewayName' = $pnpWorkbook.Workbook.Names["mgmt_tier1_name"].Value
        }

        $bgpNeighboursObject = @()
        $bgpNeighboursObject += [pscustomobject]@{
            'neighbourIp'      = $pnpWorkbook.Workbook.Names["input_mgmt_az1_tor1_peer_ip"].Value
            'autonomousSystem' = $pnpWorkbook.Workbook.Names["input_mgmt_az1_tor1_peer_asn"].Value
            'password'         = $pnpWorkbook.Workbook.Names["input_mgmt_az1_tor1_peer_bgp_password"].Value
        }
        $bgpNeighboursObject += [pscustomobject]@{
            'neighbourIp'      = $pnpWorkbook.Workbook.Names["input_mgmt_az1_tor2_peer_ip"].Value
            'autonomousSystem' = $pnpWorkbook.Workbook.Names["input_mgmt_az1_tor2_peer_asn"].Value
            'password'         = $pnpWorkbook.Workbook.Names["input_mgmt_az1_tor2_peer_bgp_password"].Value
        }

        $nsxtEdgeObject = @()
        $nsxtEdgeObject += [pscustomobject]@{
            'edgeClusterName'               = $pnpWorkbook.Workbook.Names["mgmt_ec_name"].Value
            'edgeRootPassword'              = $pnpWorkbook.Workbook.Names["nsxt_en_root_password"].Value
            'edgeAdminPassword'             = $pnpWorkbook.Workbook.Names["nsxt_en_admin_password"].Value
            'edgeAuditPassword'             = $pnpWorkbook.Workbook.Names["nsxt_en_audit_password"].Value
            'edgeFormFactor'                = $pnpWorkbook.Workbook.Names["mgmt_ec_formfactor"].Value 
            'tier0ServicesHighAvailability' = "ACTIVE_ACTIVE"
            'asn'                           = $pnpWorkbook.Workbook.Names["mgmt_en_asn"].Value
            edgeServicesSpecs               = ($edgeServicesObject | Select-Object -Skip 0)
            edgeNodeSpecs                   = $edgeNodeObject
            bgpNeighbours                   = $bgpNeighboursObject
        }
        
        $logicalSegmentsObject = @()
        $logicalSegmentsObject += [pscustomobject]@{
            'name'        = $pnpWorkbook.Workbook.Names["reg_seg01_name"].Value
            'networkType' = "REGION_SPECIFIC"
        }
        $logicalSegmentsObject += [pscustomobject]@{
            'name'        = $pnpWorkbook.Workbook.Names["xreg_seg01_name"].Value
            'networkType' = "X_REGION"
        }

        $nsxtObject = @()
        $nsxtObject += [pscustomobject]@{
            'nsxtManagerSize'                = $pnpWorkbook.Workbook.Names["mgmt_nsxt_mgr_formfactor"].Value.tolower()
            nsxtManagers                     = $nsxtManagerObject
            'rootNsxtManagerPassword'        = $pnpWorkbook.Workbook.Names["nsxt_lm_root_password"].Value
            'nsxtAdminPassword'              = $pnpWorkbook.Workbook.Names["nsxt_lm_admin_password"].Value
            'nsxtAuditPassword'              = $pnpWorkbook.Workbook.Names["nsxt_lm_audit_password"].Value
            'rootLoginEnabledForNsxtManager' = "true"
            'sshEnabledForNsxtManager'       = "true"
            overLayTransportZone             = ($overlayTransportZoneObject | Select-Object -Skip 0)
            vlanTransportZone                = ($vlanTransportZoneObject | Select-Object -Skip 0)
            'vip'                            = $pnpWorkbook.Workbook.Names["mgmt_nsxt_vip_ip"].Value
            'vipFqdn'                        = $pnpWorkbook.Workbook.Names["mgmt_nsxt_hostname"].Value
            'nsxtLicense'                    = $nsxtLicense
            'transportVlanId'                = $pnpWorkbook.Workbook.Names["mgmt_az1_host_overlay_vlan"].Value -as [int]
        }

        $excelvsanDedup = $pnpWorkbook.Workbook.Names["mgmt_vsan_dedup"].Value
        if ($excelvsanDedup -eq "No") {
            $vsanDedup = $false
        } elseif ($excelvsanDedup -eq "Yes") {
            $vsanDedup = $true
        }

        if ($pnpWorkbook.Workbook.Names["mgmt_principal_storage_chosen"].Value -eq "vSAN-ESA") {
            $ESAenabledtrueobject = @()
            $ESAenabledtrueobject += [pscustomobject]@{
                'enabled' = "true"
            }
        } else {
            $ESAenabledtrueobject = @()
            $ESAenabledtrueobject += [pscustomobject]@{
                'enabled' = "false"
            } 
        }

        $vsanObject = @()
        if ($pnpWorkbook.Workbook.Names["mgmt_principal_storage_chosen"].Value -eq "vSAN-ESA") {
            $vsanObject += [pscustomobject]@{
                'vsanName'      = "vsan-1"
                'licenseFile'   = $vsanLicense
                'vsanDedup'     = $vsanDedup
                'datastoreName' = $pnpWorkbook.Workbook.Names["mgmt_vsan_datastore"].Value
                esaConfig       = ($ESAenabledtrueobject | Select-Object -Skip 0)
            }
        } else {
            $vsanObject += [pscustomobject]@{
                'vsanName'      = "vsan-1"
                'licenseFile'   = $vsanLicense
                'vsanDedup'     = $vsanDedup
                'datastoreName' = $pnpWorkbook.Workbook.Names["mgmt_vsan_datastore"].Value
            }
        }
        $niocObject = @()
        $niocObject += [pscustomobject]@{
            'trafficType' = "VSAN"
            'value'       = "HIGH"
        }
        $niocObject += [pscustomobject]@{
            'trafficType' = "VMOTION"
            'value'       = "LOW"
        }
        $niocObject += [pscustomobject]@{
            'trafficType' = "VDP"
            'value'       = "LOW"
        }
        $niocObject += [pscustomobject]@{
            'trafficType' = "VIRTUALMACHINE"
            'value'       = "HIGH"
        }
        $niocObject += [pscustomobject]@{
            'trafficType' = "MANAGEMENT"
            'value'       = "NORMAL"
        }
        $niocObject += [pscustomobject]@{
            'trafficType' = "NFS"
            'value'       = "LOW"
        }
        $niocObject += [pscustomobject]@{
            'trafficType' = "HBR"
            'value'       = "LOW"
        }
        $niocObject += [pscustomobject]@{
            'trafficType' = "FAULTTOLERANCE"
            'value'       = "LOW"
        }
        $niocObject += [pscustomobject]@{
            'trafficType' = "ISCSI"
            'value'       = "LOW"
        }

        $dvsObject = @()
        $dvsObject += [pscustomobject]@{
            'mtu'      = $dvsMtu
            niocSpecs  = $niocObject
            'dvsName'  = $pnpWorkbook.Workbook.Names["primary_vds_name"].Value
            'vmnics'   = $vmnics
            'networks' = $networks
        }

        $vmFolderObject = @()
        $vmFOlderObject += [pscustomobject]@{
            'MANAGEMENT' = $pnpWorkbook.Workbook.Names["mgmt_mgmt_vm_folder"].Value
            'NETWORKING' = $pnpWorkbook.Workbook.Names["mgmt_nsx_vm_folder"].Value
            'EDGENODES'  = $pnpWorkbook.Workbook.Names["mgmt_edge_vm_folder"].Value
        }

        if (($pnpWorkbook.Workbook.Names["mgmt_evc_mode"].Value -eq "n/a") -or ($pnpWorkbook.Workbook.Names["mgmt_evc_mode"].Value -eq $null)) {
            $evcMode = ""
        } else {
            $evcMode = $pnpWorkbook.Workbook.Names["mgmt_evc_mode"].Value
        }

        $resourcePoolObject = @()
        $resourcePoolObject += [pscustomobject]@{
            'type'                        = "management"
            'name'                        = $pnpWorkbook.Workbook.Names["mgmt_mgmt_rp"].Value
            'cpuSharesLevel'              = "high"
            'cpuSharesValue'              = "0" -as [int]
            'cpuLimit'                    = "-1" -as [int]
            'cpuReservationExpandable'    = $true
            'cpuReservationPercentage'    = "0" -as [int]
            'memorySharesLevel'           = "normal"
            'memorySharesValue'           = "0" -as [int]
            'memoryLimit'                 = "-1" -as [int]
            'memoryReservationExpandable' = $true
            'memoryReservationPercentage' = "0" -as [int]
        }
        $resourcePoolObject += [pscustomobject]@{
            'type'                        = "network"
            'name'                        = $pnpWorkbook.Workbook.Names["mgmt_nsx_rp"].Value
            'cpuSharesLevel'              = "high"
            'cpuSharesValue'              = "0" -as [int]
            'cpuLimit'                    = "-1" -as [int]
            'cpuReservationExpandable'    = $true
            'cpuReservationPercentage'    = "0" -as [int]
            'memorySharesLevel'           = "normal"
            'memorySharesValue'           = "0" -as [int]
            'memoryLimit'                 = "-1" -as [int]
            'memoryReservationExpandable' = $true
            'memoryReservationPercentage' = "0" -as [int]
        }
        $resourcePoolObject += [pscustomobject]@{
            'type'                        = "compute"
            'name'                        = $pnpWorkbook.Workbook.Names["mgmt_user_edge_rp"].Value
            'cpuSharesLevel'              = "normal"
            'cpuSharesValue'              = "0" -as [int]
            'cpuLimit'                    = "-1" -as [int]
            'cpuReservationExpandable'    = $true
            'cpuReservationPercentage'    = "0" -as [int]
            'memorySharesLevel'           = "normal"
            'memorySharesValue'           = "0" -as [int]
            'memoryLimit'                 = "-1" -as [int]
            'memoryReservationExpandable' = $true
            'memoryReservationPercentage' = "0" -as [int]
        }
        $resourcePoolObject += [pscustomobject]@{
            'type'                        = "compute"
            'name'                        = $pnpWorkbook.Workbook.Names["mgmt_user_vm_rp"].Value
            'cpuSharesLevel'              = "normal"
            'cpuSharesValue'              = "0" -as [int]
            'cpuLimit'                    = "-1" -as [int]
            'cpuReservationExpandable'    = $true
            'cpuReservationPercentage'    = "0" -as [int]
            'memorySharesLevel'           = "normal"
            'memorySharesValue'           = "0" -as [int]
            'memoryLimit'                 = "-1" -as [int]
            'memoryReservationExpandable' = $true
            'memoryReservationPercentage' = "0" -as [int]
        }

        if ($pnpWorkbook.Workbook.Names["mgmt_consolidated_result"].Value -eq "Included") {
            $clusterObject = @()
            $clusterObject += [pscustomobject]@{
                vmFolders         = ($vmFolderObject | Select-Object -Skip 0)
                'clusterName'     = $pnpWorkbook.Workbook.Names["mgmt_cluster"].Value
                'clusterEvcMode'  = $evcMode
                resourcePoolSpecs = $resourcePoolObject
            }
        } else {
            $clusterObject = @()
            $clusterObject += [pscustomobject]@{
                vmFolders        = ($vmFolderObject | Select-Object -Skip 0)
                'clusterName'    = $pnpWorkbook.Workbook.Names["mgmt_cluster"].Value
                'clusterEvcMode' = $evcMode
            }
        }

        $ssoObject = @()
        $ssoObject += [pscustomobject]@{
            'ssoDomain' = 'vsphere.local'
        }

        $pscObject = @()
        $pscObject += [pscustomobject]@{
            pscSsoSpec             = ($ssoObject | Select-Object -Skip 0)
            'adminUserSsoPassword' = $pnpWorkbook.Workbook.Names["administrator_vsphere_local_password"].Value
        }

        $vcenterObject = @()
        $vcenterObject += [pscustomobject]@{
            'vcenterIp'           = $pnpWorkbook.Workbook.Names["mgmt_vc_ip"].Value
            'vcenterHostname'     = $pnpWorkbook.Workbook.Names["mgmt_vc_hostname"].Value
            'licenseFile'         = $vcenterLicense
            'rootVcenterPassword' = $pnpWorkbook.Workbook.Names["vcenter_root_password"].Value
            'vmSize'              = $pnpWorkbook.Workbook.Names["mgmt_vc_size"].Value.tolower()
        }

        $hostCredentialsObject = @()
        $hostCredentialsObject += [pscustomobject]@{
            'username' = 'root'
            'password' = $pnpWorkbook.Workbook.Names["esxi_root_password"].Value
        }

        $ipAddressPrivate01Object = @()
        $ipAddressPrivate01Object += [pscustomobject]@{
            'subnet'    = $esxManagmentMaskObject.IPAddressToString
            'ipAddress' = $pnpWorkbook.Workbook.Names["mgmt_az1_host1_mgmt_ip"].Value
            'gateway'   = $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_gateway_ip"].Value
        }

        $ipAddressPrivate02Object = @()
        $ipAddressPrivate02Object += [pscustomobject]@{
            'subnet'    = $esxManagmentMaskObject.IPAddressToString
            'ipAddress' = $pnpWorkbook.Workbook.Names["mgmt_az1_host2_mgmt_ip"].Value
            'gateway'   = $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_gateway_ip"].Value
        }

        $ipAddressPrivate03Object = @()
        $ipAddressPrivate03Object += [pscustomobject]@{
            'subnet'    = $esxManagmentMaskObject.IPAddressToString
            'ipAddress' = $pnpWorkbook.Workbook.Names["mgmt_az1_host3_mgmt_ip"].Value
            'gateway'   = $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_gateway_ip"].Value
        }

        $ipAddressPrivate04Object = @()
        $ipAddressPrivate04Object += [pscustomobject]@{
            'subnet'    = $esxManagmentMaskObject.IPAddressToString
            'ipAddress' = $pnpWorkbook.Workbook.Names["mgmt_az1_host4_mgmt_ip"].Value
            'gateway'   = $pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_gateway_ip"].Value
        }

        $HostObject = @()
        $HostObject += [pscustomobject]@{
            'hostname'       = $pnpWorkbook.Workbook.Names["mgmt_az1_host1_hostname"].Value
            'vSwitch'        = $pnpWorkbook.Workbook.Names["mgmt_vss_switch"].Value
            'association'    = $pnpWorkbook.Workbook.Names["mgmt_datacenter"].Value
            credentials      = ($hostCredentialsObject | Select-Object -Skip 0)
            ipAddressPrivate = ($ipAddressPrivate01Object | Select-Object -Skip 0)
        }
        $HostObject += [pscustomobject]@{
            'hostname'       = $pnpWorkbook.Workbook.Names["mgmt_az1_host2_hostname"].Value
            'vSwitch'        = $pnpWorkbook.Workbook.Names["mgmt_vss_switch"].Value
            'association'    = $pnpWorkbook.Workbook.Names["mgmt_datacenter"].Value
            credentials      = ($hostCredentialsObject | Select-Object -Skip 0)
            ipAddressPrivate = ($ipAddressPrivate02Object | Select-Object -Skip 0)
        }
        $HostObject += [pscustomobject]@{
            'hostname'       = $pnpWorkbook.Workbook.Names["mgmt_az1_host3_hostname"].Value
            'vSwitch'        = $pnpWorkbook.Workbook.Names["mgmt_vss_switch"].Value
            'association'    = $pnpWorkbook.Workbook.Names["mgmt_datacenter"].Value
            credentials      = ($hostCredentialsObject | Select-Object -Skip 0)
            ipAddressPrivate = ($ipAddressPrivate03Object | Select-Object -Skip 0)
        }
        $HostObject += [pscustomobject]@{
            'hostname'       = $pnpWorkbook.Workbook.Names["mgmt_az1_host4_hostname"].Value
            'vSwitch'        = $pnpWorkbook.Workbook.Names["mgmt_vss_switch"].Value
            'association'    = $pnpWorkbook.Workbook.Names["mgmt_datacenter"].Value
            credentials      = ($hostCredentialsObject | Select-Object -Skip 0)
            ipAddressPrivate = ($ipAddressPrivate04Object | Select-Object -Skip 0)
        }

        $excluded = New-Object System.Collections.ArrayList
        [Array]$excluded = "NSX-V"

        $ceipState = $pnpWorkbook.Workbook.Names["mgmt_ceip_status"].Value
        if ($ceipState -eq "Yes") {
            $ceipEnabled = "$true"
        } else {
            $ceipEnabled = "$false"
        }

        $fipsState = $pnpWorkbook.Workbook.Names["mgmt_fips_status"].Value
        if ($fipsState -eq "Yes") {
            $fipsEnabled = "$true"
        } else {
            $fipsEnabled = "$false"
        }
        
        $managementDomainObject = New-Object -TypeName psobject
        $managementDomainObject | Add-Member -notepropertyname 'taskName' -notepropertyvalue "workflowconfig/workflowspec-ems.json"
        $managementDomainObject | Add-Member -notepropertyname 'sddcId' -notepropertyvalue $pnpWorkbook.Workbook.Names["mgmt_sddc_domain"].Value
        $managementDomainObject | Add-Member -notepropertyname 'ceipEnabled' -notepropertyvalue $ceipEnabled
        $managementDomainObject | Add-Member -notepropertyname 'fipsEnabled' -notepropertyvalue $fipsEnabled
        $managementDomainObject | Add-Member -notepropertyname 'managementPoolName' -notepropertyvalue $pnpWorkbook.Workbook.Names["mgmt_az1_pool_name"].Value
        $managementDomainObject | Add-Member -notepropertyname 'skipEsxThumbprintValidation' -notepropertyvalue $true
        $managementDomainObject | Add-Member -notepropertyname 'esxLicense' -notepropertyvalue $esxLicense
        $managementDomainObject | Add-Member -notepropertyname 'excludedComponents' -notepropertyvalue $excluded
        $managementDomainObject | Add-Member -notepropertyname 'ntpServers' -notepropertyvalue $ntpServers
        $managementDomainObject | Add-Member -notepropertyname 'dnsSpec' -notepropertyvalue ($dnsObject | Select-Object -Skip 0)
        $managementDomainObject | Add-Member -notepropertyname 'sddcManagerSpec' -notepropertyvalue ($sddcManagerObject | Select-Object -Skip 0)
        $managementDomainObject | Add-Member -notepropertyname 'networkSpecs' -notepropertyvalue $networkObject
        $managementDomainObject | Add-Member -notepropertyname 'nsxtSpec' -notepropertyvalue ($nsxtObject | Select-Object -Skip 0)
        $managementDomainObject | Add-Member -notepropertyname 'vsanSpec' -notepropertyvalue ($vsanObject | Select-Object -Skip 0)
        $managementDomainObject | Add-Member -notepropertyname 'dvsSpecs' -notepropertyvalue $dvsObject
        $managementDomainObject | Add-Member -notepropertyname 'clusterSpec' -notepropertyvalue ($clusterObject | Select-Object -Skip 0)
        $managementDomainObject | Add-Member -notepropertyname 'pscSpecs' -notepropertyvalue $pscObject
        $managementDomainObject | Add-Member -notepropertyname 'vcenterSpec' -notepropertyvalue ($vcenterObject | Select-Object -Skip 0)
        $managementDomainObject | Add-Member -notepropertyname 'hostSpecs' -notepropertyvalue $hostObject
        if ($pnpWorkbook.Workbook.Names["vcf_version"].Value -gt "v5.0.x") {
            if ($pnpWorkbook.Workbook.Names["vcf_plus_chosen"].Value -eq "Included") {
                $managementDomainObject | Add-Member -notepropertyname 'subscriptionLicensing' -notepropertyvalue "True"
            } else {
                $managementDomainObject | Add-Member -notepropertyname 'subscriptionLicensing' -notepropertyvalue "False"
            }
        }

        Write-Output "Exporting the $module to $($path)$($pnpWorkbook.Workbook.Names["mgmt_sddc_domain"].Value)-domainSpec.json"
        $managementDomainObject | ConvertTo-Json -Depth 12 | Out-File -Encoding UTF8 -FilePath $jsonPath"$($pnpWorkbook.Workbook.Names["mgmt_sddc_domain"].Value)-domainSpec.json"
        Write-Output "Closing the Excel Workbook: $workbook"
        Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
        Write-Output "Completed the Process of Generating the $module"
    } Catch {
        ResponseException -object $_
    }
}
Export-ModuleMember -Function Export-VCFManagementDomainJsonSpec
#EndRegion JSON Export Functions
