# New-VCFServiceUser

## Synopsis

Adds a service user.

## Syntax

```powershell
New-VCFServiceUser [-user] <String> [-role] <String> [<CommonParameters>]
```

## Description

The `New-VCFServiceUser` cmdlet adds a service user to SDDC Manager with a specified role.

## Examples

### Example 1

```powershell
New-VCFServiceUser -user svc-user@rainpole.io -role ADMIN
```

This example shows how to add a service user with a specified role.

## Parameters

### -user

Specifies the name of the service user.

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

### -role

Specifies the role for the service user. One of: ADMIN, OPERATOR, VIEWER.

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
