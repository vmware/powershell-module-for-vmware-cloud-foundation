# Restart-VCFTask

### Synopsis
Connects to the specified SDDC Manager and retries a previously failed task.

### Syntax
```
Restart-VCFTask -id <string>
```

### Description
The Restart-VCFTask cmdlet connects to the specified SDDC Manager and retries a previously failed task using the task id.

### Examples
#### Example 1
```
Restart-VCFTask -id 7e1c2eee-3177-4e3b-84db-bfebc83f386a
```
This example retries the task based on the task id

### Parameters

#### -id
- ID of a task

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
```

### Notes

### Related Links
