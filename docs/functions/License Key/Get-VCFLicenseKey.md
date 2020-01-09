# Get-VCFLicenseKey

## SYNOPSIS
    Connects to the specified SDDC Manager & retrieves a list of License keys.

## Syntax
```
Get-VCFLicenseKey -id <string>
```

## DESCRIPTION
    The Get-VCFLicenseKey cmdlet connects to the specified SDDC Manager & retrieves a list of License keys. 


## EXAMPLES

### EXAMPLE 1
```
Get-VCFLicenseKey
    This example shows how to get a list of all License keys
```
### EXAMPLE 2
```
Get-VCFLicenseKey -key "AAAAA-AAAAA-AAAAA-AAAAA-AAAAA"
    This example shows how to get a specified License key	
```
### EXAMPLE 3
```
Get-VCFLicenseKey -productType "VCENTER,VSAN"
    This example shows how to get a License Key by product type
	Supported Product Types: SDDC_MANAGER,VCENTER,NSXV,VSAN,ESXI,VRA,VROPS,NSXT	
```
### EXAMPLE 4
```
Get-VCFLicenseKey -status EXPIRED
    This example shows how to get a License by status
	Supported Status Types: EXPIRED,ACTIVE,NEVER_EXPIRES	
```

## PARAMETERS

### -key
- License Key

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```
### -productType
- Product Type

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accepted Value: SDDC_MANAGER,VCENTER,NSXV,VSAN,ESXI,VRA,VROPS,NSXT
```
### -status
- Status of a license

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accepted Value: EXPIRED,ACTIVE,NEVER_EXPIRES
```
## NOTES

## RELATED LINKS
