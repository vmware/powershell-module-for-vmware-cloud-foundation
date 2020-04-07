# New-VCFServiceUser

### Synopsis
Connects to the specified SDDC Manager and adds a new service user.

### Syntax
```
New-VCFServiceUser -user <String> -role <string>
```

### Description
The New-VCFServiceUser cmdlet connects to the specified SDDC Manager and adds a new service user.

### Examples
#### Example 1
```
New-VCFServiceUser -user sec-admin@rainpole.io -role ADMIN
```
This example shows how to create a cluster in a Workload Domain from a json spec

### Parameters

#### -user
- Must be a string. Can be UPN or local user

#### -role
- Currently supported roles: ADMIN, OPERATOR

```yaml
Type: JSON
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

```

### Notes

### Related Links
