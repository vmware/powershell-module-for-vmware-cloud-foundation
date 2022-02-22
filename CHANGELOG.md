# Release History

## v2.1.8 (2021-xx-xx)
- Fixed `Get-VCFApplicationVirtualNetwork`cmdlet when passing the ID of the Application Virtual Network the response was failing.
- Updated `Get-VCFFederation` cmdlet to check the system version, multi-instance management is deprecated in VMware Cloud Foundation v4.4.0.
- Updated `Set-VCFFederation` cmdlet to check the system version, multi-instance management is deprecated in VMware Cloud Foundation v4.4.0.
- Updated `Remove-VCFFederation` cmdlet to check the system version, multi-instance management is deprecated in VMware Cloud Foundation v4.4.0.
- Updated `Get-VCFFederationMember` cmdlet to check the system version, multi-instance management is deprecated in VMware Cloud Foundation v4.4.0.
- Updated `New-VCFFederationInvite` cmdlet to check the system version, multi-instance management is deprecated in VMware Cloud Foundation v4.4.0.
- Updated `Join-VCFFederation` cmdlet to check the system version, multi-instance management is deprecated in VMware Cloud Foundation v4.4.0.
- Updated `Get-VCFFederationTask` cmdlet to check the system version, multi-instance management is deprecated in VMware Cloud Foundation v4.4.0.

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