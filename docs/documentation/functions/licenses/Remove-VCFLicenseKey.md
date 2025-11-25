# Remove-VCFLicenseKey

## Synopsis

Removes a license key.

## Syntax

```powershell
Remove-VCFLicenseKey [-key] <String> [<CommonParameters>]
```

## Description

The `Remove-VCFLicenseKey` cmdlet removes a license key from SDDC Manager.

???+ info

    A license key can only be removed if the key is not in use.

## Examples

### Example 1

```powershell
Remove-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
```

This example shows how to remove a license key.

## Parameters

### -key

Specifies the license key to remove.

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
