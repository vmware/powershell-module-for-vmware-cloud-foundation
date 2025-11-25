# Get-VCFUser

## Synopsis

Retrieves a list of users, groups, and service users.

## Syntax

```powershell
Get-VCFUser [[-type] <String>] [[-domain] <String>] [<CommonParameters>]
```

## Description

The `Get-VCFUser` cmdlet retrieves a list of users, groups, and service users from SDDC Manager.

## Examples

### Example 1

```powershell
Get-VCFUser
```

This example shows how to retrieve a list of users, groups, and service users from SDDC Manager.

### Example 2

```powershell
Get-VCFUser -type USER
```

This example shows how to retrieve a list of users from SDDC Manager.

### Example 3

```powershell
Get-VCFUser -type GROUP
```

This example shows how to retrieve a list of groups from SDDC Manager.

### Example 4

```powershell
Get-VCFUser -type SERVICE
```

This example shows how to retrieve a list of service users from SDDC Manager.

### Example 5

```powershell
Get-VCFUser -domain rainpole.io
```

This example shows how to retrieve a list of users, groups, and service users from an authentication domain.

## Parameters

### -type

Specifies the type of user to retrieve. One of: USER, GROUP, SERVICE.

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

### -domain

Specifies the authentication domain to retrieve users from.

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
