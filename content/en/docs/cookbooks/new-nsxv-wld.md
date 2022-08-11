---
title: "New NSX-V Workload Domain"
weight: 5
description: >
    In this example you will create an NSX-V backed VI Workload Domain with the VMware Cloud Foundation API.
---

### Description
Once the initial bring-up of the Management Domain is completed you can add additional VI Workload Domain(s) to service your business workloads.

The sequence of events is as follows:

- Load the PowerVCF Module
- Connect to SDDC Manager
- Create a network pool
- Commission hosts
- Create Workload domain

### Load the PowerVCF Module
- Open powershell and cd to the directory where you downloaded the PowerVCF module
- Run the following to import the module
-     Import-Module .\PowerVCF

### Connect to SDDC Manager
To establish a session with SDDC Manager run the following

```powershell
Connect-VCFManager -fqdn sddc-manager.sfo.rainpole.io -username admin -password VMw@re1!
```
### Create a network pool

The first thing you need before you can commission new hosts is to create a new network pool, which will include the vSAN & vMotion network details for this workload domain cluster.

Before you can create a network pool you first need to create the json body that will be passed in.

#### TIP: The PowerVCF Module includes a folder of sample json files to get you started

Here is the json format required for creating a vSAN network pool (Please use the same json with the module rather than copying from here as formatting is probably messed up!)

```json
{
    "name": "sfo01w01-cl01",
    "networks": [{
        "type": "VSAN",
        "vlanId": 2240,
        "mtu": 9000,
        "subnet": "172.16.240.0",
        "mask": "255.255.255.0",
        "gateway": "172.16.240.253",
        "ipPools": [{
            "start": "172.16.240.5",
            "end": "172.16.240.100"
        }]
    },
    {
        "type": "VMOTION",
        "vlanId": 2236,
        "mtu": 9000,
        "subnet": "172.16.236.0",
        "mask": "255.255.255.0",
        "gateway": "172.16.236.253",
        "ipPools": [{
            "start": "172.16.236.5",
            "end": "172.16.236.100"
        }]
    }]
}
```

So first off lets get a list of current Network Pools. To do this run the following cmdlet:

```powershell
Get-VCFNetworkPool
```

As expected this returns a single network pool.

#### TIP
You can manipulate the return data in several ways.

To create a new network pool using the json we created earlier run the following:

New-VCFNetworkPool -json .\SampleJSON\NetworkPool\addNetworkPoolSpec.json

Now running Get-VCFNetworkPool should display 2 Network Pools

### Commission Hosts

Now that you have a network pool you can commission hosts and associate them with the network pool. For this you need the following json

#### TIP 
For this json you need the network pool name & ID. These were returned when the pool was created and can also be obtained using Get-VCFNetworkPool.

```json
[{
    "fqdn": "sfo01w01esx01.sfo.rainpole.io",
    "username": "root",
    "storageType": "VSAN",
    "password": "VMw@re1!",
    "networkPoolName": "sfo01w01-cl01",
    "networkPoolId": "afd314f6-f31d-4ad4-8943-0ecb35c044b9"
},
{
    "fqdn": "sfo01w01esx02.sfo.rainpole.io",
    "username": "root",
    "storageType": "VSAN",
    "password": "VMw@re1!",
    "networkPoolName": "sfo01w01-cl01",
    "networkPoolId": "afd314f6-f31d-4ad4-8943-0ecb35c044b9"
},
{
    "fqdn": "sfo01w01esx03.sfo.rainpole.io",
    "username": "root",
    "storageType": "VSAN",
    "password": "VMw@re1!",
    "networkPoolName": "sfo01w01-cl01",
    "networkPoolId": "afd314f6-f31d-4ad4-8943-0ecb35c044b9"
},
{
    "fqdn": "sfo01w01esx04.sfo.rainpole.io",
    "username": "root",
    "storageType": "VSAN",
    "password": "VMw@re1!",
    "networkPoolName": "sfo01w01-cl01",
    "networkPoolId": "afd314f6-f31d-4ad4-8943-0ecb35c044b9"
}]
```

So to commission the 4 new hosts into my VCF inventory you run:

Commission-VCFHost -json .\SampleJSON\Host\commissionHosts.json

#### TIP 
This returns a task id, which you can monitor by running the following until status=Successful:

```Powershell
Get-VCFTask -id b93e2bc7-627b-4f7c-980b-c12b3497c4ea
```
### Create a Workload Domain

Once the commission hosts task is complete you can then create a workload domain using those hosts. Creating a workload domain also requires a json file. For this you need the id's of the hosts that you want to use. In VCF hosts that are available to be used in a workload domain have a status of UNASSIGNED_USEABLE so to find the id's of the hosts you want to add run the following

