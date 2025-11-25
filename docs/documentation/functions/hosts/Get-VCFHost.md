# Get-VCFHost

## Synopsis

Retrieves a list of ESXi hosts.

## Syntax

### Default (Default)

```powershell
Get-VCFHost [<CommonParameters>]
```

### fqdn

```powershell
Get-VCFHost [-fqdn <String>] [<CommonParameters>]
```

### status

```powershell
Get-VCFHost [-Status <String>] [<CommonParameters>]
```

### id

```powershell
Get-VCFHost [-id <String>] [<CommonParameters>]
```

## Description

The `Get-VCFHost` cmdlet retrieves a list of ESXi hosts. You can retrieve the hosts by unique ID, status, or FQDN.

- ASSIGNED: Hosts that are assigned to a workload domain.
- UNASSIGNED_USEABLE: Hosts that are available to be assigned to a workload domain.
- UNASSIGNED_UNUSEABLE: Hosts that are currently not assigned to any domain and are not available to be assigned to a workload domain.

## Examples

### Example 1

```powershell
Get-VCFHost
```

This example shows how to retrieve all ESXi hosts, regardless of status.

### Example 2

```powershell
Get-VCFHost -status ASSIGNED
```

This example shows how to retrieve all ESXi hosts with a specific status.

### Example 3

```powershell
Get-VCFHost -id edc4f372-aab5-4906-b6d8-9b96d3113304
```

This example shows how to retrieve an ESXi host by unique ID.

### Example 4

```powershell
Get-VCFHost -fqdn sfo01-m01-esx01.sfo.rainpole.io
```

This example shows how to retrieve an ESXi host by FQDN.

## Parameters

### -fqdn

Specifies the fully qualified domain name (FQDN) of the ESXi host.

```yaml
Type: String
Parameter Sets: fqdn
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -status

Specifies the status of the ESXi host. One of: ASSIGNED, UNASSIGNED_USEABLE, UNASSIGNED_UNUSEABLE.

```yaml
Type: String
Parameter Sets: status
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id

Specifies the unique ID of the ESXi host.

```yaml
Type: String
Parameter Sets: id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
