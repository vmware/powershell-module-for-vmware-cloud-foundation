# Get-VCFPsc

### Synopsis
Gets a list of Platform Services Controller (PSC) Servers

### Syntax
```
Get-VCFPSC -id <string>
```

### Description
The Get-VCFPsc cmdlet retrieves a list of Platform Services Controllers (PSC)s managed by the connected SDDC Manager

### Examples
#### Example 1
```
Get-VCFPsc
```
This example shows how to get the list of the PSC servers managed by the connected SDDC Manager

#### Example 2
```
Get-VCFPsc -id 23832dec-e156-4d2d-89bf-37fb0a47aab5
```
This example shows how to return the details for a specific PSC server managed by the connected SDDC Manager using its id

#### Example 3
```
Get-VCFPsc -domainId 1a6291f2-ed54-4088-910f-ead57b9f9902
```
This example shows how to return the details for all PSC servers managed by the connected SDDC Manager using the domain ID

#### Example 4
```
Get-VCFPsc | select fqdn
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
