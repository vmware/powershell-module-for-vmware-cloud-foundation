# New-VCFWorkloadDomain

### Synopsis
Connects to the specified SDDC Manager and creates a workload domain.

### Syntax
```
New-VCFWorkloadDomain -json <path to json file>
```

### Description
The New-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager and creates a workload domain.

### Examples
#### Example 1
```
New-VCFWorkloadDomain -json .\WorkloadDomain\workloadDomainSpec.json
```
This example shows how to create a Workload Domain from a json spec

### Parameters

#### -json
- Path to the JSON spec

```yaml
Type: JSON
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

### Notes

### Related Links
