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
New-VCFServiceUser -user svc-user@rainpole.io -role ADMIN
```
This example shows how to create a user with ADMIN role

### Parameters

#### -user
- Can be UPN or local account

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

- To return the apikey for a specific SERVICE user you can do the following
- apikey is only valid for Service users
```yaml
Get-VCFUser | Where-object {$_.name -eq 'svc-user@rainpole.io'} | Select-Object -ExpandProperty apikey
```
### Related Links
