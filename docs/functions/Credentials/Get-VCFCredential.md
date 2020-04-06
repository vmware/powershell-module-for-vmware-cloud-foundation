# Get-VCFCredential

### Synopsis
Connects to the specified SDDC Manager & retrieves a list of credentials.

### Syntax
```
Get-VCFCredential -resourceName <string> -resourceType <string> -id <string>
```

### Description
The Get-VCFCredential cmdlet connects to the specified SDDC Manager and retrieves a list of credentials. You must have ADMIN role assigned.


### Examples
#### Example 1
```
Get-VCFCredential
```
This example shows how to get a list of credentials

#### Example 2
```
Get-VCFCredential -resourceType VCENTER
```
This example shows how to get a list of VCENTER credentials

#### Example 3
```
Get-VCFCredential -resourceName sfo01-m01-esx01.sfo.rainpole.io
```
This example shows how to get the credential for a specific resourceName (FQDN)

#### Example 4
```
Get-VCFCredential -id 3c4acbd6-34e5-4281-ad19-a49cb7a5a275
```
This example shows how to get the credential using the id

### Parameters

#### -resourceType
- Specify the type of resource

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accepted Value: VCENTER, ESXI, NSXT_MANAGER, NSXT_EDGE, BACKUP
```

#### -resourceName
- Specific target resource to get credentials for

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accepted Value: Resource FQDN
```

#### -id
ID of a credential

```yaml
Type: String
Parameter Sets: Username
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Notes

### Related Links

