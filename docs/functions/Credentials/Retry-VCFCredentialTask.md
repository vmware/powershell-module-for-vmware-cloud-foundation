# Retry-VCFCredentialTask

### Synopsis
Connects to the specified SDDC Manager and retry a failed rotate/update passwords task

### Syntax
```
Cancel-VCFCredentialTask -id <string> -json <json file>
```

### Description
The Retry-VCFCredentialTask cmdlet connects to the specified SDDC Manager and retry a failed rotate/update password task

### Examples
#### Example 1
```
Retry-VCFCredentialTask -id 4d661acc-2be6-491d-9256-ba3c78020e5d -json .\Credential\updateCredentialSpec.json
```
This example shows how to update passwords of a resource type using a json spec

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

#### -json
Path to the json spec

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
