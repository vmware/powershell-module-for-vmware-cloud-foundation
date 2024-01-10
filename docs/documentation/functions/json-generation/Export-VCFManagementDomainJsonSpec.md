# Export-VCFManagementDomainJsonSpec

## Synopsis

Generates a JSON file from the VCF Planning & Preparation Workbook to perform a VCF bringup.

## Syntax

```powershell
Export-VCFManagementDomainJsonSpec [[-workbook] <String>] [[-path] <String>] [<CommonParameters>]
```

## Description

The `Export-VCFManagementDomainJsonSpec` cmdlet Generates a JSON file from the VCF Planning & Preparation Workbook to perform a VCF bringup.

## Examples

### Example 1

```powershell
Export-VCFManagementDomainJsonSpec -workbook vcf-pnp.xlsx -path ./
```

This example will open the Planning & Preparation workbook and extract the required data to create a bringup JSON.

## Parameters

### -workbook

Specifies the path to the Planning & Preparation workbook.

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

### -path

Specifies the output path for the json file.

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

### Common Parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
