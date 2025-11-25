# Get-VCFIdentityProvider

## Synopsis

Retrieves a list of all identity providers or the details of a specific identity provider.

## Syntax

```powershell
Get-VCFIdentityProvider [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFIdentityProvider` cmdlet retrieves a list of all identity providers or the details of a specific identity provider.

## Examples

### Example 1

```powershell
Get-VCFIdentityProvider
```

This example shows how to retrieve the details of all identity providers.

### Example 2

```powershell
Get-VCFIdentityProvider -id 3e250ddd-07ec-4923-a161-ab6e9aa588181
```

This example shows how to retrieve the details of a specific identity provider.

## Parameters

### -id

Specifies the unique ID of the identity provider.

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
