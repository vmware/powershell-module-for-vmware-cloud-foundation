# Set-VCFCeip

## Synopsis

Sets the Customer Experience Improvement Program (CEIP) status for SDDC Manager, vCenter Server, vSAN, and NSX.

## Syntax

```powershell
Set-VCFCeip [-ceipSetting] <String> [<CommonParameters>]
```

## Description

The Set-VCFCeip cmdlet configures the status for the Customer Experience Improvement Program (CEIP) for SDDC Manager, vCenter Server, vSAN, and NSX.

## Examples

### Example 1

```powershell
Set-VCFCeip -ceipSetting DISABLE
```

This example shows how to disable the Customer Experience Improvement Program for SDDC Manager, vCenter Server, vSAN, and NSX.

### Example 2

```powershell
Set-VCFCeip -ceipSetting ENABLE
```

This example shows how to enable the Customer Experience Improvement Program for SDDC Manager, vCenter Server, vSAN, and NSX.

## Parameters

### -ceipSetting

Specifies the configuration of the Customer Experience Improvement Program. One of: ENABLE, DISABLE.

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
