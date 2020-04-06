# Remove-VCFWorkloadDomain

### Synopsis
Connects to the specified SDDC Manager and deletes a workload domain.

### Syntax
```
Remove-VCFWorkloadDomain -id <string>
```

### Description
Before a workload domain can be deleted it must first be marked for deletion (See Set-VCFWorkloadDomain).  
The Remove-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager and deletes a workload domain.  

### Examples
#### Example 1
```
Remove-VCFWorkloadDomain -id fbdcf199-c086-43aa-9071-5d53b5c5b99d
```
This example shows how to delete a workload domain

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
