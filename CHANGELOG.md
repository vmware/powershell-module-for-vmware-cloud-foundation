# Release History

## v2.5.0

> Released: Unreleased

- Updated `Get-VCFTask` cmdlet with additional exception message to catch.
- Updated `Get-VCFSystemPrecheckTask` cmdlet with optional parameter `failureOnly`.
- Updated `Get-VCFPersonality` cmdlet with optional parameter `name`.
- Updated `New-VCFWorkloadDomain` cmdlet with optional parameter `validate` to validate the JSON specification.
- Enhanced `New-VCFWorkloadDomain` cmdlet to improve error handling.
- Enhanced `New-VCFCommissionedHost` cmdlet to improve error handling.
- Enhanced `New-VCFCommissionedHost` cmdlet with ability to use the host commission JSON specification provided by the SDDC Manager UI.
- Removed the deprecated `Commission-VCFHost` alias from `New-VCFCommissionedHost`.
- Removed the deprecated `Decommission-VCFHost` alias from `Remove-VCFCommissionedHost`.
- Removed the deprecated `Get-VCFNsxManagerCluster` alias from `Get-VCFNsxtCluster`.
- Removed the deprecated `Get-VCFNsxEdgeCluster` alias from `Get-VCFEdgeCluster`.
- Removed the deprecated `New-VCFNsxEdgeCluster` alias from `New-VCFEdgeCluster`.
- Refactors `Invoke-VCFCommand` to run commands on SDDC Manager without the need for SSH across PowerShell editions and operating systems.
- Added `Export-VCFManagementDomainJsonSpec` to export the JSON spec required for bringup from the Planning & Preparation Excel workbook.

## v2.4.1

> Released: 2023-12-15

- Updated the module's internal `checkVCFToken` function to ensure and expired token can be refresh when using PowerShell 7.

## v2.4.0

> Released: 2023-10-02

- Updated `Request-VCFToken` cmdlet for better error handling.
- Enhanced `Get-VCFCluster` cmdlet to return associated vSphere Distributed Switches.
- Enhanced `Get-VCFManager` cmdlet to return the SDDC Manager version in `x.y.z` format.
- Enhanced `Get-VCFManager` cmdlet to return the SDDC Manager build in `xxxxxxx` format.
- Added `Set-VCFCredentialAutoRotate` cmdlet to configure or disable credential auto-rotation for a credential managed by SDDC Manager.
- Added `Get-VCFProxy` cmdlet to retrieve the proxy configuration for the SDDC Manager.
- Added `Set-VCFProxy` cmdlet to configure the proxy configuration for the SDDC Manager.
- Added `Get-VCFIdentityProvider` cmdlet to retrieve the identity provider configuration.
- Added `Remove-VCFIdentityProvider` cmdlet to delete an identity provider.
- Added `New-VCFIdentityProvider` cmdlet to configure an embedded or external identity provider.
- Added `Update-VCFIdentityProvider` cmdlet to update the configuration of an embedded or external identity provider.
- Added cmdlet aliases:
  - Added `Get-VCFNsxManagerCluster` for `Get-VCFNsxtCluster`.
  - Added `Get-VCFNsxEdgeCluster` for `Get-VCFEdgeCluster`.
  - Added `Get-VCFAriaLifecycle` for `Get-VCFVrslcm`.
  - Added `New-VCFAriaLifecycle` for `New-VCFVrslcm`.
  - Added `Remove-VCFAriaLifecycle` for `Remove-VCFVrslcm`.
  - Added `Reset-VCFAriaLifecycle` for `Reset-VCFVrslcm`.
  - Added `Get-VCFAriaOperations` for `Get-VCFVrops`.
  - Added `Get-VCFAriaOperationsConnection` for `Get-VCFVropsConnection`.
  - Added `Set-VCFAriaOperationsConnection` for `Set-VCFVropsConnection`.
  - Added `Get-VCFAriaOperationsLogs` for `Get-VCFVrli`.
  - Added `Get-VCFAriaOperationsLogsConnection` for `Get-VCFVrliConnection`.
  - Added `Set-VCFAriaOperationsLogsConnection` for `Set-VCFVrliConnection`.
  - Added `Get-VCFAriaAutomation` for `Get-VCFVra`.
- Fixed `validateJsonInput` function to prevent it from truncating directly passed JSON content.

## v2.3.0

> Released: 2023-04-25

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
- Added `Get-VCFLicenseMode` cmdlet to retrieve the current license mode of the system & each domain
- Added `New-VCFPersonality` cmdlet to add a new vSphere Lifecycle Manager personality/image in the SDDC Manager inventory from an existing vLCM image based cluster

## v2.2.0

> Released: 2022-26-05

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

## v2.1.7

> Released: 2021-30-11

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
