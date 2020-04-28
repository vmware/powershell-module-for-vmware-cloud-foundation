# Get-VCFCluster

### Synopsis
Connects to the specified SDDC Manager & retrieves a list of clusters

### Syntax
```
Get-VCFWorkloadDomain -name <string> -id <string>
```

### Description
The Get-VCFCluster cmdlet connects to the specified SDDC Manager & retrieves a list of clusters

### Examples
#### Example 1
```
Get-VCFCluster
```
This example shows how to get a list of all clusters

#### Example 2
```
Get-VCFCluster -name wld01-cl01
```
This example shows how to get a cluster by name

#### Example 3
```
Get-VCFCluster -id 8423f92e-e4b9-46e7-92f7-befce4755ba2
```
This example shows how to get a cluster by id

### Parameters

#### -name
- The friendly name of a cluster

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

#### -id
ID of a specific cluster

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
