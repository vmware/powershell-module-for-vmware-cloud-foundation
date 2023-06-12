# Set-VCFCredential

## Synopsis

Updates a credential.

## Syntax

```powershell
Set-VCFCredential [-json] <String> [<CommonParameters>]
```

## Description

The Set-VCFCredential cmdlet updates a credential.

???+ info

    Credentials can be updated with a specified password(s) or rotated using system generated password(s).

## Examples

### Example 1

```powershell
Set-VCFCredential -json .\Credential\updateCredentialSpec.json
```

This example shows how to update a credential using a JSON specification file.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
