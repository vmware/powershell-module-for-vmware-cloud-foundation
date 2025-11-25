# Get-VCFCredentialTask

## Synopsis

Retrieves a list of credential tasks in reverse chronological order.

## Syntax

```powershell
Get-VCFCredentialTask [[-id] <String>] [-resourceCredentials] [[-status] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFCredentialTask` cmdlet retrieves a list of credential tasks in reverse chronological order. You can retrieve the credential tasks by unique ID, status, or resource credentials.

## Examples

### Example 1

```powershell
Get-VCFCredentialTask
```

This example shows how to retrieve a list of all credentials tasks.

### Example 2

```powershell
Get-VCFCredentialTask -id 7534d35d-98fb-43de-bcf7-2776beb6fcc3
```

This example shows how to retrieve the credential tasks for a specific task by unique ID.

### Example 3

```powershell
Get-VCFCredentialTask -id 7534d35d-98fb-43de-bcf7-2776beb6fcc3 -resourceCredentials
```

This example shows how to retrieve resource credentials for a credential task by unique ID.

### Example 4

```powershell
Get-VCFCredentialTask -status SUCCESSFUL
```

This example shows how to retrieve credentials tasks with a specific status.

## Parameters

### -id

Specifies the unique ID of the credential task.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -resourceCredentials

Specifies the status of the credential task.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -status

Specifies the status of the credential task. One of: SUCCESSFUL, FAILED, USER_CANCELLED.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
