# Get-VCFManager

## Synopsis

Retrieves a list of SDDC Managers.

## Syntax

```powershell
Get-VCFManager [[-id] <String>] [[-domainId] <String>] [<CommonParameters>]
```

## Description

The Get-VCFManager cmdlet retrieves a list of SDDC Managers.

## Examples

### Example 1

```powershell
Get-VCFManager
```

This example shows how to retrieve a list of SDDC Managers.

### Example 2

```powershell
Get-VCFManager -id 60d6b676-47ae-4286-b4fd-287a888fb2d0
```

This example shows how to return the details for a specific SDDC Manager based on the unique ID.

### Example 3

```powershell
Get-VCFManager -domainId 1a6291f2-ed54-4088-910f-ead57b9f9902
```

This example shows how to return the details for a specific SDDC Manager based on the domain ID of a workload domain.

## Parameters

### -id

Specifies the unique ID of the SDDC Manager.

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

### -domainId

Specifies the unique ID of a workload domain.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
