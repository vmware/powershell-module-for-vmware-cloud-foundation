# Documentation

All API operations with SDDC Manager must be authenticated.

To create a `base64` credential to authenticate each cmdlet you must first run the [`Request-VCFToken`](functions/authentication/Request-VCFToken.md) cmdlet.

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

Let's start by getting a list of EXSi hosts managed by the connected SDDC Manager instance. We'll use the [`Get-VCFHost`](functions/hosts/Get-VCFHost.md) cmdlet.

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

### Example 1

```powershell
Get-VCFHost -id 598519e7-cbba-4a10-801d-d76111f3ce0e | Select esxiVersion
```

```powershell
esxiVersion
-----------
7.0.2-17867351
```

### Example 2

```powershell
$hostDetail = Get-VCFHost -id 598519e7-cbba-4a10-801d-d76111f3ce0e
$hostDetail.esxiVersion
```

```powershell
7.0.2-17867351
```

Explore the other cmdlets in the module to see what else you can do.
