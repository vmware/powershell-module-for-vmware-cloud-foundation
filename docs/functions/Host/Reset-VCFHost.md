# Reset-VCFHost

### Synopsis
Performs an ESXi host cleanup using the command line SoS utility

### Description
Performs a host cleanup using SoS option --cleanup-host. Valid options for the -dirtyHost parameter are: ALL, <MGMT ESXi IP>
Please note:The SoS utility on VCF 3.9 is unable to perform networking host cleanup when the host belongs to an NSX-T cluster. This issue has been resolved on VCF 3.9.1

### Examples
#### Example 1
```
Reset-VCFHost -privilegedUsername super-vcf@vsphere.local -privilegedPassword "VMware1!" -sddcManagerRootPassword "VMware1!"-dirtyHost 192.168.210.53
```
This command will perform SoS host cleanup for host 192.168.210.53

#### Example 2
```
Reset-VCFHost -privilegedUsername super-vcf@vsphere.local -privilegedPassword "VMware1!" -sddcManagerRootPassword "VMware1!" -dirtyHost all
```
This command will perform SoS host cleanup for all hosts in need of cleanup in the SDDC Manager database.

### Parameters

#### -privilegedUsername
Privileged Username for dual authentication

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

#### -privilegedPassword
Privileged Password for dual authentication

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

#### -sddcManagerRootPassword
SDDC Manager root password, this is required to run sudo elevated commands

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -dirtyHost
The ESXi management IP address of the host to clean or use ALL to execute the cleanup of all the dirty hosts

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

### Notes

### Related Links
