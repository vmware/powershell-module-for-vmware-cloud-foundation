# Get-VCFCluster

## SYNOPSIS
    Connects to the specified SDDC Manager & retrieves a list of clusters.

## Syntax
```
Get-VCFWorkloadDomain -name <string> -id <string>
```

## DESCRIPTION
    The Get-VCFCluster cmdlet connects to the specified SDDC Manager & retrieves a list of clusters.

## EXAMPLES

### EXAMPLE 1
```
Get-VCFCluster
    This example shows how to get a list of all clusters
```

### EXAMPLE 2
```
Get-VCFCluster -name wld01-cl01
    This example shows how to get a cluster by name
```

### EXAMPLE 3
```
Get-VCFCluster -id 8423f92e-e4b9-46e7-92f7-befce4755ba2
    This example shows how to get a cluster by id
```

## PARAMETERS

### -name
- The friendly name of a cluster

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

### -id
ID of a specific cluster

```yaml
Type: String
Parameter Sets: Username
Aliases:

Required: False
Position: Named
Default value: None
```

## NOTES

## RELATED LINKS
