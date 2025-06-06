<!-- markdownlint-disable first-line-h1 no-inline-html -->

<img src="assets/images/icon-color.svg" alt="PowerShell Module for VMware Cloud Foundation" width="150">

# PowerShell Module for VMware Cloud Foundation

`PowerVCF` is an open source PowerShell module for interacting with the [VMware Cloud Foundation][docs-vmware-cloud-foundation] API.

???+ info

    The module supports versions in accordance with the VMware Product Lifecycle Matrix from General Availability to End of General Support. Learn more: [VMware Product Lifecycle Matrix][product-lifecycle-matrix].

[:material-powershell: &nbsp; PowerShell Gallery][psgallery-module-powervcf]{ .md-button .md-button--primary }

## Requirements

### VMware Cloud Foundation

The following table lists the supported releases for this module.

| Platform                                                     | Support                             |
|--------------------------------------------------------------| ----------------------------------- |
| :fontawesome-solid-cloud: &nbsp; VMware Cloud Foundation 5.2 | :fontawesome-solid-check:{ .green } |
| :fontawesome-solid-cloud: &nbsp; VMware Cloud Foundation 5.1 | :fontawesome-solid-check:{ .green } |

???+ tip "Support for Newer Major Releases"

    This module will **only** be sustained for supported versions of the VMware Cloud Foundation releases listed above to address critical issues. You can find general details on supported versions in the [Broadcom Product Lifecycle](https://support.broadcom.com/group/ecx/productlifecycle).

    Please note that this module **will not** provide support or new enhancements for future major releases of VMware Cloud Foundation. If you're planning to upgrade to those newer releases, we encourage you to explore alternative in-product or custom automation solutions.

    We truly appreciate your reliance on and support of this module. Thank you for your understanding as we transition to sustaining the module for these specific major versions.

### PowerShell

The following table lists the supported editions and versions of PowerShell for this module.

Edition                                                                           | Version
----------------------------------------------------------------------------------|----------
:material-powershell: &nbsp; [PowerShell Core][microsoft-powershell]              | >= 7.x
:material-powershell: &nbsp; [Microsoft Windows PowerShell][microsoft-powershell] | 5.1

### Module Dependencies

The following table lists the required PowerShell module dependencies for this module.

PowerShell Module                                    | Version   | Publisher     | Reference
-----------------------------------------------------|-----------|---------------|---------------------------------------------------------------------------
[VMware.PowerCLI][psgallery-module-powercli]         | >= 12.3.0 | Broadcom      | :fontawesome-solid-book: &nbsp; [Documentation][developer-module-powercli]

## Related Projects

The following table lists the related projects for this use this module.

Project                                                                                                         | Reference
----------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------
[PowerShell Module for VMware Cloud Foundation Reporting][psgallery-module-reporting]                           | :fontawesome-solid-book: &nbsp; [Documentation][docs-module-reporting]
[PowerShell Module for VMware Cloud Foundation Certificate Management][psgallery-module-certificate-management] | :fontawesome-solid-book: &nbsp; [Documentation][docs-module-certificate-management]
[PowerShell Module for VMware Cloud Foundation Password Management][psgallery-module-password-management]       | :fontawesome-solid-book: &nbsp; [Documentation][docs-module-password-management]
[PowerShell Module for VMware Cloud Foundation Power Management][psgallery-module-power-management]             | :fontawesome-solid-book: &nbsp; [Documentation][docs-module-power-management]

[developer-module-powercli]: https://developer.vmware.com/tool/vmware-powercli
[docs-module-certificate-management]: https://vmware.github.io/powershell-module-for-vmware-cloud-foundation-certificate-management
[docs-module-password-management]: https://vmware.github.io/powershell-module-for-vmware-cloud-foundation-password-management
[docs-module-power-management]: https://vmware.github.io/powershell-module-for-vmware-cloud-foundation-power-management
[docs-module-reporting]: https://vmware.github.io/powershell-module-for-vmware-cloud-foundation-reporting
[docs-vmware-cloud-foundation]: https://docs.vmware.com/en/VMware-Cloud-Foundation/index.html
[microsoft-powershell]: https://docs.microsoft.com/en-us/powershell
[product-lifecycle-matrix]: https://lifecycle.vmware.com
[psgallery-module-powercli]: https://www.powershellgallery.com/packages/VMware.PowerCLI
[psgallery-module-powervcf]: https://www.powershellgallery.com/packages/PowerVCF
[psgallery-module-reporting]: https://www.powershellgallery.com/packages/VMware.CloudFoundation.Reporting
[psgallery-module-certificate-management]: https://www.powershellgallery.com/packages/VMware.CloudFoundation.CertificateManagement
[psgallery-module-password-management]: https://www.powershellgallery.com/packages/VMware.CloudFoundation.PasswordManagement
[psgallery-module-power-management]: https://www.powershellgallery.com/packages/VMware.CloudFoundation.PowerManagement
