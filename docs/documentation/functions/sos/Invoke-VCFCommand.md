# Invoke-VCFCommand

## Synopsis

Connects to the specified SDDC Manager using SSH and invoke SSH commands (SoS).

## Syntax

```powershell
Invoke-VCFCommand [[-vcfPassword] <String>] [[-rootPassword] <String>] [-sosOption] <String>
 [<CommonParameters>]
```

## Description

The Invoke-VCFCommand cmdlet connects to the specified SDDC Manager via SSH using vcf user and subsequently
execute elevated SOS commands using the root account.
Both vcf and root password are mandatory parameters.
If passwords are not passed as parameters it will prompt for them.

## Examples

### Example 1

```powershell
Invoke-VCFCommand -vcfpassword VMware1! -rootPassword VMware1! -sosOption general-health
```

This example will execute and display the output of "/opt/vmware/sddc-support/sos --general-health".

### Example 2

```powershell
Invoke-VCFCommand -sosOption general-health
```

This example will ask for vcf and root password to the user and then execute and display the output of "/opt/vmware/sddc-support/sos --general-health".

## Parameters

### -vcfPassword

{{ Fill vcfPassword Description }}

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

### -rootPassword

{{ Fill rootPassword Description }}

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

### -sosOption

{{ Fill sosOption Description }}

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
