# New-VCFLicenseKey

## Synopsis

Adds a license key.

## Syntax

```powershell
New-VCFLicenseKey [-key] <String> [-productType] <String> [-description] <String> [<CommonParameters>]
```

## Description

The `New-VCFLicenseKey` cmdlet adds a new license key to SDDC Manager.

## Examples

### Example 1

```powershell
New-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA" -productType VCENTER -description "vCenter Server License"
```

This example shows how to add a license key to SDDC Manager.

## Parameters

### -key

Specifies the license key to add.

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

### -productType

Specifies the product type for the license key. One of: SDDC_MANAGER, VCENTER, VSAN, ESXI, NSXT, WCP.

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

### -description

Specifies the description for the license key.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
