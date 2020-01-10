# Get-VCFWorkloadDomain

## SYNOPSIS
Connects to the specified SDDC Manager & retrieves a list of workload domains.

## Syntax
```
Get-VCFWorkloadDomain -name <string> -id <string>
```

## DESCRIPTION
The Get-VCFWorkloadDomain cmdlet connects to the specified SDDC Manager & retrieves a list of workload domains.

## EXAMPLES

### EXAMPLE 1
```
Get-VCFWorkloadDomain
    This example shows how to get a list of Workload Domains
```

### EXAMPLE 2
```
Get-VCFWorkloadDomain -name WLD01
    This example shows how to get a Workload Domain by name
```

### EXAMPLE 3
```
Get-VCFWorkloadDomain -id 8423f92e-e4b9-46e7-92f7-befce4755ba2
    This example shows how to get a Workload Domain by id
```

## PARAMETERS

### -name
- The friendly name of a workload domain

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

### -id
ID of a specific workload domain

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
