# Get-VCFNsxtCluster

### Synopsis
Gets a list of NSX-T Clusters

### Syntax
```
Get-VCFNsxtCluster -id <string>
```

### Description
The Get-VCFNsxtCluster cmdlet retrieves a list of NSX-T Clusters managed by the connected SDDC Manager

### Examples
#### Example 1
```
Get-VCFNsxtCluster
```
This example shows how to get the list of NSX-T Clusters managed by the connected SDDC Manager

#### Example 2
```
Get-VCFNsxtCluster -id d189a789-dbf2-46c0-a2de-107cde9f7d24
```
This example shows how to return the details for a specic NSX-T Clusters managed by the connected SDDC Manager

#### Example 3
```
Get-VCFNsxtCluster | select fqdn		
```
This example shows how to get the list of NSX-T Clusters managed by the connected SDDC Manager but only return the fqdn

### Parameters

#### -id
- ID of a specific VCF NSX-T Cluster

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
