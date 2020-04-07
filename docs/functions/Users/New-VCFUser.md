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
New-VCFUser -user vcf-admin@rainpole.io -role ADMIN
```
This example shows how to create a user with ADMIN role

### Parameters

#### -user
- Must be UPN format e.g. vcf-admin@rainpole.io or vcf-admin@vsphere.local

```yaml
Type: string
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -role
- Currently supported roles: ADMIN, OPERATOR

```yaml
Type: string
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Supported Value: ADMIN, OPERATOR
```


### Notes

### Related Links
