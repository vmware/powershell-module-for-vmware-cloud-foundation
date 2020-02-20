# Get-VCFBundle

### Synopsis
Get all Bundles available to SDDC Manager

### Syntax
```
Get-VCFBundle -id <string>
```

### Description
The Get-VCFBundle cmdlet gets all bundles available to the SDDC Manager instance.
i.e. Manually uploaded bundles and bundles available via depot access.

### Examples
#### Example 1
```
Get-VCFBundle
```
This example gets the list of bundles and all their details

#### Example 2
```
Get-VCFBundle | Select version,downloadStatus,id  
```
This example gets the list of bundles and filters on the version, download status and the id only

#### Example 3
```
Get-VCFBundle -id 7ef354ab-13a6-4e39-9561-10d2c4de89db   
```
This example gets the details of a specific bundle by its id

#### Example 4
```
Get-VCFBundle | Where {$_.description -Match "vRealize"}
```
This example lists all bundles that match vRealize in the description field

### Parameters

#### -id
- ID of a specific bundle

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

### Notes

### Related Links
