# Get-VCFCertificate

## SYNOPSIS
    Get latest generated certificate(s) in a domain

## Syntax
```
Get-VCFCertificate -domainName <string>
```

## DESCRIPTION
    Get latest generated certificate(s) in a domain

## EXAMPLES

### EXAMPLE 1
```
Get-VCFCertificate -domainName MGMT
    This example gets a list of certificates that have been generated
```
### EXAMPLE 2
```
Get-VCFCertificate -domainName MGMT | ConvertTo-Json
    This example gets a list of certificates and displays them in JSON format
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
