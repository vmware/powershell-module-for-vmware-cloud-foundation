# Get-VCFCertificateCSRs

## SYNOPSIS
    Get available CSR(s)

## Syntax
```
Get-VCFCertificateCSRs -domainName <string>
```

## DESCRIPTION
    Gets available CSRs from SDDC Manager

## EXAMPLES

### EXAMPLE 1
```
Get-VCFCertificateCSRs -domainName MGMT | ConvertTo-Json
    This example gets a list of CSRs and displays them in JSON format
```


## PARAMETERS

### -domainName
- Name of the Management Domain 

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

## NOTES

## RELATED LINKS
