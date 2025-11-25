# Get-VCFCertificate

## Synopsis

Retrieves the latest generated certificate(s) for a workload domain.

## Syntax

```powershell
Get-VCFCertificate [-domainName] <String> [-resources] [<CommonParameters>]
```

## Description

The `Get-VCFCertificate` cmdlet retrieves the latest generated certificate(s) for a workload domain.

## Examples

### Example 1

```powershell
Get-VCFCertificate -domainName sfo-m01
```

This example shows how to retrieve the latest generated certificate(s) for a workload domain.

### Example 2

```powershell
Get-VCFCertificate -domainName sfo-m01 | ConvertTo-Json
```

This example shows how to retrieve the latest generated certificate(s) for a workload domain and convert the output to JSON.

### Example 3

```powershell
Get-VCFCertificate -domainName sfo-m01 | Select issuedTo
```

This example shows how to retrieve the latest generated certificate(s) for a workload domain and select the `issuedTo` property.

### Example 4

```powershell
Get-VCFCertificate -domainName sfo-m01 -resources
```

This example shows how to retrieve the latest generated certificate(s) for a workload domain and retrieve the certificates for all resources in the workload domain.

## Parameters

### -domainName

Specifies the name of the workload domain.

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

### -resources

Specifies retrieving the certificates for the resources.

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
