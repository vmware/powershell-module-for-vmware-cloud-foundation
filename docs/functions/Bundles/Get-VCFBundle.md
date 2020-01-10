# Get-VCFBundle

## SYNOPSIS
    Get all Bundles i.e uploaded bundles and also bundles available via depot access

## Syntax
```
Get-VCFBundle -id <string>
```

## DESCRIPTION
    Get all Bundles i.e uploaded bundles and also bundles available via depot access. 

## EXAMPLES

### EXAMPLE 1
```
Get-VCFBundle
    This example gets the list of bundles and all details
```
### EXAMPLE 2
```
Get-VCFBundle | Select version,downloadStatus,id
    This example gets the list of bundles and filters on the version, download status and the id only
```
### EXAMPLE 3
```
Get-VCFBundle -id 7ef354ab-13a6-4e39-9561-10d2c4de89db
    This example gets the details of a specific bundle by its id 
```
### EXAMPLE 4
```
Get-VCFBundle | Where {$_.description -Match "vRealize"}
    This example lists all bundles that have vRealize in the description field
```

## PARAMETERS

### -id
- ID of a specific bundle 

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

## NOTES

## RELATED LINKS
