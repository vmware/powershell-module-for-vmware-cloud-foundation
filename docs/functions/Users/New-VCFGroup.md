# New-VCFGroup

### Synopsis
Connects to the specified SDDC Manager and adds a new group

### Syntax
```
New-VCFGroup -group <string> -domain <string> -role <string>
```

### Description
The New-VCFGroup cmdlet connects to the specified SDDC Manager and adds a new group with a specified role

### Examples
#### Example 1
```
New-VCFGroup -group ug-vcf-group -domain rainpole.io -role ADMIN
```
This example shows how to add a new group with a specified role

### Parameters

#### -group
- Name of group to be added

```yaml
Type: string
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

#### -domain
- Name of domain for the group

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
