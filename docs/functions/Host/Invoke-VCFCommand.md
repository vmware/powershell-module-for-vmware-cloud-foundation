# Invoke-VCFCommand

### Synopsis
Connects to the specified SDDC Manager using SSH and invoke SSH commands (SOS)

### Description
The Invoke-VCFCommand cmdlet connects to the specified SDDC Manager via SSH using vcf user and subsequently 
execute elevated SOS commands using the root account. Both vcf and root password are mandatory parameters.
If passwords are not passed as parameters it will prompt for them.

### Examples
#### Example 1
```
Invoke-VCFCommand -vcfpassword VMware1! -rootPassword VMware1! -sosOption general-health
```
This example will execute and display the output of "/opt/vmware/sddc-support/sos --general-health" command

#### Example 2
```
Invoke-VCFCommand -sosOption general-health
```
This example will ask for vcf and root password to the user and then execute and display the output of "/opt/vmware/sddc-support/sos --general-health" command

### Parameters

#### -vcfPassword
Password for the vcf user to establish the SSH connection

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

#### -rootPassword
root password of SDDC Manager, required to execute sudo commands

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
```

#### -sosOption
List of SoS options to pass as parameter to /opt/vmware/sddc-support/sos

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accepted value: general-health, compute-health, ntp-health, password-health, get-vcf-summary, get-inventory-info, get-host-ips, get-vcf-services-summary
```

### Notes

### Related Links
