# New-VCFCluster

## SYNOPSIS
    Connects to the specified SDDC Manager & creates cluster.

## Syntax
```
New-VCFWorkloadDomain -json <path to json file>
```

## DESCRIPTION
    The New-VCFCluster cmdlet connects to the specified SDDC Manager & creates a cluster in a specified workload domains. 


## EXAMPLES

### EXAMPLE 1
```
New-VCFCluster -json .\WorkloadDomain\addClusterSpec.json
    This example shows how to create a cluster in a Workload Domain from a json spec
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
