# Using the Module

All API operations with SDDC Manager must be authenticated.

To create a `base64` credential to authenticate each cmdlet you must first run the `Request-VCFToken` cmdlet.

This example shows how to connect to SDDC Manager to request API access and refresh tokens using the default `administrator@vsphere.local` vCenter Single Sign-On administrator account.

```powershell
Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username administrator@vsphere.local -password VMw@re1!
```

This example shows how to connect to SDDC Manager using the `admin@local` local administrator account.

```powershell
Request-VCFToken -fqdn sfo-vcf01.sfo.rainpole.io -username admin@local -password VMw@re1!VMw@re1!
```

???+ info

    Both `-username` and `-password` are optional parameters. If not passed, a credential window will be presented.

    Authentication is only valid for the duration of the PowerShell session or until the token expires.

## Run a Command

Now that you have authenticated to SDDC Manager, you can run any of the cmdlets in the module.

Let's start by getting a list of EXSi hosts managed by the connected SDDC Manager instance. We'll use the `Get-VCFHost` cmdlet.

```powershell
Get-VCFHost
```

Sample Output:

```powershell
id                  : 323cb515-fd80-4fef-b512-79c48e8aa0ee
esxiVersion         : 8.0.1-21360543
fqdn                : sfo01-w01-esx01.sfo.rainpole.io
hardwareVendor      : Dell
hardwareModel       : PowerEdge
isPrimary           : False
ipAddresses         : {@{ipAddress=172.16.31.104; type=MANAGEMENT}, 
                       @{ipAddress=172.16.33.101; type=VSAN},
                       @{ipAddress=172.16.32.101; type=VMOTION}}
cpu                 : @{frequencyMHz=15962.498046875; usedFrequencyMHz=92.0; cores=8; cpuCores=System.Object[]}
memory              : @{totalCapacityMB=32767.4296875; usedCapacityMB=1974.0}
storage             : @{totalCapacityMB=0.0; usedCapacityMB=0.0; disks=System.Object[]}
physicalNics        : {@{deviceName=vmnic0; macAddress=24:6e:96:56:10:50}, @{deviceName=vmnic1; macAddress=24:6e:96:56:10:52},
                      @{deviceName=vmnic2; macAddress=24:6e:96:56:10:54}, @{deviceName=vmnic3; macAddress=24:6e:96:56:10:55}}
networks            : {@{type=MANAGEMENT; vlanId=1631; mtu=1500}}
domain              : @{id=3914c2d5-49c0-4d91-b3a6-fec053648fcd}
networkpool         : @{id=225771d1-e2e4-4fe4-9944-4107073d6fe5; name=sfo-w01-np01}
cluster             : @{id=a092f6c7-4763-42c3-b327-4ede3be04ee2}
status              : ASSIGNED
bundleRepoDatastore : lcm-bundle-repo
hybrid              : False
```

You can also filter the output of the cmdlet.

### Example 1

```powershell
Get-VCFHost -id 323cb515-fd80-4fef-b512-79c48e8aa0ee | Select esxiVersion
```

```powershell
esxiVersion
-----------
8.0.1-21360543
```

### Example 2

```powershell
$hostDetail = Get-VCFHost -id 323cb515-fd80-4fef-b512-79c48e8aa0ee
$hostDetail.esxiVersion
```

```powershell
8.0.1-21360543
```

Explore the other cmdlets in the module to see what else you can do.
