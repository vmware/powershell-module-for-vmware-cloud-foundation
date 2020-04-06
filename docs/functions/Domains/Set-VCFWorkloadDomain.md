# Set-VCFWorkloadDomain

### Synopsis
Connects to the specified SDDC Manager and marks a workload domain for deletion.

### Syntax
```
Set-VCFWorkloadDomain -id <string>
```

### Description
Before a workload domain can be deleted it must first be marked for deletion.  
The Set-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager and marks a workload domain for deletion.  

### Examples
#### Example 1
```
Set-VCFWorkloadDomain -id fbdcf199-c086-43aa-9071-5d53b5c5b99d
```
This example shows how to mark a workload domain for deletion

### Parameters

#### -id
- ID of a workload domain

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
