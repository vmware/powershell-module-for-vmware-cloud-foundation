# New-VCFCommissionedHost

## Synopsis

Commission a list of ESXi hosts.

## Syntax

```powershell
New-VCFCommissionedHost [-json] <String> [-validate] [<CommonParameters>]
```

## Description

The `New-VCFCommissionedHost` cmdlet commissions a list of ESXi hosts.

## Examples

### Example 1

```powershell
New-VCFCommissionedHost -json (Get-Content -Raw .\samples\hosts\commissionHostsSpec.json)
```

This example shows how to commission a list of ESXi hosts using a JSON specification files.

???+ example "Sample JSON: Commission ESXi Host(s) from SDDC Manager API JSON Spec"

    ```json
    --8<-- "./samples/hosts/commissionHostsSpec.json"
    ```

???+ example "Sample JSON: Commission ESXi Host(s) from the JSON Spec Provided by the SDDC Manager UI"

    ```json
    --8<-- "./samples/hosts/ui-commissionHostsSpec.json"
    ```

### Example 2

```powershell
New-VCFCommissionedHost -json (Get-Content -Raw .\samples\hosts\commissionHostSpec.json) -validate
```

This example shows how to validate the ESXi host JSON specification file.

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
