# Stop-VCFCredentialTask

### Synopsis
Connects to the specified SDDC Manager and cancels a failed update or rotate passwords task

### Syntax
```
Stop-VCFCredentialTask -id <string>
```

### Description
The Stop-VCFCredentialTask cmdlet connects to the specified SDDC Manager and cancles a failed update or rotate passwords task.

### Examples
#### Example 1
```
Stop-VCFCredentialTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d
```
This example shows how to cancel a failed rotate or update password task

### Parameters

#### -id
ID of a specific workload domain

```yaml
Type: String
Parameter Sets: Username
Aliases:

Required: False
Position: Named
Default value: None
```

### Notes

### Related Links
