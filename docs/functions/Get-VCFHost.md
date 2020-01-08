# Get-VCFHost

## SYNOPSIS
Connects to the specified SDDC Manager & retrieves a list of hosts.

## DESCRIPTION
The Get-VCFHost cmdlet connects to the specified SDDC Manager & retrieves a list of hosts.  
- VCF Hosts are defined by status
	- ASSIGNED - Hosts that are assigned to a Workload domain
	- UNASSIGNED_USEABLE - Hosts that are availbale to be assigned to a Workload Domain
	- UNASSIGNED_UNUSEABLE - Hosts that are currently not assigned to any domain and can be used 
	for other domain tasks after completion of cleanup operation

## EXAMPLES

### EXAMPLE 1
```
Get-VCFHost
    This example shows how to get all hosts regardless of status
```

### EXAMPLE 2
```
Get-VCFHost -Status ASSIGNED
    This example shows how to get all hosts with a specific status
```

### EXAMPLE 3
```
Get-VCFHost -id edc4f372-aab5-4906-b6d8-9b96d3113304
    This example shows how to get a host by id
```

### EXAMPLE 4
```
Get-VCFHost -fqdn sfo01m01esx01.sfo01.rainpole.local
    This example shows how to get a host by fqdn
```


## PARAMETERS

### -Status
- VCF Hosts are defined by status
	- ASSIGNED - Hosts that are assigned to a Workload domain
	- UNASSIGNED_USEABLE - Hosts that are availbale to be assigned to a Workload Domain
	- UNASSIGNED_UNUSEABLE - Hosts that are currently not assigned to any domain and can be used 
	for other domain tasks after completion of cleanup operation

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
ID of a specific host

```yaml
Type: String
Parameter Sets: Username
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -fqdn
FQDN of a specific host

```yaml
Type: SecureString
Parameter Sets: Password
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## NOTES

## RELATED LINKS
