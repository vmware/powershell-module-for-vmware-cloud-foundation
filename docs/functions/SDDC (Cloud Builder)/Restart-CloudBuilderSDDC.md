# Restart-CloudBuilderSDDC

### Synopsis
Retry failed SDDC creation

### Syntax
```
Restart-CloudBuilderSDDC -id <string>
```

### Description
The Restart-CloudBuilderSDDC retries a deployment on Cloud Builder

### Examples
#### Example 1
```
Restart-CloudBuilderSDDC -id bedf19f8-9dfe-4c60-aae4-bca986a65a31
```
This example retries a deployment on Cloud Builder based on the ID

#### Example 2
```
Restart-CloudBuilderSDDC -id bedf19f8-9dfe-4c60-aae4-bca986a65a31 -json .\SampleJSON\SDDC\SddcSpec.json
```
This example retries a deployment on Cloud Builder based on the ID with an updated JSON file

### Parameters

#### -id
ID of the deployment

```yaml
Type: String
Parameter Sets: Username
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Notes

### Related Links
