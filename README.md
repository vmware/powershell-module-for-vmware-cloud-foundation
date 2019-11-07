# PowerVCF
PowerVCF is a PowerShell Module for interacting the VMware Cloud Foundation (SDDC Manager) public API.
More info on the API can be found here https://code.vmware.com/apis/723/vmware-cloud-foundation

# Disclaimer
This is not an officially supported VMware PowerShell Module. It is developed and maintained by Brian O'Connell who is a Staff Architect in the VMware HCI Business Unit (HCIBU). The purpose of this module is to make VMware Cloud Foundation API more accessible to fans of PowerCli and drive adoption of the VCF API & VCF in general. It is provided without warranty and should not be used in a production environment without thouroughly testing first. It has been developed against VMware Cloud Foundation 3.8 and best efforts will be made to validate all cmdlets against future VMware Cloud Foundation versions but no promises!


## Installing the module
Tested in Windows PowerShell 5.x & PowerShell Core 6.x
To install the module download the full module zip, extract and run the following in PowerShell

`Import-Module .\PowerVCF`

## Getting Started
All API operations must currently be authenticated using the SDDC Manager admin account. 
To create a base64 credential to authenticate each cmdlet you must first run:

`Connect-VCFSDDCManager -fqdn sddc-manager.sfo01.rainpole.local -username admin -password VMware1!`
 
Note: -username & -password are optional. If not passed a credential window will be presented.

Once the authentication is complete it will be valid for the duration of the PowerShell session only.

## Examples
### Get a list of VCF Hosts

`Get-VCFHost`
### Sample Output

```
id             : 3fc04947-64c9-4402-8970-be93169140c6
esxiVersion    : 6.7.0-13981272
fqdn           : sfo01m01esx01.sfo01.rainpole.local
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

`Get-VCFHost -id 3fc04947-64c9-4402-8970-be93169140c6 | Select esxiVersion`

```
esxiVersion
-----------
6.7.0-13981272
```


Or like this:

```
$hostDetail = Get-VCFHost -id edc4f372-aab5-4906-b6d8-9b96d3113304
$hostDetail.esxiVersion
6.7.0-13981272
```


## Get Help
For a full list of supported cmdlets run the following

`Get-Command -Module powerVCF`

All cmdlets support the following

```
get-help cmdlet-name

get-help cmdlet-name -examples

get-help cmdlet-name -detailed

get-help cmdlet-name -full
```


