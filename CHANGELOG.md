# Release History

## v2.3.0 (Not Released)

- Enhanced `validateJsonInput` cmdlet for consistency across functions.
- Enhanced `Get-VCFDepotCredential` cmdlet to support retrieving the VxRail depot details.
- Updated `New-VCFCluster` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Add-VCFApplicationVirtualNetwork` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Set-VCFBackupConfiguration` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Start-VCFBundleUpload` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Set-VCFCluster` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Set-VCFCredential` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `New-VCFCluster` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Restart-VCFCredentialTask` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `New-VCFWorkloadDomain` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Set-VCFFederation` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `New-VCFCommissionedHost` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Remove-VCFCommissionedHost` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `New-VCFNetworkPool` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `New-VCFEdgeCluster` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Restart-CloudBuilderSDDC` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Start-VCFHealthSummary` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Start-VCFSupportBundle` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Start-VCFSystemPrecheck` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Start-VCFUpgrade` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Set-VCFConfigurationDNS` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Set-VCFConfigurationNTP` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `New-VCFvRSLCM` cmdlet to consume enhanced `validateJsonInput` function.
- Updated `Get-VCFManager` cmdlet synopsis, description and examples.
- Updated `Set-VCFFederation` cmdlet synopsis, description and examples.
- Updated `Get-VCFConfigurationDNSValidation` cmdlets synopsis, description and examples.
- Updated `Get-VCFCertificateCSR` cmdlets synopsis, description and examples.
- Updated `Get-VCFvRLI` cmdlets synopsis, description and examples.
- Updated `README.md`, and added module metadata.
- Added region block identifiers for better developer and contributor experience when navigating the PowerShell module code.
- Added GitHub Pages Documentation for PowerVCF.
- Added `Get-VCFFipsMode` cmdlet to return the status for FIPS mode.
- Added `Get-VCFRelease` cmdlet to retrieve details for releases.
- Added `Get-VCFCredentialExpiry` cmdlet to retrieve the password expiry details for credentials.

## v2.2.0 (2022-26-05)

- Fixed `Get-VCFApplicationVirtualNetwork`cmdlet when passing the ID of the Application Virtual Network the response was failing.
- Updated `Get-VCFFederation` cmdlet to check the system version, multi-instance management is deprecated in VMware Cloud Foundation v4.4.0.
- Updated `Set-VCFFederation` cmdlet to check the system version, multi-instance management is deprecated in VMware Cloud Foundation v4.4.0.
- Updated `Remove-VCFFederation` cmdlet to check the system version, multi-instance management is deprecated in VMware Cloud Foundation v4.4.0.
- Updated `Get-VCFFederationMember` cmdlet to check the system version, multi-instance management is deprecated in VMware Cloud Foundation v4.4.0.
- Updated `New-VCFFederationInvite` cmdlet to check the system version, multi-instance management is deprecated in VMware Cloud Foundation v4.4.0.
- Updated `Join-VCFFederation` cmdlet to check the system version, multi-instance management is deprecated in VMware Cloud Foundation v4.4.0.
- Updated `Get-VCFFederationTask` cmdlet to check the system version, multi-instance management is deprecated in VMware Cloud Foundation v4.4.0.
- Updated `Request-VCFToken` cmdlet to support -skipCertificateCheck switch and removed the alias for Connect-VCFToken.
- Updated `Connect-CloudBuilder` cmdlet to support -skipCertificateCheck switch.
- Updated `Get-VCFCredentialTask` cmdlet to support -status validation set.
- Added `Get-VCFPSC` cmdlet to support the retrieval of Platform Services Controllers from the SDDC Manager inventory.

## v2.1.7 (2021-30-11)

- Fixed `New-VCFCluster`cmdlet where incorrect braces prevented the ability to retrieve response information.
- Added `Get-VCFvRLIConnection` cmdlet to get the connection status of VI Workload Domains to vRealize Log Insight.
- Rename `Set-VCFvRLIConnection` cmdlet from `Set-VCFvRLI` to align with new Get-VCFvRLIConnection cmdlet.
- Added `Get-VCFvROPSConnection` cmdlet to get the connection status of VI Workload Domains to vRealize Operations Manager.
- Rename `Set-VCFvROPSConnection` cmdlet from `Set-VCFvROPs` to align with new Get-VCFvROPSConnection cmdlet.
- Updated `New-VCFLicenseKey` cmdlet to support additonal license types "WCP", "NSXV", "HORIZON_VIEW".
- Updated `Get-VCFvROPs` cmdlet to display API output in an easier to read format.
- Updated `Get-VCFWSA` cmdlet to display API output in an easier to read format.
- Updated `Get-VCFvRA` cmdlet to display API output in an easier to read format.
- Updated `Get-VCFvRLI` cmdlet to display API output in an easier to read format.