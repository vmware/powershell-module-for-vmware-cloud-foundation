# Get-VCFCompliance

## Synopsis

Retrieves a specific compliance audit result.

## Syntax

```powershell
Get-VCFCompliance [-complianceAuditId] <String> [<CommonParameters>]
```

## Description

The `Get-VCFCompliance` cmdlet retrieves a specific compliance audit result.

## Examples

### Example 1

```powershell
Get-VCFCompliance -complianceAuditId "1758e972-8509-4dce-93d9-a303d7c35a41"

resourceType                         : SDDC_MANAGER
resourceName                         : sfo-vcf01.sfo.rainpole.io
configurationId                      : 1602
configurationTitle                   : Install Security Patches and updates for SDDC Manager.
isConfigurationRecommendedByStandard : True
citationReference                    : 6.3.3, 6.3.3 Bullet 1, 6.3.3 Bullet 2
recommendedValue                     : TRUE
actualValue                          : FALSE
complianceStatus                     : NON_COMPLIANT
remediationStep                      : To apply patches and updates to SDDC Manager/Cloud Foundation follow the guidance in the Lifecycle Management section found at the URL below.
                                       https://docs.vmware.com/en/VMware-Cloud-Foundation/5.0/vcf-lifecycle/GUID-B384B08D-3652-45E2-8AA9-AF53066F5F70.html
complianceAuditStatus                : SUCCEEDED

resourceType                         : SDDC_MANAGER
resourceName                         : sfo-vcf01.sfo.rainpole.io
configurationId                      : 1601
configurationTitle                   : SDDC Manager components must use an authoritative time source.
isConfigurationRecommendedByStandard : True
citationReference                    : 10.6.1, 10.6.2 Bullet 6, 10.6.2, 10.6.2 Bullet 2, 10.6.2 Bullet 3
recommendedValue                     : TRUE
actualValue                          : TRUE
complianceStatus                     : COMPLIANT
remediationStep                      : From the SDDC Manager UI, navigate to Administration >> Network Settings >> NTP Configuration Click 'Edit'. Review the information on updating NTP and click 'Next'. Review the
                                       prerequisites and click 'Next'. Enter new authoritative NTP servers in the text box and click 'Save'.
complianceAuditStatus                : SUCCEEDED
```

This example shows how to retrieve a specific compliance audit result.

## Parameters

### -complianceAuditId

Specified the compliance task returned from `Get-VCFComplianceTask` or `Get-VCFComplianceHistory`.

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
