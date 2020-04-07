# New-VCFUser

### Synopsis
Connects to the specified SDDC Manager and adds a new user.

### Syntax
```
New-VCFUser -user <UPN String> -role <string>
```

### Description
The New-VCFUser cmdlet connects to the specified SDDC Manager and adds a new user.

### Examples
#### Example 1
```
New-VCFUser -user sec-admin@rainpole.io -role ADMIN
```
This example shows how to create a cluster in a Workload Domain from a json spec

### Parameters

#### -user
- Must be UPN format e.g. sec-admin@rainpole.io or sec-admin@vsphere.local

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
