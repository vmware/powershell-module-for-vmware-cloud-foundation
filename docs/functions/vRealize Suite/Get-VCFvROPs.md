# Get-VCFvROPs

## SYNOPSIS
    Get the existing vRealize Operations Manager

## Syntax
```
Get-VCFvROPs -getIntegratedDomains -nodes
```

## DESCRIPTION
    Gets the complete information about the existing vRealize Operations Manager.

## EXAMPLES

### EXAMPLE 1
```
Get-VCFvROPs
    This example list all details concerning the vRealize Operations Manager
```

### EXAMPLE 2
```
Get-VCFvROPs -getIntegratedDomains
    Retrieves all the existing workload domains and their connection status with vRealize Operations.
```

### EXAMPLE 3
```
Get-VCFvROPs -nodes
    Retrieves all the vRealize Operations Manager nodes.
```


## PARAMETERS
### -getIntegratedDomains
- Get Workload domains that are integrated with vRealize Operations Manager. No value required

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

### -nodes
- Get vRealize Operations Manager nodes. No value required

```yaml
Type: SwitchParameter
Parameter Sets: Username
Aliases:

Required: False
Position: Named
Default value: None
```
## NOTES

## RELATED LINKS
