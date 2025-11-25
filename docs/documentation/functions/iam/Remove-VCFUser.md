# Remove-VCFUser

## Synopsis

Removes a user.

## Syntax

```powershell
Remove-VCFUser [-id] <String> [<CommonParameters>]
```

## Description

The `Remove-VCFUser` cmdlet removes a user from SDDC Manager.

## Examples

### Example 1

```powershell
Remove-VCFUser -id c769fcc5-fb61-4d05-aa40-9c7786163fb5
```

This example shows how to remove a user from SDDC Manager.

## Parameters

### -id

Specifies the unique ID of the user to remove.

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
