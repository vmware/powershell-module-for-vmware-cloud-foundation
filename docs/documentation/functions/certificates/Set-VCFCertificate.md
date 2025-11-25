# Set-VCFCertificate

## Synopsis

Install certificate(s) for the selected resource(s) in a workload domain.

## Syntax

```powershell
Set-VCFCertificate [-json] <String> [-domainName] <String> [<CommonParameters>]
```

## Description

The `Set-VCFCertificate` cmdlet installs certificate(s) for the selected resource(s) in a workload domain.

## Examples

### Example 1

```powershell
Set-VCFCertificate -domainName MGMT -json (Get-Content -Raw .\samples\certificates\updateCertificateSpec.json)
```

This example shows how to install the certificate(s) for the resources within the domain called MGMT based on the entries within the JSON specification file.

???+ example "Sample JSON: Install Certificates"

    ```json
    --8<-- "./samples/certificates/updateCertificateSpec.json"
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

### -domainName

Specifies the name of the workload domain.

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
