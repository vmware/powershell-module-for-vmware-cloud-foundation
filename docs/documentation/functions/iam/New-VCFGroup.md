# New-VCFGroup

## Synopsis

Adds a new group with a specified role.

## Syntax

```powershell
New-VCFGroup [-group] <String> [-domain] <String> [-role] <String> [<CommonParameters>]
```

## Description

The `New-VCFGroup` cmdlet adds a new group with a specified role to SDDC Manager.

## Examples

### Example 1

```powershell
New-VCFGroup -group ug-vcf-group -domain rainpole.io -role ADMIN
```

This example shows how to add a new group with a specified role.

## Parameters

### -group

Specifies the name of the group.

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

### -domain

Specifies the authentication domain for the group.

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

### -role

Specifies the role for the group in the SDDC Manager. One of: ADMIN, OPERATOR, VIEWER.

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
