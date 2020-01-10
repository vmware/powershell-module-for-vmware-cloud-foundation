# Get-VCFPSC

## SYNOPSIS
    Gets a list of Platform Services Controller (PSC) Servers

## Syntax
```
Get-VCFPSC -id <string>
```

## DESCRIPTION
    Retrieves a list of PSC managed by the connected SDDC Manager

## EXAMPLES

### EXAMPLE 1
```
Get-VCFPSC
    This example shows how to get the list of the PSC servers managed by the connected SDDC Manager
```
### EXAMPLE 2
```
Get-VCFPSC -id 23832dec-e156-4d2d-89bf-37fb0a47aab5
    This example shows how to return the details for a specic PSC servers managed by the connected SDDC Manager
```
### EXAMPLE 3
```
Get-VCFPSC | select fqdn
    This example shows how to get the list of PSC Servers managed by the connected SDDC Manager but only return the fqdn	
```

## PARAMETERS
### -id
- ID of a specific VCF PSC

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```
## NOTES

## RELATED LINKS
