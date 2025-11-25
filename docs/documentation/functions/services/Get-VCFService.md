# Get-VCFService

## Synopsis

Retrieves a list of services running on SDDC Manager.

## Syntax

```powershell
Get-VCFService [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFService` cmdlet retrieves the list of services running on SDDC Manager.

## Examples

### Example 1

```powershell
Get-VCFService
```

This example shows how to retrieve a list of all services running on SDDC Manager.

### Example 2

```powershell
Get-VCFService -id 4e416419-fb82-409c-ae37-32a60ba2cf88
```

This example shows how to return the details for a specific service running on SDDC Manager by unique ID.

## Parameters

### -id

Specifics the unique ID of the service running on SDDC Manager.

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

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
