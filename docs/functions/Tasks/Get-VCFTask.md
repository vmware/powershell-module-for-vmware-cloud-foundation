# Get-VCFTask

### Synopsis
Connects to the specified SDDC Manager and retrieves a list of tasks.

### Syntax
```
Get-VCFTask -id <string>
```

### Description
The Get-VCFTask cmdlet connects to the specified SDDC Manager and retrieves a list of tasks.

### Examples
#### Example 1
```
Get-VCFTask
```
This example shows how to get all tasks

#### Example 2
```
Get-VCFTask -id 7e1c2eee-3177-4e3b-84db-bfebc83f386a 	
```
This example shows how to get a task by id

### Parameters

#### -id
- ID of a task

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
