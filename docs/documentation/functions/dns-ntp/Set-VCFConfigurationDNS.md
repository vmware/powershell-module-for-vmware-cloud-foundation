# Set-VCFConfigurationDNS

## Synopsis

Sets the DNS configuration for all systems managed by SDDC Manager.

## Syntax

```powershell
Set-VCFConfigurationDNS [-json] <String> [-validate] [<CommonParameters>]
```

## Description

The Set-VCFConfigurationDNS cmdlet sets the DNS configuration for all systems managed by SDDC Manager.

## Examples

### Example 1

```powershell
Set-VCFConfigurationDNS -json $jsonSpec
```

This example shows how to set the DNS configuration for all systems managed by SDDC Manager using a JSON specification.

### Example 2

```powershell
Set-VCFConfigurationDNS -json (Get-Content -Raw .\dnsSpec.json)
```

This example shows how to set the DNS configuration for all systems managed by SDDC Manager using a JSON specification file.

### Example 3

```powershell
Set-VCFConfigurationDNS -json $jsonSpec -validate
```

This example shows how to validate the DNS configuration.

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