#### TIP 
Filter the results by adding | select fqdn,id
```Powershell
Get-VCFHost -Status UNASSIGNED_USEABLE | select fqdn,id
```
This returns the ids we need for creating the workload domain. Here is the Workload domain json. (Replace ESXi licence (AAAAA), vSAN licence (BBBBB) & NSX-V licence (CCCCC) with your keys)

```json
{
    "domainName" : "PowerVCF",
    "vcenterSpec" : {
        "name" : "sfo01w01vc01",
        "networkDetailsSpec" : {
            "ipAddress" : "172.16.225.64",
            "dnsName" : "sfo01w01vc01.sfo.rainpole.io",
            "gateway" : "172.16.225.1",
            "subnetMask" : "255.255.255.0"
        },
    "rootPassword" : "VMw@re1!",
    "datacenterName" : "PowerVCF-DC"
    },
    "computeSpec" : {
        "clusterSpecs" : [{
            "name" : "Cluster1",
            "hostSpecs" : [{
                "id" : "dd2ec05f-39e1-464e-83f1-1349a0dcf723",
                "license":"AAAAA-AAAAA-AAAAA-AAAAA-AAAAA",
                "hostNetworkSpec" : {
                    "vmNics" : [{
                        "id" : "vmnic0",
                        "vdsName" : "sfo01w01vds01"
                    }, {
                        "id" : "vmnic1",
                        "vdsName" : "sfo01w01vds01"
                    }]
                }
            }, {
                "id" : "809b25e8-1db6-464b-b310-97f581c56da5",
                "license":"AAAAA-AAAAA-AAAAA-AAAAA-AAAAA",
                "hostNetworkSpec" : {
                    "vmNics" : [{
                        "id" : "vmnic0",
                        "vdsName" : "sfo01w01vds01"
                    }, {
                        "id" : "vmnic1",
                        "vdsName" : "sfo01w01vds01"
                    }]
                }        
            }, {
                "id" : "5d3eea32-6464-4ae6-9866-932fb926a5f1",
                "license":"AAAAA-AAAAA-AAAAA-AAAAA-AAAAA",
                "hostNetworkSpec" : {
                    "vmNics" : [{
                        "id" : "vmnic0",
                        "vdsName" : "sfo01w01vds01"
                    }, {
                        "id" : "vmnic1",
                        "vdsName" : "sfo01w01vds01"
                    }]
                }
            }],
            "datastoreSpec" : {
                "vsanDatastoreSpec" : {
                    "failuresToTolerate" : 1,
                    "licenseKey" : "BBBBB-BBBBB-BBBBB-BBBBB-BBBBB",
                    "datastoreName" : "sfo01w01vsan01"
                }
            },
            "networkSpec" : {
                "vdsSpecs" : [{
                    "name" : "sfo01w01vds01",
                    "portGroupSpecs" : [{
                        "name" : "sfo01w01vds01-Mgmt",
                        "transportType" : "MANAGEMENT"
                    }, {
                        "name" : "sfo01w01vds01-VSAN",
                        "transportType" : "VSAN"
                    }, {
                        "name" : "sfo01w01vds01-vMotion",
                        "transportType" : "VMOTION"
                    }]
                }],
                "nsxClusterSpec" : {
                    "nsxVClusterSpec" : {
                        "vlanId" : 2237,
                        "vdsNameForVxlanConfig" : "sfo01w01vds01"
                    }
                }
            }
        } ]
    },
    "nsxVSpec" : {
        "nsxManagerSpec" : {
            "name" : "sfo01w01nsx01",
            "networkDetailsSpec" : {
                "ipAddress" : "172.16.225.66",
                "dnsName" : "sfo01w01nsx01.sfo.rainpole.io",
                "gateway" : "172.16.225.1",
                "subnetMask" : "255.255.255.0"
            }
        },
        "nsxVControllerSpec" : {
            "nsxControllerIps" : [ "172.16.235.121", "172.16.235.122", "172.16.235.123" ],
            "nsxControllerPassword" : "VMw@re123456!",
            "nsxControllerGateway" : "172.16.235.1",
            "nsxControllerSubnetMask" : "255.255.255.0"
        },
        "licenseKey" : "CCCCC-CCCCC-CCCCC-CCCCC-CCCCC",
        "nsxManagerAdminPassword" : "VMw@re1!",
        "nsxManagerEnablePassword" : "VMw@re1!"
    }
}
```

To create the workload domain run the following:
```Powershell
New-VCFWorkloadDomain -json .\SampleJSON\WorkloadDomain\workloadDomainSpec-NSX-V.json
```
And that should be it. If you've gotten all your json details correct you should have a fully functioning NSX-V workload domain without using the UI!
