# Set-VCFCluster

## SYNOPSIS
    Connects to the specified SDDC Manager & expands or compacts a cluster.

## Syntax
```
Set-VCFCluster -id <string> -json <path to JSON file> -markForDeletion <boolean>
```

## DESCRIPTION
	The Set-VCFCluster cmdlet connects to the specified SDDC Manager & expands or compacts a cluster by adding or removing a host(s). A cluster can also be marked for deletion


## EXAMPLES

### EXAMPLE 1
```
Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 
	-json .\Cluster\clusterExpansionSpec.json
    This example shows how to expand a cluster by adding a host(s) 
```

### EXAMPLE 2
```
	Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 
	-json .\Cluster\clusterCompactionSpec.json
    This example shows how to compact a cluster by removing a host(s)
```	
### EXAMPLE 3
```
	Set-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1 
	-markForDeletion
    This example shows how to mark a cluster for deletion
```

## PARAMETERS

### -id
- ID of target cluster

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```
### -json
- Path to the JSON spec

```yaml
Type: JSON
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```
### -markForDeletion
- Flag a cluster for deletion

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```
## NOTES

## RELATED LINKS
