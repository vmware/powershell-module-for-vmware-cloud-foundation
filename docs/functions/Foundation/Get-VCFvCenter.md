# Get-VCFvCenter

### Synopsis
Gets a list of vCenter Servers

### Syntax
```
Get-VCFvCenter -id <string>
```

### Description
Retrieves a list of vCenter Servers managed by the connected SDDC Manager

### Examples
#### Example 1
```
Get-VCFvCenter
```
This example shows how to get the list of vCenter Servers managed by the connected SDDC Manager

#### Example 2
```
Get-VCFvCenter -id d189a789-dbf2-46c0-a2de-107cde9f7d24
```
This example shows how to return the details for a specific vCenter Server managed by the connected SDDC Manager using its id

#### Example 3
```
Get-VCFvCenter -domain 1a6291f2-ed54-4088-910f-ead57b9f9902
```
This example shows how to return the details off all vCenter Server managed by the connected SDDC Manager using its domainId

#### Example 4
```
Get-VCFvCenter | select fqdn
```
This example shows how to get the list of vCenter Servers managed by the connected SDDC Manager but only return the fqdn

### Parameters

#### -id
- ID of a specific VCF vCenter

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

#### -domainId
- ID of a specific domain

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
