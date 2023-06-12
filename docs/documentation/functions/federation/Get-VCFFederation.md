# Get-VCFFederation

## Synopsis

Retrieves the details for a federation.

## Syntax

```powershell
Get-VCFFederation
```

## Description

The Get-VCFFederation cmdlet retrieves the details for a federation from SDDC Manager.

???+ warning

    This API is was deprecated in VMware Cloud Foundation 4.3.0 and removed in VMware Cloud Foundation 4.4.0.

## Examples

### Example 1

```powershell
Get-VCFFederation
```

This example shows how to retrieve the details for a federation from SDDC Manager.

### Example 2

```powershell
Get-VCFFederation | ConvertTo-Json
```

This example shows how to retrieve the details for a federation from SDDC Manager and convert the output to JSON.
