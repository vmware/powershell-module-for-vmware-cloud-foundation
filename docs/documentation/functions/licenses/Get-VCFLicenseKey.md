# Get-VCFLicenseKey

## Synopsis

Retrieves license keys.

## Syntax

```powershell
Get-VCFLicenseKey [[-key] <String>] [[-productType] <String>] [[-status] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFLicenseKey` cmdlet retrieves license keys. You can filter the list by key, product type, and status.

## Examples

### Example 1

```powershell
Get-VCFLicenseKey
```

This example shows how to retrieve a list of all license keys.

### Example 2

```powershell
Get-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
```

This example shows how to retrieve a specific license key by key.

### Example 3

```powershell
Get-VCFLicenseKey -productType VCENTER
```

This example shows how to retrieve a license by product type.

### Example 4

```powershell
Get-VCFLicenseKey -status EXPIRED
```

This example shows how to retrieve a license by status.

## Parameters

### -key

Specifies the license key.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -productType

Specifies the product type. One of: SDDC_MANAGER, VCENTER, VSAN, ESXI, NSXT.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -status

Specifies the license status. One of: EXPIRED, ACTIVE, NEVER_EXPIRES.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
