# Remove-VCFNetworkPool

## Synopsis

Removes a network pool.

## Syntax

```powershell
Remove-VCFNetworkPool [-id] <String> [<CommonParameters>]
```

## Description

The `Remove-VCFNetworkPool` cmdlet removes a network pool.

## Examples

### Example 1

```powershell
Remove-VCFNetworkPool -id 7ee7c7d2-5251-4bc9-9f91-4ee8d911511f
```

This example shows how to remove a network pool by unique ID.

## Parameters

### -id

Specifies the unique ID of the network pool.

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
