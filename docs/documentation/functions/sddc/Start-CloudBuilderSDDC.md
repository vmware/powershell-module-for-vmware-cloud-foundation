# Start-CloudBuilderSDDC

## Synopsis

Starts a management domain deployment task on VMware Cloud Builder.

## Syntax

```powershell
Start-CloudBuilderSDDC [-json] <String> [<CommonParameters>]
```

## Description

The Start-CloudBuilderSDDC cmdlet starts a management domain deployment task on VMware Cloud Builder using a JSON specification file.

## Examples

### Example 1

```powershell
Start-CloudBuilderSDDC -json .\SampleJSON\SDDC\SddcSpec.json
```

This example shows how to start a management domain deployment task on VMware Cloud Builder using a JSON specification file.

???+ example "Sample JSON: Management Domain Bringup"

    ```json
    {
      "excludedComponents": [
        "NSX-V"
      ],
      "dvSwitchVersion": "7.0.0",
      "skipEsxThumbprintValidation": true,
      "managementPoolName": "sfo-m01-np01",
      "sddcManagerSpec": {
        "secondUserCredentials": {
          "username": "vcf",
          "password": "VMw@re1!"
        },
        "ipAddress": "172.20.11.59",
        "netmask": "255.255.255.0",
        "hostname": "sfo-vcf01",
        "rootUserCredentials": {
          "username": "root",
          "password": "VMw@re1!"
        },
        "restApiCredentials": {
          "username": "admin",
          "password": "VMw@re1!"
        }
      },
      "sddcId": "sfo-m01",
      "ceipEnabled": true,
      "esxLicense": "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX",
      "taskName": "workflowconfig/workflowspec-ems.json",
      "ntpServers": [
        "ntp.sfo.rainpole.io"
      ],
      "dnsSpec": {
        "subdomain": "sfo.rainpole.io",
        "domain": "sfo.rainpole.io",
        "nameserver": "172.20.11.4",
        "secondaryNameserver": "172.20.11.5"
      },
      "networkSpecs": [
        {
          "subnet": "172.20.11.0/24",
          "vlanId": "3061",
          "mtu": "1500",
          "networkType": "MANAGEMENT",
          "gateway": "172.20.11.1",
          "portGroupKey": "sfo-m01-cl01-vds01-pg-mgmt",
          "association": "sfo-m01-dc01"
        },
        {
          "subnet": "172.20.13.0/24",
          "includeIpAddressRanges": [
            {
              "startIpAddress": "172.20.13.101",
              "endIpAddress": "172.20.13.104"
            }
          ],
          "vlanId": "3063",
          "mtu": "9000",
          "networkType": "VSAN",
          "gateway": "172.20.13.253",
          "portGroupKey": "sfo-m01-cl01-vds01-pg-vsan",
          "association": "sfo-m01-dc01"
        },
        {
          "subnet": "172.20.12.0/24",
          "includeIpAddressRanges": [
            {
              "startIpAddress": "172.20.12.101",
              "endIpAddress": "172.20.12.104"
            }
          ],
          "vlanId": "3062",
          "mtu": "9000",
          "networkType": "VMOTION",
          "gateway": "172.20.12.253",
          "portGroupKey": "sfo-m01-cl01-vds01-pg-vmotion",
          "association": "sfo-m01-dc01"
        },
        {
          "networkType": "UPLINK01",
          "subnet": "172.27.24.0/24",
          "gateway": "172.27.24.253",
          "vlanId": "3284",
          "mtu": "9000",
          "portGroupKey": "sfo-m01-cl01-vds01-pg-uplink01",
          "association": "sfo-m01-dc01"
        },
        {
          "networkType": "UPLINK02",
          "subnet": "172.27.25.0/24",
          "gateway": "172.27.25.253",
          "vlanId": "3285",
          "mtu": "9000",
          "portGroupKey": "sfo-m01-cl01-vds01-pg-uplink02",
          "association": "sfo-m01-dc01"
        },
        {
          "networkType": "REGION_SPECIFIC",
          "subnet": "192.168.31.0/24",
          "gateway": "192.168.11.1",
          "mtu": "9000",
          "vlanId": "0",
          "association": "sfo-m01-dc01"
        },
        {
          "networkType": "X_REGION",
          "subnet": "192.168.31.0/24",
          "gateway": "192.168.31.1",
          "mtu": "9000",
          "vlanId": "0",
          "association": "sfo-m01-dc01"
        },
        {
          "networkType": "NSXT_EDGE_TEP",
          "subnet": "172.20.15.0/24",
          "mtu": "9000",
          "gateway": "172.20.15.253",
          "vlanId": "3065",
          "association": "sfo-m01-dc01"
        }
      ],
      "nsxtSpec": {
        "nsxtManagerSize": "medium",
        "nsxtManagers": [
          {
            "hostname": "sfo-m01-nsx01a",
            "ip": "172.20.11.66"
          },
          {
            "hostname": "sfo-m01-nsx01b",
            "ip": "172.20.11.67"
          },
          {
            "hostname": "sfo-m01-nsx01c",
            "ip": "172.20.11.68"
          }
        ],
        "rootNsxtManagerPassword": "VMw@re1!VMw@re1!",
        "nsxtAdminPassword": "VMw@re1!VMw@re1!",
        "nsxtAuditPassword": "VMw@re1!VMw@re1!",
        "rootLoginEnabledForNsxtManager": "true",
        "sshEnabledForNsxtManager": "true",
        "overLayTransportZone": {
          "zoneName": "sfo-m01-tz-overlay01",
          "networkName": "sfo-m01-cl01-nvds01-pg-edge"
        },
        "vlanTransportZone": {
          "zoneName": "sfo-m01-tz-vlan01",
          "networkName": "netName-vlan"
        },
        "vip": "172.20.11.65",
        "vipFqdn": "sfo-m01-nsx01",
        "nsxtLicense": "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX",
        "transportVlanId": 3064,
        "nsxtEdgeSpec": {
          "edgeClusterName": "sfo-m01-ec01",
          "edgeRootPassword": "VMw@re1!VMw@re1!",
          "edgeAdminPassword": "VMw@re1!VMw@re1!",
          "edgeAuditPassword": "VMw@re1!VMw@re1!",
          "edgeFormFactor": "MEDIUM",
          "tier0ServicesHighAvailability": "ACTIVE_ACTIVE",
          "asn": 65003,
          "edgeServicesSpecs": {
            "tier0GatewayName": "sfo-m01-ec01-t0-gw01",
            "tier1GatewayName": "sfo-m01-ec01-t1-gw01"
          },
          "edgeNodeSpecs": [
            {
              "edgeNodeName": "sfo-m01-en01",
              "edgeNodeHostname": "sfo-m01-en01.sfo.rainpole.io",
              "managementCidr": "172.20.11.69/24",
              "edgeVtep1Cidr": "172.20.15.2/24",
              "edgeVtep2Cidr": "172.20.15.3/24",
              "interfaces": [
                {
                  "name": "uplink-edge1-tor1",
                  "interfaceCidr": "172.27.24.2/24"
                },
                {
                  "name": "uplink-edge1-tor2",
                  "interfaceCidr": "172.27.25.3/24"
                }
              ]
            },
            {
              "edgeNodeName": "sfo-m01-en02",
              "edgeNodeHostname": "sfo-m01-en02.sfo.rainpole.io",
              "managementCidr": "172.20.11.70/24",
              "edgeVtep1Cidr": "172.20.15.4/24",
              "edgeVtep2Cidr": "172.20.15.5/24",
              "interfaces": [
                {
                  "name": "uplink-edge2-tor1",
                  "interfaceCidr": "172.27.24.3/24"
                },
                {
                  "name": "uplink-edge2-tor2",
                  "interfaceCidr": "172.27.25.2/24"
                }
              ]
            }
          ],
          "bgpNeighbours": [
            {
              "neighbourIp": "172.27.24.1",
              "autonomousSystem": 65001,
              "password": "VMw@re1!"
            },
            {
              "neighbourIp": "172.27.25.1",
              "autonomousSystem": 65001,
              "password": "VMw@re1!"
            }
          ]
        },
        "logicalSegments": [
          {
            "name": "sfo-m01-seg01",
            "networkType": "REGION_SPECIFIC"
          },
          {
            "name": "xreg-m01-seg01",
            "networkType": "X_REGION"
          }
        ]
      },
      "vsanSpec": {
        "vsanName": "vsan-1",
        "licenseFile": "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX",
        "vsanDedup": "false",
        "datastoreName": "sfo-m01-cl01-ds-vsan01"
      },
      "dvsSpecs": [
        {
          "mtu": 9000,
          "niocSpecs": [
            {
              "trafficType": "VSAN",
              "value": "HIGH"
            },
            {
              "trafficType": "VMOTION",
              "value": "LOW"
            },
            {
              "trafficType": "VDP",
              "value": "LOW"
            },
            {
              "trafficType": "VIRTUALMACHINE",
              "value": "HIGH"
            },
            {
              "trafficType": "MANAGEMENT",
              "value": "NORMAL"
            },
            {
              "trafficType": "NFS",
              "value": "LOW"
            },
            {
              "trafficType": "HBR",
              "value": "LOW"
            },
            {
              "trafficType": "FAULTTOLERANCE",
              "value": "LOW"
            },
            {
              "trafficType": "ISCSI",
              "value": "LOW"
            }
          ],
          "dvsName": "sfo-m01-cl01-vds01",
          "vmnics": [
            "vmnic0",
            "vmnic1"
          ],
          "networks": [
            "MANAGEMENT",
            "VSAN",
            "VMOTION",
            "UPLINK01",
            "UPLINK02",
            "NSXT_EDGE_TEP"
          ]
        }
      ],
      "clusterSpec": {
        "vmFolders": {
          "MANAGEMENT": "sfo-m01-fd-mgmt",
          "NETWORKING": "sfo-m01-fd-nsx",
          "EDGENODES": "sfo-m01-fd-edge"
        },
        "clusterName": "sfo-m01-cl01",
        "clusterEvcMode": "",
        "resourcePoolSpecs": [
          {
            "cpuSharesLevel": "high",
            "cpuSharesValue": 0,
            "name": "sfo-m01-cl01-rp-sddc-mgmt",
            "memorySharesValue": 0,
            "cpuReservationPercentage": 0,
            "memoryLimit": -1,
            "memoryReservationPercentage": 0,
            "cpuReservationExpandable": true,
            "memoryReservationExpandable": true,
            "memorySharesLevel": "normal",
            "cpuLimit": -1,
            "type": "management"
          },
          {
            "cpuSharesLevel": "high",
            "cpuSharesValue": 0,
            "name": "sfo-m01-cl01-rp-sddc-edge",
            "memorySharesValue": 0,
            "cpuReservationPercentage": 0,
            "memoryLimit": -1,
            "memoryReservationPercentage": 0,
            "cpuReservationExpandable": true,
            "memoryReservationExpandable": true,
            "memorySharesLevel": "normal",
            "cpuLimit": -1,
            "type": "network"
          },
          {
            "cpuSharesLevel": "normal",
            "cpuSharesValue": 0,
            "name": "sfo-m01-cl01-rp-user-edge",
            "memorySharesValue": 0,
            "cpuReservationPercentage": 0,
            "memoryLimit": -1,
            "memoryReservationPercentage": 0,
            "cpuReservationExpandable": true,
            "memoryReservationExpandable": true,
            "memorySharesLevel": "normal",
            "cpuLimit": -1,
            "type": "compute"
          },
          {
            "name": "sfo-m01-cl01-rp-user-vm",
            "type": "compute",
            "cpuReservationPercentage": 0,
            "cpuLimit": -1,
            "cpuReservationExpandable": true,
            "cpuSharesLevel": "normal",
            "cpuSharesValue": 0,
            "memoryReservationPercentage": 0,
            "memoryLimit": -1,
            "memoryReservationExpandable": true,
            "memorySharesLevel": "normal",
            "memorySharesValue": 0
          }
        ]
      },
      "pscSpecs": [
        {
          "pscId": "psc-1",
          "vcenterId": "vcenter-1",
          "pscSsoSpec": {
            "ssoSiteName": "sfo-m01",
            "ssoDomainPassword": "VMw@re1!",
            "ssoDomain": "vsphere.local",
            "isJoinSsoDomain": false
          },
          "adminUserSsoPassword": "VMw@re1!"
        }
      ],
      "vcenterSpec": {
        "vcenterIp": "172.20.11.62",
        "vcenterHostname": "sfo-m01-vc01",
        "vcenterId": "vcenter-1",
        "licenseFile": "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX",
        "rootVcenterPassword": "VMw@re1!",
        "vmSize": "small"
      },
      "hostSpecs": [
        {
          "credentials": {
            "username": "root",
            "password": "VMw@re1!"
          },
          "ipAddressPrivate": {
            "subnet": "255.255.255.0",
            "cidr": "172.20.11.0/24",
            "ipAddress": "172.20.11.101",
            "gateway": "172.20.11.1"
          },
          "hostname": "sfo01-m01-esx01",
          "vSwitch": "vSwitch0",
          "serverId": "host-0",
          "association": "sfo-m01-dc01"
        },
        {
          "credentials": {
            "username": "root",
            "password": "VMw@re1!"
          },
          "ipAddressPrivate": {
            "subnet": "255.255.255.0",
            "cidr": "172.20.11.0/24",
            "ipAddress": "172.20.11.102",
            "gateway": "172.20.11.1"
          },
          "hostname": "sfo01-m01-esx02",
          "vSwitch": "vSwitch0",
          "serverId": "host-1",
          "association": "sfo-m01-dc01"
        },
        {
          "credentials": {
            "username": "root",
            "password": "VMw@re1!"
          },
          "ipAddressPrivate": {
            "subnet": "255.255.255.0",
            "cidr": "172.20.11.0/24",
            "ipAddress": "172.20.11.103",
            "gateway": "172.20.11.1"
          },
          "hostname": "sfo01-m01-esx03",
          "vSwitch": "vSwitch0",
          "serverId": "host-2",
          "association": "sfo-m01-dc01"
        },
        {
          "credentials": {
            "username": "root",
            "password": "VMw@re1!"
          },
          "ipAddressPrivate": {
            "subnet": "255.255.255.0",
            "cidr": "172.20.11.0/24",
            "ipAddress": "172.20.11.104",
            "gateway": "172.20.11.1"
          },
          "hostname": "sfo01-m01-esx04",
          "vSwitch": "vSwitch0",
          "serverId": "host-3",
          "association": "sfo-m01-dc01"
        }
      ]
    }
    ```

## Parameters

### -json

Specifies the JSON specification to be used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common Parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).
