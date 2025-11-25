# Request-VCFHealthSummaryBundle

## Synopsis

Downloads the Health Summary bundle.

## Syntax

```powershell
Request-VCFHealthSummaryBundle [-id] <String> [<CommonParameters>]
```

## Description

The `Request-VCFHealthSummaryBundle` cmdlet downloads the Health Summary bundle.

## Examples

### Example 1

```powershell
Request-VCFHealthSummaryBundle -id 12345678-1234-1234-1234-123456789012
```

This example shows how to download a Health Summary bundle.

## Parameters

### -id

Specifies the unique ID of the Health Summary task.

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
