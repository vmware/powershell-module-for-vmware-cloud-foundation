# PowerVCF
PowerVCF is a PowerShell Module for interacting with the VMware Cloud Foundation (SDDC Manager) public API.

<a href="https://docs.vmware.com/en/VMware-Cloud-Foundation" target="_blank">VMware Cloud Foundation Product Documentation</a>

<a href="https://code.vmware.com/apis/723/vmware-cloud-foundation" target="_blank">VMware Cloud Foundation API Documentation</a>

# Disclaimer
This is not an officially supported VMware PowerShell Module. It was initially developed and maintained by Brian O'Connell who is a Staff Architect in the VMware HCI Business Unit (HCIBU).

The purpose of this module is to make VMware Cloud Foundation API more accessible to fans of PowerCli and drive adoption of the VMware Cloud Foundation API & VMware Cloud Foundation in general. It is provided without warranty and should not be used in a production environment without thoroughly testing first. It has been developed against VMware Cloud Foundation 3.9 and best efforts will be made to validate all cmdlets against future VMware Cloud Foundation versions but no promises!

## Contributors
If you would like to contribute please get in touch! Current contributors listed below.

Brian O'Connell - VMware HCI BU Staff Architect \[[Twitter](https://twitter.com/LifeOfBrianOC)\] \[[Blog](https://LifeOfBrianOC.com)\]

Gary Blake - VMware HCI BU Staff II Architect \[[Twitter](https://twitter.com/GaryJBlake)\] \[[Blog](https://my-cloudy-world.com/)\]

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
All API operations must currently be authenticated using the SDDC Manager admin account.
To create a base64 credential to authenticate each cmdlet you must first run:

```powershell
Connect-VCFManager -fqdn sfo-vcf01.sfo.rainpole.io -username admin -password VMware1!
```

*Note: `-username` & `-password` are optional. If not passed a credential window will be presented.*

Authentication is only valid for the duration of the PowerShell session.

Managing Credentials (password retrieval/update/rotation) requires dual authentication using a privileged username & password. See here for setup instructions: https://docs.vmware.com/en/VMware-Cloud-Foundation/3.9/com.vmware.vcf.admin.doc_39/GUID-FAB78718-E626-4924-85DC-97536C3DA337.html

## Examples
### Get a list of VCF Hosts

`Get-VCFHost`
### Sample Output

```
id             : 3fc04947-64c9-4402-8970-be93169140c6
esxiVersion    : 6.7.0-13981272
fqdn           : sfo01-m01-esx01.sfo.rainpole.io
hardwareVendor : Dell Inc.
hardwareModel  : PowerEdge R640
ipAddresses    : {@{ipAddress=172.16.225.101; type=MANAGEMENT}, @{ipAddress=172.16.230.101; type=VSAN},
                 @{ipAddress=172.16.226.101; type=VMOTION}}
cpu            : @{frequencyMHz=61455.61328125; cores=28; cpuCores=System.Object[]}
memory         : @{totalCapacityMB=261761.34375}
storage        : @{totalCapacityMB=10988496; disks=System.Object[]}
domain         : @{id=fbdcf199-c086-43aa-9071-5d53b5c5b99d}
cluster        : @{id=a511b625-8eb8-417e-85f0-5b47ebb4c0f1}
status         : ASSIGNED
```


Responses can be filtered like this:

```powershell
Get-VCFHost -id 3fc04947-64c9-4402-8970-be93169140c6 | Select esxiVersion
```

```
esxiVersion
-----------
6.7.0-13981272
```


Or like this:

```powershell
$hostDetail = Get-VCFHost -id edc4f372-aab5-4906-b6d8-9b96d3113304
$hostDetail.esxiVersion
```

```
6.7.0-13981272
```


## Get Help
For a full list of supported cmdlets run the following

```powershell
Get-Command -Module powerVCF
```

All cmdlets support the following

```powershell
Get-Help cmdlet-name

Get-Help cmdlet-name -examples

Get-Help cmdlet-name -detailed

Get-Help cmdlet-name -full
```
