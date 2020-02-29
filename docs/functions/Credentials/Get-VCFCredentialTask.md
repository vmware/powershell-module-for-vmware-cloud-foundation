# Get-VCFCredentialTask

### Synopsis
Connects to the specified SDDC Manager and retrieves a list of credential tasks in reverse chronological order.

### Syntax
```
Get-VCFCredentialTask -id <task id> -resourceCredentials
```

### Description
The Get-VCFCredentialTask cmdlet connects to the specified SDDC Manager and retrieves a list of credential tasks in reverse chronological order.

### Examples
#### Example 1
```
Get-VCFCredentialTask 
```
This example shows how to get a list of all credentials tasks

#### Example 2
```
Get-VCFCredentialTask -id 7534d35d-98fb-43de-bcf7-2776beb6fcc3
```
This example shows how to get the credential tasks for a specific task id

#### Example 3
```
Get-VCFCredentialTask -id 7534d35d-98fb-43de-bcf7-2776beb6fcc3 -resourceCredentials
```
This example shows how to get resource credentials for a credential task id

### Parameters

#### -id
- Task id

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

#### -resourceCredentials
- No value required

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

