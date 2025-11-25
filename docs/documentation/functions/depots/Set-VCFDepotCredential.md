# Set-VCFDepotCredential

## Synopsis

Updates the configuration for the depot of the connected SDDC Manager.

## Syntax

```powershell
Set-VCFDepotCredential -username <String> -password <String> [-vxrail] [<CommonParameters>]
```

## Description

The `Set-VCFDepotCredential` cmdlets updates the configuration for the depot of the connected SDDC Manager.

## Examples

### Example 1

```powershell
Set-VCFDepotCredential -username "support@rainpole.io" -password "VMw@re1!"
```

This example sets the credentials for VMware Customer Connect.

### Example 2

```powershell
Set-VCFDepotCredential -vxrail -username "support@rainpole.io" -password "VMw@re1!"
```

This example sets the credentials for Dell EMC Support.

## Parameters

### -username

Specifies the username for the depot.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -password

Specifies the password for the depot.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -vxrail

Specifies that the cmdlet sets the credentials for Dell EMC Support.

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

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
