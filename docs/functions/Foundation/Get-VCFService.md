# Get-VCFService

### Synopsis
Gets a list of running VCF Services

### Syntax
```
Get-VCFService -id <string>
```

### Description
The Get-VCFService cmdlet retrieves the list of services running on the connected SDDC Manager

### Examples
#### Example 1
```
Get-VCFService
```
This example shows how to get the list of services running on the connected SDDC Manager

#### Example 2
```
Get-VCFService -id 4e416419-fb82-409c-ae37-32a60ba2cf88
```
This example shows how to return the details for a specific service running on the connected SDDC Manager based on the ID

### Parameters

#### -id
- ID of a specific SDDC Manager Service

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

### Notes

### Related Links
