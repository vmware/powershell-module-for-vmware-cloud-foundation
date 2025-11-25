# Update-VCFIdentityProvider

## Synopsis

Updates an identity provider.

## Syntax

```powershell
Update-VCFIdentityProvider [-type] <String> [[-domainName] <String>] [-json] <String> [<CommonParameters>]
```

## Description

The `Update-VCFIdentityProvider` cmdlet updates the configuration of an embedded or external identity provider from a JSON specification file.

## Examples

### Example 1

```powershell
Update-VCFIdentityProvider -type Embedded -domainName sfo.rainpole.io -json .\samples\idp\embeddedIdpSpec.json
```

This example shows how to update the configuration of an embedded identity provider from the JSON specification file for a specific domain name.

### Example 2

```powershell
Update-VCFIdentityProvider -type "Microsoft ADFS" -json .\samples\idp\externalIdpSpec.json
```

This example shows how to update the configuration of "Microsoft ADFS" identity provider from the JSON specification file.

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

### -domainName

Specifies the domain name of the identity provider.

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

### -json

Specifies the JSON specification file to be used.

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
