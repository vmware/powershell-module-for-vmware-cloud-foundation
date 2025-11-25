# Get-VCFCertificateCsr

## Synopsis

Retrieve the latest generated certificate signing request(s) (CSR) for a workload domain.

## Syntax

```powershell
Get-VCFCertificateCsr [-domainName] <String> [<CommonParameters>]
```

## Description

The `Get-VCFCertificateCsr` cmdlet gets the available certificate signing request(s) (CSR) for a workload domain.

## Examples

### Example 1

```powershell
Get-VCFCertificateCsr -domainName sfo-m01
```

This example shows how to retrieve the available certificate signing request(s) (CSR) for a workload domain.

### Example 2

```powershell
Get-VCFCertificateCsr -domainName sfo-m01 | ConvertTo-Json
```

This example shows how to retrieve the available certificate signing request(s) (CSR) for a workload domain and convert the output to JSON.

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
