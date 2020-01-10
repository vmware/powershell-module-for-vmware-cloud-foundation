# Get-VCFService

## SYNOPSIS
    Gets a list of running VCF Services

## Syntax
```
Get-VCFManager -id <string>
```

## DESCRIPTION
     Retrieves the list of services running on the connected SDDC Manager

## EXAMPLES

### EXAMPLE 1
```
Get-VCFService
    This example shows how to get the list of services running on the connected SDDC Manager 
```
### EXAMPLE 2
```
Get-VCFService -id 4e416419-fb82-409c-ae37-32a60ba2cf88
    This example shows how to return the details for a specic service running on the connected SDDC Manager based on the ID 
```

## PARAMETERS
### -id
- ID of a specific SDDC Manager Service

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
