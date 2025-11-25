# Get-VCFComplianceTask

## Synopsis

Retrieves the list of all compliance configurations along with their applicable resource types and versions.

## Syntax

```powershell
Get-VCFComplianceTask [-domainName] <String> [-complianceTaskId] <String> [<CommonParameters>]
```

## Description

The `Get-VCFComplianceTask` cmdlet retrieves the compliance audit id and progress using the task id returned from the `New-VCFCompliance` operation.

## Examples

### Example 1

```powershell
Get-VCFComplianceTask -domainName "sfo-m01" -complianceTaskId "d22c47e0-8d38-43da-975b-938e7c59f4d6"

id                                   status     complianceAuditId
--                                   ------     -----------------
d22c47e0-8d38-43da-975b-938e7c59f4d6 SUCCESSFUL 1758e972-8509-4dce-93d9-a303d7c35a41
```

This example shows how to retrieve the compliance audit id and progress using the task id returned from the `New-VCFCompliance` operation.

## Parameters

### -domainName

Specifies the name of the workload domain.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -complianceTaskId

Specifies the compliance task returned from `New-VCFCompliance`.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
