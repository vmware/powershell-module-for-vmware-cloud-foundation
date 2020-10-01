# Set-VCFvRLI

### Synopsis
Connect or disconnect Workload Domains to vRealize Log Insight

### Syntax
```
Set-VCFvRLI
```

### Description
The Set-VCFvRLI cmdlet connects or disconnects Workload Domains to vRealize Log Insight

### Examples
#### Example 1
```
Set-VCFvRLI -domainId <domain-id> -status ENABLED
        
```
This example connects a Workload Domain to vRealize Log Insight

#### Example 2
```
Set-VCFvRLI -domainId <domain-id> -status DISABLED
```
This example disconnects a Workload Domain from vRealize Log Insight

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
Accepted value: ENABLED, DISABLED
```


### Notes

### Related Links
