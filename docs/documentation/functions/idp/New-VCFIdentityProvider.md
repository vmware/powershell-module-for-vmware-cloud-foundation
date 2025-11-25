# New-VCFIdentityProvider

## Synopsis

Configures an identity provider.

## Syntax

```powershell
New-VCFIdentityProvider [-type] <String> [-json] <String> [<CommonParameters>]
```

## Description

The `New-VCFIdentityProvider` cmdlet configures an embedded or external identity provider from a JSON specification file.

## Examples

### Example 1

```powershell
New-VCFIdentityProvider -type Embedded -json .\samples\idp\embeddedIdpSpec.json
```

This example shows how to configure an embedded identity provider from the JSON specification file.

???+ example "Sample JSON: Embedded Identity Provider"

    ```json
    --8<-- "./samples/idp/embeddedIdpSpec.json"
    ```

### Example 2

```powershell
New-VCFIdentityProvider -type "Microsoft ADFS" -json .\samples\idp\externalIdpSpec.json
```

This example shows how to configure an external identity provider from the JSON specification file.

???+ example "Sample JSON: External Identity Provider"

    ```json
    --8<-- "./samples/idp/externalIdpSpec.json"
    ```

## Parameters

### -type

Specifies the type of the identity provider. One of: `Embedded`, `Microsoft ADFS`.

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

### -json

Specifies the JSON specification file to be used.

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
