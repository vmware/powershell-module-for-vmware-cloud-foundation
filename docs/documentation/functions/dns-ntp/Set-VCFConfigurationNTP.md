# Set-VCFConfigurationNTP

## Synopsis

Sets the NTP configuration for all systems managed by SDDC Manager.

## Syntax

```powershell
Set-VCFConfigurationNTP [-json] <String> [-validate] [<CommonParameters>]
```

## Description

The `Set-VCFConfigurationNTP` cmdlet sets the NTP configuration for all systems managed by SDDC Manager.

## Examples

### Example 1

```powershell
Set-VCFConfigurationNTP (Get-Content -Raw .\samples\dns-ntp\ntpSpec.json)
```

This example shows how to set the NTP configuration for all systems managed by SDDC Manager using a JSON specification file.

???+ example "Sample JSON: NTP Configuration"

    ```json
    --8<-- "./samples/dns-ntp/ntpSpec.json"
    ```

### Example 2

```powershell
Set-VCFConfigurationNTP -json (Get-Content -Raw .\samples\dns-ntp\ntpSpec.json) -validate
```

This example shows how to validate the NTP configuration.

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

Specifies to validate the JSON specification file.

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
