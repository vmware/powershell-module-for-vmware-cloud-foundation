# Join-VCFFederation

## Synopsis

Join an SDDC Manager instance to an existing federation.

## Syntax

```powershell
Join-VCFFederation [-json] <String> [<CommonParameters>]
```

## Description

The `Join-VCFFederation` cmdlet joins an SDDC Manager instance to an existing federation.

???+ warning

    This API is was deprecated in VMware Cloud Foundation 4.3.0 and removed in VMware Cloud Foundation 4.4.0.

## Examples

### Example 1

```powershell
Join-VCFFederation -json (Get-Content -Raw .\samples\federation\joinFederationSpec.json)
```

This example shows how to join an SDDC Manager instance to an existing federation.

???+ example "Sample JSON: Join Federation"

    ```json
    --8<-- "./samples/federation/joinFederationSpec.json"
    ```

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
