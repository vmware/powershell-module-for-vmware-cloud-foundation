# Get-VCFComplianceStandard

## Synopsis

Retrieves the list of all compliance audit standards and versions that are supported.

## Syntax

```powershell
Get-VCFComplianceConfiguration
```

## Description

The `Get-VCFComplianceStandard` cmdlet retrieves the the list of all compliance audit standards and versions that are supported.

## Examples

### Example 1

```powershell
Get-VCFComplianceStandard

standardType standardVersions
------------ ----------------
PCI          {4.0}
```

This example shows how to retrieve a list of all compliance audit standards and versions.
