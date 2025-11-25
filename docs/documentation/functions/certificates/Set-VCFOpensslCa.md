# Set-VCFOpensslCa

## Synopsis

Configures OpenSSL Certificate Authority integration.

## Syntax

```powershell
Set-VCFOpensslCa [-commonName] <String> [-organization] <String> [-organizationUnit] <String> [-locality] <String> [-state] <String> [-country] <String> [<CommonParameters>]
```

## Description

The `Set-VCFOpensslCa` cmdlet configures OpenSSL Certificate Authority integration with SDDC Manager.

## Examples

### Example 1

```powershell
Set-VCFOpensslCa -commonName "sfo-vcf01.sfo.rainpole.io" -organization Rainpole -organizationUnit "Platform Engineering -locality "San Francisco" -state CA -country US
```

This example shows how to configure an OpenSSL Certificate Authority integration with SDDC Manager.

## Parameters

### -commonName

Specifies the common name for the OpenSSL Certificate Authority.

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

### -organization

Specifies the organization for the OpenSSL Certificate Authority.

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

### -organizationUnit

Specifies the organization unit for the OpenSSL Certificate Authority.

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

### -locality

Specifies the locality for the OpenSSL Certificate Authority.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -state

Specifies the state for the OpenSSL Certificate Authority.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -country

Specifies the country for the OpenSSL Certificate Authority.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
