# PowerVCF
PowerVCF is a PowerShell Module for interacting with the VMware Cloud Foundation (SDDC Manager) public API.

<a href="https://docs.vmware.com/en/VMware-Cloud-Foundation" target="_blank">VMware Cloud Foundation Product Documentation</a>

<a href="https://code.vmware.com/apis/723/vmware-cloud-foundation" target="_blank">VMware Cloud Foundation API Documentation</a>

# Disclaimer
This is not an officially supported VMware PowerShell Module. It was initially developed and maintained by Brian O'Connell who is a Staff Architect in the VMware Cloud Platform Business Unit (CPBU).

The purpose of this module is to make VMware Cloud Foundation API more accessible to fans of PowerCli and drive adoption of the VMware Cloud Foundation API & VMware Cloud Foundation in general. It is provided without warranty and should not be used in a production environment without thoroughly testing first. It has been developed against VMware Cloud Foundation 4.x and best efforts will be made to validate all cmdlets against future VMware Cloud Foundation versions but no promises!

## Contributors
If you would like to contribute please get in touch! Current contributors listed below.

Brian O'Connell - VMware CPBU Staff Architect \[[Twitter](https://twitter.com/LifeOfBrianOC)\] \[[Blog](https://LifeOfBrianOC.com)\]

Gary Blake - VMware CPBU Staff II Architect \[[Twitter](https://twitter.com/GaryJBlake)\] \[[Blog](https://my-cloudy-world.com/)\]

Giuliano Bertello - Dell EMC Sr. Principal Engineer Solutions Architecture \[[Twitter](https://twitter.com/GiulianoBerteo)\] \[[Blog](https://blog.bertello.org)\]


## Supported Platforms
This version has been tested using vSAN Ready Nodes. VxRail has not been tested, The following cmdlets will not work with VxRail as the API is different. _Other cmdlets may work subject to testing._

`Commission-VCFHost`

`Decommission-VCFHost`

All Network pool actions

New/Set/Remove Workload domains


## Installing the module
Tested in Windows PowerShell 5.x & PowerShell Core 6.x  
To install the module from the PowerShell Gallery Open PowerShell as Administrator and run the following

```powershell
Install-Module -Name PowerVCF
```

Alternatively to manually install the module download the full module zip from the GitHub repo, extract and run the following in PowerShell

```powershell
Import-Module .\PowerVCF
```

## Getting Started
All API operations must authenticated using the SDDC Manager admin@local account or a vSphere Single-Sign On user with ADMIN access to SDDC Manager.
To authenticate and request a token which is used for subsequent requests must first run:

```powershell
Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username admin@local -password VMw@re1!VMw@re1!
```

*Note: `-username` & `-password` are optional. If not passed a credential window will be presented.*

Authentication is only valid for the duration of the PowerShell session.


## Examples
### Get a list of VCF Hosts

`Get-VCFHost`
### Sample Output

```
id                  : c63899b9-22d2-4c7c-bb68-42bc2507b6ef
esxiVersion         : 7.0.2-17630552
fqdn                : sfo01-m01-esx01.sfo.rainpole.io
hardwareVendor      : Dell Inc.
hardwareModel       : PowerEdge R630
isPrimary           : False
ipAddresses         : {@{ipAddress=172.18.110.101; type=MANAGEMENT}, @{ipAddress=172.18.112.101; type=VSAN}, @{ipAddress=172.18.111.101; type=VMOTION}}
cpu                 : @{frequencyMHz=55999.953125; usedFrequencyMHz=1233.0; cores=28; cpuCores=System.Object[]}
memory              : @{totalCapacityMB=262048.28125; usedCapacityMB=57775.0}
storage             : @{totalCapacityMB=7325664.0; usedCapacityMB=301736.625; disks=System.Object[]}
physicalNics        : {@{deviceName=vmnic0; macAddress=24:6e:96:56:05:f8; speed=0}, @{deviceName=vmnic1; macAddress=24:6e:96:56:05:fa; speed=0}, @{deviceName=vmnic2; macAddress=24:6e:96:56:05:fc;
                      speed=0}, @{deviceName=vmnic3; macAddress=24:6e:96:56:05:fd; speed=0}}
domain              : @{id=20870784-3eb6-4708-bff9-f51ce487a922}
networkpool         : @{id=a58c7224-d42e-4a07-9ab8-14082b235eda; name=sfo-m01-np01}
cluster             : @{id=7269e189-6b91-41fd-b859-559d6df39a69}
status              : ASSIGNED
bundleRepoDatastore : lcm-bundle-repo
hybrid              : False
```


Responses can be filtered like this:

```powershell
Get-VCFHost -id c63899b9-22d2-4c7c-bb68-42bc2507b6ef | Select esxiVersion
```

```
esxiVersion
-----------
7.0.2-17630552
```


Or like this:

```powershell
$hostDetail = Get-VCFHost -id c63899b9-22d2-4c7c-bb68-42bc2507b6ef
$hostDetail.esxiVersion
```

```
7.0.2-17630552
```


## Get Help
For a full list of supported cmdlets run the following

```powershell
Get-Command -Module PowerVCF
```

All cmdlets support the following

```powershell
Get-Help cmdlet-name

Get-Help cmdlet-name -examples

Get-Help cmdlet-name -detailed

Get-Help cmdlet-name -full
```
