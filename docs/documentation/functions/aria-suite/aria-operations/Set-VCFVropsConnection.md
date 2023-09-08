# Set-VCFVropsConnection

## Alias

`Set-VCFAriaOperationsConnection`

## Synopsis

Connects or disconnects workload domains to Aria Operations.

## Syntax

```powershell
Set-VCFVropsConnection [-domainId] <String> [-status] <String> [<CommonParameters>]
```

## Description

The `Set-VCFVrops` cmdlet connects or disconnects workload domains to Aria Operations.

## Examples

### Example 1

```powershell
Set-VCFVrops -domainId 44d23b12-76b6-4453-95f6-1dcaa837081f -status ENABLED
```

This example shows how to connect a workload domain to Aria Operations.

### Example 2

```powershell
Set-VCFVrops -domainId 44d23b12-76b6-4453-95f6-1dcaa837081f -status DISABLED
```

This example shows how to disconnect a workload domain from Aria Operations.

## Parameters

### -domainId

Specifies the unique ID of the workload domain.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -status

Specifies the status. One of: ENABLED, DISABLED.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
