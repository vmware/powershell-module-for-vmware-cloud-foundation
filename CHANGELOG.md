# Release History
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