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

- To return the apikey for a specific user you can do the following
```yaml
Get-VCFUser | Where-object {$_.name -eq 'svc-vrops-vra@rainpole.io'} | Select-Object -ExpandProperty apikey
```
### Related Links
