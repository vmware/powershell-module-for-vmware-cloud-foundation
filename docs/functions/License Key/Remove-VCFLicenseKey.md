# Remove-VCFLicenseKey

## SYNOPSIS
    Connects to the specified SDDC Manager & deletes a license key.

## Syntax
```
Remove-VCFLicenseKey -key <string>
```

## DESCRIPTION
    The Remove-VCFLicenseKey cmdlet connects to the specified SDDC Manager & deletes a License Key. A license Key can only be removed if it is not in use.


## EXAMPLES

### EXAMPLE 1
```
Remove-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
    This example shows how to delete a License Key
```

## PARAMETERS

### -key
- License Key

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
