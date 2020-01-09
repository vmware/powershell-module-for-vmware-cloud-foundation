# Get-VCFNetworkPool

## SYNOPSIS
    Connects to the specified SDDC Manager & retrieves a list of Network Pools.

## Syntax
```
Get-VCFNetworkPool -name <string> -id <string>
```

## DESCRIPTION
    The Get-VCFNetworkPool cmdlet connects to the specified SDDC Manager & retrieves a list of Network Pools. 


## EXAMPLES

### EXAMPLE 1
```
Get-VCFNetworkPool
    This example shows how to get a list of all Network Pools
```
### EXAMPLE 2
```
Get-VCFNetworkPool -name sfo01-networkpool
    This example shows how to get a Network Pool by name
```
### EXAMPLE 3
```
Get-VCFNetworkPool -id 40b0b36d-36d6-454c-814b-ba8bf9b383e3
    This example shows how to get a Network Pool by id
```
## PARAMETERS

### -name
- ID of target cluster

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```
### -id
- ID of target cluster

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
