# Remove-VCFCluster

## SYNOPSIS
    Connects to the specified SDDC Manager & deletes a cluster.

## Syntax
```
Remove-VCFCluster -id <string>
```

## DESCRIPTION
    Before a cluster can be deleted it must first be marked for deletion. See Set-VCFCluster
	The Remove-VCFCluster cmdlet connects to the specified SDDC Manager & deletes a cluster. 


## EXAMPLES

### EXAMPLE 1
```
Remove-VCFCluster -id a511b625-8eb8-417e-85f0-5b47ebb4c0f1
    This example shows how to delete a cluster
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
## NOTES

## RELATED LINKS
