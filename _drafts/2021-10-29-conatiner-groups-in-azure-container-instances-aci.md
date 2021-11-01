---
layout: post
title: "Conatiner Groups in Azure Container Instances (ACI)"
date: 2021-10-29 13:44:10 +0200
categories: GitHub Jekyll
image1: /assets/images/2021-10-29-conatiner-groups-in-azure-container-instances-aci/dummy.png
---

[Microsoft Docs]:https://docs.microsoft.com/en-us/azure/container-instances/container-instances-container-groups
[ARM reference]:https://docs.microsoft.com/en-us/azure/templates/microsoft.containerinstance/containergroups?tabs=bicep
[YAML reference]:https://docs.microsoft.com/en-us/azure/container-instances/container-instances-reference-yaml
[Tobias Zimmergren]:https://zimmergren.net/programmatically-create-azure-container-instances-aci-in-a-virtual-network/
[ACI virtual network scenarios]:https://docs.microsoft.com/en-us/azure/container-instances/container-instances-virtual-network-concepts

## What is it?

[See documentation.][Microsoft Docs]{:target="_blank"}

<img src="{{ page.image1 | relative_url }}" alt="dummy" width="900"/>

Even if deploying a single ACI instance a container group is deployed


## Network Profile

If creating a VNet connected ACI *via yaml template* a network profile is required.

A network profile can be created using ARM - [see Tobias Zimmergren][Tobias Zimmergren]{:target="_blank"}.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "functions": [],
    "variables": {},
    "resources": [
        {
            "type": "Microsoft.Network/networkProfiles",
            "apiVersion": "2020-11-01",
            "name": "MyNetworkProfile",
            "location": "[resourceGroup().location]",
            "properties": {
                "containerNetworkInterfaceConfigurations": [
                    {
                        "name": "foo",
                        "properties": {
                            "ipConfigurations": [
                                {
                                    "name": "ipconfig1",
                                    "properties": {
                                        "subnet": {
                                            "id": "/subscriptions/ffcb38a5-8428-40c4-98b7-77013eac7ec5/resourceGroups/ACI-RG/providers/Microsoft.Network/virtualNetworks/vnet2/subnets/subnet0"
                                        }
                                    }
                                }
                            ]
                        }
                    }
                ]
            }

        }
    ],
    "outputs": {}
```