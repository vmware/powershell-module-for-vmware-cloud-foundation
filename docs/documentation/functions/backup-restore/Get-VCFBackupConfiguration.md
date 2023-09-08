# Get-VCFBackupConfiguration

## Synopsis

Retrieves the current backup configuration details from SDDC Manager.

## Syntax

```powershell
Get-VCFBackupConfiguration
```

## Description

The `Get-VCFBackupConfiguration` cmdlet retrieves the current backup configuration details.

## Examples

### Example 1

```powershell
Get-VCFBackupConfiguration
```

This example retrieves the backup configuration.

### Example 2

```powershell
Get-VCFBackupConfiguration | ConvertTo-Json
```

This example retrieves the backup configuration and outputs it in JSON format.
