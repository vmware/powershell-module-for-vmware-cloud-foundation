# Set-VCFCredentialAutoRotatePolicy

## Synopsis

Updates a credential auto rotate policy.

## Syntax

```powershell
Set-VCFCredentialAutoRotatePolicy [-resourceName] <String> [-resourceType] <String> [-credentialType] <String> [-username] <String> [-autoRotate] <String> [[-frequencyInDays] <Int32>] [<CommonParameters>]
```

## Description

The `Set-VCFCredentialAutoRotatePolicy` cmdlet updates the auto rotate policy for a credential. Credentials can be be set to auto rotate using system generated password(s).

## Examples

### Example 1

```powershell
Set-VCFCredentialAutoRotatePolicy -resourceName sfo01-m01-vc01.sfo.rainpole.io -resourceType VCENTER -credentialType SSH -username root -autoRotate ENABLED -frequencyInDays 90
```

This example shows how to enable the auto rotate policy for a specific resource.

### Example 2

```powershell
Set-VCFCredentialAutoRotatePolicy -resourceName sfo01-m01-vc01.sfo.rainpole.io -resourceType VCENTER -credentialType SSH -username root -autoRotate DISABLED
```

This example shows how to disable the auto rotate policy for a specific resource.

## Parameters

### -resourceName

The name of the resource for which the credential auto rotate policy is to be set.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -resourceType

The type of the resource for which the credential auto rotate policy is to be set. One of: VCENTER, PSC, ESXI, BACKUP, NSXT_MANAGER, NSXT_EDGE, VRSLCM, WSA, VROPS, VRLI, VRA.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: VCENTER, PSC, ESXI, BACKUP, NSXT_MANAGER, NSXT_EDGE, VRSLCM, WSA, VROPS, VRLI, VRA

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -credentialType

The type of the credential for which the auto rotate policy is to be set. One of: SSH, API, SSO, AUDIT.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: SSH, API, SSO, AUDIT

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -username

The username of the credential for which the auto rotate policy is to be set.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -autoRotate

The name of the resource for which the credential auto rotate policy is to be set.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: ENABLED, DISABLED

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -frequencyInDays

The frequency in days for the auto rotate policy. This parameter is required only if the autoRotate parameter is set to ENABLED.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
