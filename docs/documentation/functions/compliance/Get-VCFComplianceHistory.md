# Get-VCFComplianceHistory

## Synopsis

Retrieves the history for all compliance audits that have been performed.

## Syntax

```powershell
Get-VCFComplianceHistory
```

## Description

The `Get-VCFComplianceHistory` cmdlet retrieves the history for all compliance audits that have been performed.

## Examples

### Example 1

```powershell
Get-VCFComplianceHistory

id                                   : b0762a5f-c575-4e1a-a002-de32e9e9426d
creationTimestamp                    : 7/30/2024 9:31:45 PM
completionTimestamp                  : 7/30/2024 9:31:47 PM
standardType                         : PCI
standardVersion                      : 4.0
domainId                             : 6ca52d6b-9292-4baf-ab97-75c3a74d4bf2
configurationEvaluationStatus        : SOME_EVALUATED
configurationEvaluationStatusDetails : [1605, 1604] configurations were skipped in audit. Follow the audit procedure to run them manually.
compliantStatus                      : PARTIALLY_COMPLIANT
totalConfigurationsEvaluated         : 9
numberOfNonCompliantConfigurations   : 5
numberOfSkippedConfigurations        : 2
numberOfAuditItems                   : 9

id                                   : e2b165c7-0118-4064-9f41-33639fb37195
creationTimestamp                    : 7/30/2024 10:52:31 PM
completionTimestamp                  : 7/30/2024 10:52:32 PM
standardType                         : PCI
standardVersion                      : 4.0
domainId                             : 6ca52d6b-9292-4baf-ab97-75c3a74d4bf2
configurationEvaluationStatus        : SOME_EVALUATED
configurationEvaluationStatusDetails : [1605, 1604] configurations were skipped in audit. Follow the audit procedure to run them manually.
compliantStatus                      : PARTIALLY_COMPLIANT
totalConfigurationsEvaluated         : 9
numberOfNonCompliantConfigurations   : 5
numberOfSkippedConfigurations        : 2
numberOfAuditItems                   : 9
```

This example shows how to retrieve the history for all compliance audits that have been performed.
