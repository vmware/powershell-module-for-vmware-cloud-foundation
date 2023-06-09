# New-VCFvRSLCM

## Synopsis

Deploys VMware Aria Suite Lifecycle, formerly vRealize Suite Lifecycle Manager, in the management domain in VMware Cloud Foundation mode.

## Syntax

```powershell
New-VCFvRSLCM [-json] <String> [-validate] [<CommonParameters>]
```

## Description

The New-VCFvRSLCM cmdlet deploys VMware Aria Suite Lifecycle in the management domain in VMware Cloud Foundation mode.

## Examples

### Example 1

```powershell
New-VCFvRSLCM -json .\SampleJson\vRealize\New-VCFvRSLCM-AVN.json
```

This example shows how to deploy VMware Aria Suite Lifecycle using a JSON specification file.

### Example 2

```powershell
New-VCFvRSLCM -json .\SampleJson\vRealize\New-VCFvRSLCM-AVN.json -validate
```

This example shows how to validate a JSON specification file.

## Parameters

### -json

Specifies the JSON specification to be used.

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

### -validate

Specifies that the JSON specification should be validated.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
