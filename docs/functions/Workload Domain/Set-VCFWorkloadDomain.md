# New-VCFWorkloadDomain

## SYNOPSIS
    Connects to the specified SDDC Manager & marks a workload domain for deletion.

## Syntax
```
Set-VCFWorkloadDomain -id <string>
```

## DESCRIPTION
    Before a workload domain can be deleted it must first be marked for deletion.
	The Set-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager & marks a workload domain for deletion. 


## EXAMPLES

### EXAMPLE 1
```
Set-VCFWorkloadDomain -id fbdcf199-c086-43aa-9071-5d53b5c5b99d
    This example shows how to mark a workload domain for deletion
```

## PARAMETERS

### -id
- ID of a workload domain

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

## NOTES

## RELATED LINKS
