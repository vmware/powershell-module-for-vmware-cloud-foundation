# Get-VCFvCenter

## SYNOPSIS
    Gets a list of vCenter Servers

## Syntax
```
Get-VCFvCenter -id <string>
```

## DESCRIPTION
    Retrieves a list of vCenter Servers managed by the connected SDDC Manager

## EXAMPLES

### EXAMPLE 1
```
Get-VCFvCenter
    This example shows how to get the list of vCenter Servers managed by the connected SDDC Manager
```
### EXAMPLE 2
```
Get-VCFvCenter -id d189a789-dbf2-46c0-a2de-107cde9f7d24
    This example shows how to return the details for a specic vCenter Server managed by the connected SDDC Manager
```
### EXAMPLE 3
```
Get-VCFvCenter | select fqdn
    This example shows how to get the list of vCenter Servers managed by the connected SDDC Manager but only return the fqdn	
```

## PARAMETERS
### -id
- ID of a specific VCF vCenter

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
