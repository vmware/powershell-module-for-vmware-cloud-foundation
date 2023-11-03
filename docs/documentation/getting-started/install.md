# Installing the Module

## From Powershell Gallery

Verify that your system has a supported edition and version of PowerShell installed.

Install the PowerShell module dependencies from the PowerShell Gallery by running the following commands:

```powershell
--8<-- "./docs/snippets/install-module.ps1"
```

If using PowerShell Core, import the module before proceeding:

For example:

```powershell
--8<-- "./docs/snippets/import-module.ps1"
```

## From Air-gapped Machine

Verify that your system has a [supported edition and version](/powershell-module-for-vmware-cloud-foundation-password-management/#powershell) of PowerShell installed.

=== ":fontawesome-brands-windows: &nbsp; Windows"

    Save Modules [module dependencies](/powershell-module-for-vmware-cloud-foundation-password-management/#module-dependencies) from the PowerShell Gallery on a non air-gapped machine by running the following commands:

    ```powershell
    --8<-- "./docs/snippets/save-module-local-windows.ps1"
    ```

    Copy the PowerShell Modules [module dependencies](/powershell-module-for-vmware-cloud-foundation-password-management/#module-dependencies) from the Local Machine to air-gapped facing machine by running the following commands:

    ```powershell
    --8<-- "./docs/snippets/copy-module-local-windows.ps1"
    ```

    Import the PowerShell Modules [module dependencies](/powershell-module-for-vmware-cloud-foundation-password-management/#module-dependencies) from the air-gapped machine by running the following commands:

    ```powershell
    --8<-- "./docs/snippets/import-module.ps1"
    ```

=== ":fontawesome-brands-linux: &nbsp; Linux"

    Prerequisite for module install on Linux Machine

    ```bash
    --8<-- "./docs/snippets/pre-req-linux.sh"
    ```

    Save Modules [module dependencies](/powershell-module-for-vmware-cloud-foundation-password-management/#module-dependencies) from the PowerShell Gallery on a non air-gapped machine by running the following commands:

    ```powershell
    --8<-- "./docs/snippets/save-module-local-linux.ps1"
    ```

    Copy the PowerShell Modules [module dependencies](/powershell-module-for-vmware-cloud-foundation-password-management/#module-dependencies) from the Local Machine to air-gapped facing machine by running the following commands:

    ```bash
    --8<-- "./docs/snippets/copy-module-local-linux.sh"
    ```

    Import the PowerShell Modules [module dependencies](/powershell-module-for-vmware-cloud-foundation-password-management/#module-dependencies) from the air-gapped machine by running the following commands in PowerShell:

    ```powershell
    --8<-- "./docs/snippets/import-module-local-linux.ps1"
    ```
Once installed, any cmdlets associated with `PowerVCF` will be available for use.

To view the cmdlets for available in the module, run the following command in the PowerShell console.

```powershell
Get-Command -Module PowerVCF
```

To view the help for any cmdlet, run the `Get-Help` command in the PowerShell console.

For example:

```powershell
Get-Help -Name <cmdlet-name>
```

```powershell
Get-Help -Name <cmdlet-name> -Examples
```

```powershell
Get-Help -Name <cmdlet-name> -Full
```
