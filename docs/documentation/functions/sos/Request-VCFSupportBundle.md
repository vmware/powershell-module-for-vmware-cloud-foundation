# Request-VCFSupportBundle

## Synopsis

Downloads the support bundle.

## Syntax

```powershell
Request-VCFSupportBundle [-id] <String> [<CommonParameters>]
```

## Description

The `Request-VCFSupportBundle` cmdlet downloads the support bundle.

## Examples

### Example 1

```powershell
Request-VCFSupportBundle -id 12345678-1234-1234-1234-123456789012
```

This example shows how to download the support bundle by unique ID.

## Parameters

### -id

Specifies the unique ID of the support bundle task.

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
