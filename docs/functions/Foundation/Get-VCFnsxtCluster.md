# Get-VCFnsxtCluster

## SYNOPSIS
    Gets a list of NSX-T Clusters

## Syntax
```
Get-VCFnsxtCluster -id <string>
```

## DESCRIPTION
    Retrieves a list of NSX-T Clusters managed by the connected SDDC Manager

## EXAMPLES

### EXAMPLE 1
```
Get-VCFnsxtCluster
    This example shows how to get the list of NSX-T Clusters managed by the connected SDDC Manager
```
### EXAMPLE 2
```
Get-VCFnsxtCluster -id d189a789-dbf2-46c0-a2de-107cde9f7d24
    This example shows how to return the details for a specic NSX-T Clusters managed by the connected SDDC Manager
```
### EXAMPLE 3
```
Get-VCFnsxtCluster | select fqdn
    This example shows how to get the list of NSX-T Clusters managed by the connected SDDC Manager but only return the fqdn			
```

## PARAMETERS
### -id
- ID of a specific VCF NSX-T Cluster

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
