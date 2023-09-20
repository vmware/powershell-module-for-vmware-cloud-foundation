# Get-VCFIdentityProviderIdByType

## Synopsis

Retrieves the ID of an identity provider based on its type.

## Syntax

```powershell
Get-VCFIdentityProviderIdByType [-type] <String> [<CommonParameters>]
```

## Description

The `Get-VCFIdentityProviderIdByType` cmdlet retrieves the ID of an identity provider based on its type.

## Examples

### Example 1

```powershell
Get-VCFIdentityProviderIdByType -type Embedded
```

This example shows how to retrieve the ID of an embedded identity provider.

### Example 2

```powershell
Get-VCFIdentityProviderIdByType -type "Microsoft ADFS"
```

This example shows how to retrieve the ID of an external identity provider.

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

### Common Parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
