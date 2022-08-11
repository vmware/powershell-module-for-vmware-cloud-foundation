![](https://img.shields.io/powershellgallery/v/PowerVCF?style=for-the-badge&logo=powershell&logoColor=white)&nbsp;&nbsp; 
![](https://img.shields.io/powershellgallery/dt/PowerVCF?style=for-the-badge&logo=powershell&logoColor=white)

[<img alt="Documentation" src="https://img.shields.io/badge/Documentation-Read-blue?style=for-the-badge&logo=readthedocs&logoColor=white">][module-documentation]&nbsp;&nbsp; 
[<img alt="Changelog" src="https://img.shields.io/badge/Changelog-Read-blue?style=for-the-badge">](CHANGELOG.md)


# PowerVCF: A PowerShell Module for VMware Cloud Foundation

PowerVCF is an open source PowerShell Module for interacting with the VMware Cloud Foundation (SDDC Manager & Cloud Builder) public API.

Module
* [Module Documentation][module-documentation]

VMware Cloud Foundation
* [Product Documentation][product-documentation]
* [API Documentation][api-documentation]

## Requirements

* VMware Cloud Foundation 4.0 or later.

    The module supports versions in accordance with the VMware Product Lifecycle Matrix from General Availability to End of General Support.

    * Learn more: [VMware Product Lifecycle Matrix][product-lifecycle-matrix]

* PowerCLI 12.3.0 or later
* Windows PowerShell 5.x
* PowerShell Core 6.x and 7.x

This version is supported with VMware Cloud Foundation 4.0 and above due to changes in the API authentication process.

## Supported Platforms

This version has been tested using vSAN Ready Nodes.

VMware Cloud Foundation on VxRail has not been fully tested, The following cmdlets will not work with VxRail as the workflow is different due to the use of VxRail Manager. _Other cmdlets may work subject to testing._

* `New-VCFCommissionedHost`

* `Remove-VCFCommissionedHost`

* All Network pool actions

* `New-`, `Set-`, and `Remove-` Workload Domains

## Installing the Module

To install the module from the PowerShell Gallery Open PowerShell as Administrator and run the following

```powershell
Install-Module -Name PowerVCF
```

Alternatively to manually install the module download the full module zip from the GitHub repo, extract and run the following in PowerShell

```powershell
Import-Module .\PowerVCF
```

## Getting Started

All API operations must currently be authenticated using the SDDC Manager `admin` account.

To create a `base64` credential to authenticate each cmdlet you must first run:

```powershell
Connect-VCFManager -fqdn sfo-vcf01.sfo.rainpole.io -username admin -password VMw@re1!
```

> **Note**: 
> 
> Both `-username` and `-password` are optional parameters. If not passed, a credential window will be presented.

Authentication is only valid for the duration of the PowerShell session.

## Examples

### Get a List of Hosts

`Get-VCFHost`

**Sample Output**

```powershell
id                  : 598519e7-cbba-4a10-801d-d76111f3ce0e
esxiVersion         : 7.0.2-17867351
fqdn                : sfo01-m01-esx01.sfo.rainpole.io
hardwareVendor      : Dell Inc.
hardwareModel       : PowerEdge R630
ipAddresses         : {@{ipAddress=172.28.211.101; type=MANAGEMENT}, @{ipAddress=172.28.213.101; type=VSAN},
                      @{ipAddress=172.28.212.101; type=VMOTION}}
cpu                 : @{frequencyMHz=55999.953125; usedFrequencyMHz=11209.0; cores=28; cpuCores=System.Object[]}
memory              : @{totalCapacityMB=262050.28125; usedCapacityMB=59413.0}
storage             : @{totalCapacityMB=7325664.0; usedCapacityMB=297924.625; disks=System.Object[]}
physicalNics        : {@{deviceName=vmnic0; macAddress=24:6e:96:56:10:50}, @{deviceName=vmnic1; macAddress=24:6e:96:56:10:52},
                      @{deviceName=vmnic2; macAddress=24:6e:96:56:10:54}, @{deviceName=vmnic3; macAddress=24:6e:96:56:10:55}}
domain              : @{id=51cc2d90-13b9-4b62-b443-c1d7c3be0c23}
networkpool         : @{id=0e06eff5-9fe7-4299-940b-5c8beb3f3ac0; name=sfo-m01-np01}
cluster             : @{id=cc747835-79bc-4900-8703-f5ef1fa87990}
status              : ASSIGNED
bundleRepoDatastore : lcm-bundle-repo
hybrid              : False
```

Responses can be filtered like this:

```powershell
Get-VCFHost -id 598519e7-cbba-4a10-801d-d76111f3ce0e | Select esxiVersion
```

```powershell
esxiVersion
-----------
7.0.2-17867351
```

Or like this:

```powershell
$hostDetail = Get-VCFHost -id 598519e7-cbba-4a10-801d-d76111f3ce0e
$hostDetail.esxiVersion
```

```powershell
7.0.2-17867351
```

## Get Help

For a full list of supported cmdlets run the following

```powershell
Get-Command -Module PowerVCF
```

All cmdlets support the following:

```powershell
Get-Help cmdlet-name

Get-Help cmdlet-name -examples

Get-Help cmdlet-name -detailed

Get-Help cmdlet-name -full
```

## Contributing

PowerVCF is the work of many contributors and the project team appreciates your help!

If you discover a bug or would like to suggest an enhancement, submit [an issue][issues]. Once submitted, your issue will follow an issue lifecycle process.

If you would like to submit a pull request, please read the [contribution guidelines][contributing] to get started.

## Disclaimer
This is not an officially supported VMware PowerShell Module.

The purpose of this module is to make VMware Cloud Foundation API more accessible to fans of PowerCLI and drive adoption of the VMware Cloud Foundation API & VMware Cloud Foundation in general.

It is provided without warranty and should not be used in a production environment without thoroughly testing first.

[contributing]: CONTRIBUTING.md
[issues]: /issues
[api-documentation]: https://developer.vmware.com/apis/1181/vmware-cloud-foundation
[module-documentation]: https://vmware.github.io/powershell-module-for-vmware-cloud-foundation/docs
[product-documentation]: https://docs.vmware.com/en/VMware-Cloud-Foundation
[product-lifecycle-matrix]: https://lifecycle.vmware.com
