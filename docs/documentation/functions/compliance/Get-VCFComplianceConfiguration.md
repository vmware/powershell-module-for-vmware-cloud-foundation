# Get-VCFComplianceConfiguration

## Synopsis

Retrieves the list of all compliance configurations along with their applicable resource types and versions.

## Syntax

```powershell
Get-VCFComplianceConfiguration
```

## Description

The `Get-VCFComplianceConfiguration` cmdlet retrieves the list of all compliance configurations along with their applicable resource types and versions.

## Examples

### Example 1

```powershell
Get-VCFComplianceConfiguration

configurationId configurationTitle                                                                   complianceResourceStandardConfigurationDetails
--------------- ------------------                                                                  ----------------------------------------------
1600            Verify SDDC Manager backup.                                                         {@{resourceType=SDDC_MANAGER; resourceVersion=5.2.0.0; standardConfigurationDetails=System.Object[]}}
1601            SDDC Manager components must use an authoritative time source.                      {@{resourceType=SDDC_MANAGER; resourceVersion=5.2.0.0; standardConfigurationDetails=System.Object[]}}
1602            Install Security Patches and updates for SDDC Manager.                              {@{resourceType=SDDC_MANAGER; resourceVersion=5.2.0.0; standardConfigurationDetails=System.Object[]}}
1603            Use an SSL certificate issued by a trusted certificate authority on the SDDC Manager. {@{resourceType=SDDC_MANAGER; resourceVersion=5.2.0.0; standardConfigurationDetails=System.Object[]}}
1604            Do not expose SDDC Manager directly on the Internet.                                {@{resourceType=SDDC_MANAGER; resourceVersion=5.2.0.0; standardConfigurationDetails=System.Object[]}}
1605            Assign least privileges to users and service accounts in SDDC Manager.              {@{resourceType=SDDC_MANAGER; resourceVersion=5.2.0.0; standardConfigurationDetails=System.Object[]}}
1607            Dedicate an account for downloading updates and patches in SDDC Manager.            {@{resourceType=SDDC_MANAGER; resourceVersion=5.2.0.0; standardConfigurationDetails=System.Object[]}}
1608            SDDC Manager must be deployed with FIPS mode enabled.                               {@{resourceType=SDDC_MANAGER; resourceVersion=5.2.0.0; standardConfigurationDetails=System.Object[]}}
1609            SDDC Manager must schedule automatic password rotation.                             {@{resourceType=SDDC_MANAGER; resourceVersion=5.2.0.0; standardConfigurationDetails=System.Object[]}}
```

This example shows how to retrieve a list of all compliance configurations.
