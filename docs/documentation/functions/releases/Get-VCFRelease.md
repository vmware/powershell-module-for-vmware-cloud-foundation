# Get-VCFRelease

## Synopsis

Retrieves a list of releases.

## Syntax

### Default (Default)

```powershell
Get-VCFRelease [-domainId <String>] [<CommonParameters>]
```

### futureReleases

```powershell
Get-VCFRelease -domainId <String> [-futureReleases] [<CommonParameters>]
```

### versionEquals

```powershell
Get-VCFRelease [-versionEquals <String>] [<CommonParameters>]
```

### versionGreaterThan

```powershell
Get-VCFRelease [-versionGreaterThan <String>] [<CommonParameters>]
```

### vxRailVersionEquals

```powershell
Get-VCFRelease [-vxRailVersionEquals <String>] [<CommonParameters>]
```

### vxRailVersionGreaterThan

```powershell
Get-VCFRelease [-vxRailVersionGreaterThan <String>] [-applicableForVersion <String>] [<CommonParameters>]
```

### applicableForVxRailVersion

```powershell
Get-VCFRelease [-applicableForVxRailVersion <String>] [<CommonParameters>]
```

## Description

The `Get-VCFRelease` cmdlet returns all releases with options to return releases for a specified workload domain
ID, releases for a specified version, all future releases for a specified version, all applicable releases for
a specified target release, or all future releases for a specified workload domain ID.

## Examples

### Example 1

```powershell
Get-VCFRelease
```

This example shows how to retrieve a list of all releases.

### Example 2

```powershell
Get-VCFRelease -domainId 1a2b3c4d-5e6f-7g8h-9i0j-1k2l3m4n5o6p
```

This example shows how to retrieve a list of all releases for a specified workload domain ID.

### Example 3

```powershell
Get-VCFRelease -versionEquals 4.4.1.0
```

This example shows how to retrieve a release for a specified version.

### Example 4

```powershell
Get-VCFRelease -versionGreaterThan 4.4.1.0
```

This example shows how to retrieve all future releases for a specified version.

### Example 5

```powershell
Get-VCFRelease -vxRailVersionEquals 4.4.1.0
```

This example shows how to retrieve the release for a specified version on VxRail.

### Example 6

```powershell
Get-VCFRelease -vxRailVersionGreaterThan 4.4.1.0
```

This example shows how to retrieve all future releases for a specified version on VxRail.

### Example 7

```powershell
Get-VCFRelease -applicableForVersion 4.4.1.0
```

This example shows how to retrieve all applicable target releases for a version.

### Example 8

```powershell
Get-VCFRelease -applicableForVxRailVersion 4.4.1.0
```

This example shows how to retrieve all applicable target releases for a version on VxRail.

### Example 9

```powershell
Get-VCFRelease -futureReleases -domainId 1a2b3c4d-5e6f-7g8h-9i0j-1k2l3m4n5o6p
```

This example shows how to retrieve all future releases for a specified workload domain.

## Parameters

### -domainId

Specifies the unique ID of the workload domain.

```yaml
Type: String
Parameter Sets: default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: futureReleases
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -versionEquals

Specifies the exact version of the release.

```yaml
Type: String
Parameter Sets: versionEquals
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -versionGreaterThan

Specifies the version of the release to be greater than.

```yaml
Type: String
Parameter Sets: versionGreaterThan
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -vxRailVersionEquals

Specifies the exact version of the release on VxRail.

```yaml
Type: String
Parameter Sets: vxRailVersionEquals
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -vxRailVersionGreaterThan

Specifies the version of the release on VxRail to be greater than.

```yaml
Type: String
Parameter Sets: vxRailVersionGreaterThan
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -applicableForVersion

Specifies the version of the release on VxRail for which applicable target releases are to be retrieved.

```yaml
Type: String
Parameter Sets: applicableForVxRailVersion
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -futureReleases

Specifies all future releases.

```yaml
Type: SwitchParameter
Parameter Sets: futureReleases
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
