# Set-VCFvROPs

### Synopsis
Connect or disconnect Workload Domains to vRealize Operations Manager

### Syntax
```
Set-VCFvROPs
```

### Description
The Set-VCFvROPs cmdlet connects or disconnects Workload Domains to vRealize Operations Manager

### Examples
#### Example 1
```
Set-VCFvROPs -domainId <domain-id> -status ENABLED
        
```
This example connects a Workload Domain to vRealize Operations Manager

#### Example 2
```
Set-VCFvROPs -domainId <domain-id> -status DISABLED
```
This example disconnects a Workload Domain from vRealize Operations Manager

### Parameters
#### -domainId
- ID of the workload domain to connect or disconnect

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -status
- ENABLED or DISABLED

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
