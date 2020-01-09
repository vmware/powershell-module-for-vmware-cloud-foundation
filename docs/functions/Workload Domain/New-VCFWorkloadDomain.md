# New-VCFWorkloadDomain

## SYNOPSIS
    Connects to the specified SDDC Manager & creates a workload domain.

## Syntax
```
New-VCFWorkloadDomain -json <path to json file>
```

## DESCRIPTION
    The New-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager 
	& creates a workload domain. 


## EXAMPLES

### EXAMPLE 1
```
New-VCFWorkloadDomain -json .\WorkloadDomain\workloadDomainSpec.json
    This example shows how to create a Workload Domain from a json spec
```

## PARAMETERS

### -json
- Path to the JSON spec

```yaml
Type: JSON
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

## NOTES

## RELATED LINKS
