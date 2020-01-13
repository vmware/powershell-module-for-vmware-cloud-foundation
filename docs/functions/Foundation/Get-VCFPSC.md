# Get-VCFPSC

### Synopsis
Gets a list of Platform Services Controller (PSC) Servers

### Syntax
```
Get-VCFPSC -id <string>
```

### Description
Retrieves a list of Platform Services Controllers (PSC)s managed by the connected SDDC Manager

### Examples
#### Example 1
```
Get-VCFPSC
```
This example shows how to get the list of the PSC servers managed by the connected SDDC Manager

#### Example 2
```
Get-VCFPSC -id 23832dec-e156-4d2d-89bf-37fb0a47aab5
```
This example shows how to return the details for a specific PSC servers managed by the connected SDDC Manager

#### Example 3
```
Get-VCFPSC | select fqdn
```
This example shows how to get the list of PSC Servers managed by the connected SDDC Manager but only return the fqdn

### Parameters

#### -id
- ID of a specific VCF PSC

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
