# Get-VCFPersonality

## Synopsis

Retrieves the vSphere Lifecycle Manager personalities.

## Syntax

```powershell
Get-VCFPersonality [[-id] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFPersonality` cmdlet gets the vSphere Lifecycle Manager personalities which are available via depot access.

## Examples

### Example 1

```powershell
Get-VCFPersonality
```

This example shows how to retrieve a list of all vSphere Lifecycle Manager personalities availble in the depot.

### Example 2

```powershell
Get-VCFPersonality -id b4e3b2c4-31e8-4816-b1c5-801e848bef09
```

This example shows how to retrieve a vSphere Lifecycle Manager personality by unique ID.

## Parameters

### -id

Specifies the unique ID of the vSphere Lifecycle Manager personality.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
