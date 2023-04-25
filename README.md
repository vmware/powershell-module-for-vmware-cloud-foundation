<img src=".github/icon-400px.svg" alt="A PowerShell Module for VMware Validated Soltions" width="150"></br></br>

# PowerVCF: A PowerShell Module for VMware Cloud Foundation

[<img src="https://img.shields.io/powershellgallery/v/PowerVCF?style=for-the-badge&logo=powershell&logoColor=white" alt="PowerShell Gallery">][module-powervcf]&nbsp;&nbsp;[<img src="https://img.shields.io/badge/Changelog-Read-blue?style=for-the-badge&logo=github&logoColor=white" alt="CHANGELOG">][changelog]&nbsp;&nbsp;
[<img src="https://img.shields.io/powershellgallery/dt/PowerVCF?style=for-the-badge&logo=powershell&logoColor=white" alt="PowerShell Gallery Downloads">][module-powervcf]&nbsp;&nbsp;
[<img alt="Documentation" src="https://img.shields.io/badge/Documentation-Read-blue?style=for-the-badge&logo=readthedocs&logoColor=white">][module-powervcf-documentation]&nbsp;&nbsp;

`PowerVCF` is an open source PowerShell Module for interacting with the VMware Cloud Foundation (SDDC Manager & Cloud Builder) public API.

Module

* [Module Documentation][module-powervcf-documentation]

VMware Cloud Foundation

* [Product Documentation][product-documentation]
* [API Documentation][product-api]

## Requirements

### Platform

* VMware Cloud Foundation 4.0 or later.

    The module supports versions in accordance with the VMware Product Lifecycle Matrix from General Availability to End of General Support.

    Learn more: [VMware Product Lifecycle Matrix][product-lifecycle-matrix]

    > **Note**
    >
    > This version has been tested using vSAN Ready Nodes.
    >
    > VMware Cloud Foundation on VxRail has not been fully tested. The following cmdlets will not work with VxRail as the workflow is different due to the use of VxRail Manager.
    >
    > * `New-VCFCommissionedHost`
    > * `Remove-VCFCommissionedHost`
    > * All Network pool actions
    > * `New-`, `Set-`, and `Remove-` for Workload Domains
    >
    > Other cmdlets may work but are subject to testing.

### PowerShell

* [Microsoft Windows PowerShell][microsoft-powershell] 5.x
* [Microsoft PowerShell Core][microsoft-powershell] 6.x and 7.x

### PowerShell Modules

* [`VMware PowerCLI`][module-vmware-powercli] 12.3.0 or later

## Installing the Module

Verify that your system has a supported edition and version of PowerShell installed.

Install the module from the PowerShell Gallery by opening a PowerShell session as an Administrator and running the following command:

```powershell
Install-Module -Name PowerVCF
```

## Updating the Module

Update the PowerShell module to the latest release from the Microsoft PowerShell Gallery by running the following command in the PowerShell console:

```powershell
Update-Module -Name PowerVCF
```

To verify the version of the PowerShell module, run the following command in the PowerShell console.

```powershell
Get-InstalledModule -Name PowerVCF
```

## Getting Help

To view the cmdlets available in the module, run the following command in the PowerShell console.

```powershell
Get-Command -Module PowerVCF
```

To view the help for any cmdlet, run the `Get-Help` command in the PowerShell console.

For example:

```powershell
Get-Help -Name Request-VCFToken
```

```powershell
Get-Help -Name Request-VCFToken -examples
```

```powershell
Get-Help -Name Request-VCFToken -full
```

## Getting Started

All API operations must be authenticated via SDDC Manager. To create a `base64` credential to authenticate each cmdlet you must first run the `Request-VCFToken` cmdlet.

This example shows how to connect to SDDC Manager to request API access & refresh tokens using the default `administrator@vsphere.local` vCenter Single Sign-On administrator account.

```powershell
Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username administrator@vsphere.local -password VMw@re1!
```

This example shows how to connect to SDDC Manager using the `admin@local` local administrator account.

```powershell
Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username admin@local -password VMw@re1!VMw@re1!
```

> **Note**
>
> Both `-username` and `-password` are optional parameters. If not passed, a credential window will be presented.

Authentication is only valid for the duration of the PowerShell session.

## Examples

### Get a List of Hosts

```powershell
Get-VCFHost
```

Sample Output:

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

You can also filter the output of the cmdlet.

Example 1:

```powershell
Get-VCFHost -id 598519e7-cbba-4a10-801d-d76111f3ce0e | Select esxiVersion
```

```powershell
esxiVersion
-----------
7.0.2-17867351
```

Example 2:

```powershell
$hostDetail = Get-VCFHost -id 598519e7-cbba-4a10-801d-d76111f3ce0e
$hostDetail.esxiVersion
```

```powershell
7.0.2-17867351
```

## Contributing

The project team welcomes contributions from the community. Before you start working with PowerValidatedSolutions, please read our [Developer Certificate of Origin][vmware-cla-dco]. All contributions to this repository must be signed as described on that page. Your signature certifies that you wrote the patch or have the right to pass it on as an open-source patch.

For more detailed information, refer to the [contribution guidelines][contributing] to get started.

## Disclaimer

This PowerShell module is not supported by VMware Support.

If you discover a bug or would like to suggest an enhancement, please [open an issue][issues].

## License

Copyright 2021-2023 VMware, Inc.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[//]: Links

[changelog]: CHANGELOG.md
[contributing]: CONTRIBUTING.md
[issues]: https://github.com/vmware/powershell-module-for-vmware-cloud-foundation/issues
[product-api]: https://developer.vmware.com/apis/1181/vmware-cloud-foundation
[product-documentation]: https://docs.vmware.com/en/VMware-Cloud-Foundation
[product-lifecycle-matrix]: https://lifecycle.vmware.com
[microsoft-powershell]: https://docs.microsoft.com/en-us/powershell
[module-vmware-powercli]: https://www.powershellgallery.com/packages/VMware.PowerCLI
[module-powervcf]: https://www.powershellgallery.com/packages/PowerVCF
[module-powervcf-documentation]: https://vmware.github.io/powershell-module-for-vmware-cloud-foundation/docs
[module-powervcf-releases]: https://github.com/vmware/powershell-module-for-vmware-cloud-foundation/releases
[vmware-cla-dco]: https://cla.vmware.com/dco
