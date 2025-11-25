# Remove-VCFIdentityProvider

## Synopsis

Removes an identity provider.

## Syntax

```powershell
Remove-VCFIdentityProvider [-type] <String> [[-domainName] <String>] [<CommonParameters>]
```

## Description

The Remove-VCFIdentityProvider cmdlet removes an identity provider.

## Examples

### Example 1

```powershell
Remove-VCFIdentityProvider -type Embedded -domainName sfo.rainpole.io.
```

This example shows how to remove an embedded identity provider with a specific domain name.

### Example 2

```powershell
Remove-VCFIdentityProvider -type "Microsoft ADFS".
```

This example shows how to remove an external identity provider.

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
