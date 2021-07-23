---
layout: post
title: "How to update a Bicep resource"
date: 2021-07-23 09:09:41 +0200
categories: Bicep ARM Azure Automation
image1: /assets/images/2021-07-23-how-to-update-a-bicep-resource/bicep-logo-256.png
---

[Microsoft Docs]:https://docs.microsoft.com/en-us/azure/architecture/guide/azure-resource-manager/advanced-templates/update-resource
[Bicep GitHub]:https://github.com/Azure/bicep
[Bicep Learning Path]:https://docs.microsoft.com/en-us/learn/paths/bicep-deploy/
[Azure Bastion]:https://docs.microsoft.com/en-us/azure/bastion/bastion-overview
[Azure Bastion Learning Module]:https://docs.microsoft.com/en-us/learn/modules/intro-to-azure-bastion/


[<img src="{{ page.image1 | relative_url }}" alt="dummy" width="100"/>][Bicep GitHub]{:target="_blank"}
[Project Bicep][Bicep GitHub]{:target="_blank"}

Lets say you want to deploy a virtual network on Azure with a single subnet. In Bicep this reads a few lines of code:

```bash
param name string
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'ServerSubnet'
        properties: {
          addressPrefix: '172.16.0.0/24'
        }
      }
    ]
  }  
}

output vnet object = vnet
output vnetName string = vnet.name
```

Next you want to deploy an Azure Bastion in order to connect to VM living in the virtual network.

An **additional subnet** is a prerequisite for Azure Bastion. So you need to update the virtual network resource

```bash
param vnet object
param vnetName string
param location string = resourceGroup().location

resource vnet_updated 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet.properties.addressSpace.addressPrefixes[0]
      ]
    }
    subnets: [
      {
        name: vnet.properties.subnets[0].name
        properties: {
          addressPrefix: vnet.properties.subnets[0].properties.addressPrefix
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '172.16.1.0/24'
        }
      }
    ]
  }
}
```

Put this altogether in a Bicep module structure

```bash
targetScope = 'subscription'
param rgName string 

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: deployment().location
}

// Create virtual network
module vnet 'vnet.bicep' = {
  name: 'vnetDeployment'
  scope: rg
  params: {
    name: 'VNet1'
  }
}

// Update virtual network
module vnet_update 'vnet_update.bicep' = {
  name: 'vnet_updateDeployment'
  scope: rg
  params: {
    vnet: vnet.outputs.vnet
    vnetName: vnet.outputs.vnetName
  }
}
```

## Refernce
[Update a resource in an Azure Resource Manager template (Microsoft Docs)][Microsoft Docs]{:target="_blank"}


## Learn more

[Bicep learning path (Microsoft Learn)][Bicep Learning Path]{:target="_blank"}

[Azure Bastion learning module (Microsoft Learn)][Azure Bastion Learning Module]{:target="_blank"}

[Azure Bastion (Microsoft Docs)][Azure Bastion]{:target="_blank"}
