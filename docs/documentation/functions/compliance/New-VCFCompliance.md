# New-VCFCompliance

## Synopsis

Performs a new compliance audit.

## Syntax

```powershell
New-VCFCompliance [-resourceType] <String> [-standardType] <String> [-standardVersion] <String> [-domainName] <String> [<CommonParameters>]
```

## Description

The `New-VCFWorkloadDomain` cmdlet performs a new compliance audit.

## Examples

### Example 1

```powershell
New-VCFCompliance -resourceType "SDDC_MANAGER" -standardType "PCI" -standardVersion "4.0" -domainName "sfo-m01"
```

This example shows how to perform a new compliance audit.

## Parameters

### -resourceType

Specifies the resource type for the compliance audit. Please use `Get-VCFComplianceConfiguration` to see available options.

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

### -standardType

Specifies the compliance type for the compliance audit. Please use `Get-VCFComplianceStandard` to see available options.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -standardVersion

Specifies the compliance version for the compliance audit. Please use `Get-VCFComplianceStandard` to see available options.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -domainName

Specifies the name of the workload domain.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
