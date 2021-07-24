---
layout: post
title: "How to update a Bicep resource"
date: 2021-07-23 09:09:41 +0200
categories: Bicep ARM Azure Automation
image1: /assets/images/2021-07-23-how-to-update-a-bicep-resource/bicep-logo-256.png
image2: /assets/images/2021-07-23-how-to-update-a-bicep-resource/vnet.bicep.png
image3: /assets/images/2021-07-23-how-to-update-a-bicep-resource/main.bicep.png
image4: /assets/images/2021-07-23-how-to-update-a-bicep-resource/vnet_update.bicep.png
image5: /assets/images/2021-07-23-how-to-update-a-bicep-resource/module-structure.png
---

[Microsoft Docs]:https://docs.microsoft.com/en-us/azure/architecture/guide/azure-resource-manager/advanced-templates/update-resource
[Bicep GitHub]:https://github.com/Azure/bicep
[Bicep Learning Path]:https://docs.microsoft.com/en-us/learn/paths/bicep-deploy/
[Azure Bastion]:https://docs.microsoft.com/en-us/azure/bastion/bastion-overview
[Azure Bastion Learning Module]:https://docs.microsoft.com/en-us/learn/modules/intro-to-azure-bastion/


[<img src="{{ page.image1 | relative_url }}" alt="bicep logo" width="100"/>][Bicep GitHub]{:target="_blank"}
[Project Bicep][Bicep GitHub]{:target="_blank"}

Lets say you want to deploy a virtual network on Azure with a single subnet. In Bicep this reads a few lines of code:

<img src="{{ page.image2 | relative_url }}" alt="vnet.bicep" width="900"/>

Next you want to deploy an Azure Bastion in order to connect to VM living in the virtual network.

An **additional subnet** is a prerequisite for Azure Bastion. So you need to update the virtual network resource

<img src="{{ page.image4 | relative_url }}" alt="vnet_update.bicep" width="900"/>

Put this altogether in a Bicep module structure

<img src="{{ page.image3 | relative_url }}" alt="main.bicep" width="900"/>

The output from the creating Bicep module is taken by the updating Bicep module as input

<img src="{{ page.image5 | relative_url }}" alt="bicep module structure" width="600"/>


You can find the files [here](https://github.com/www42/AFT/tree/main/Bicep/Update_Bicep_Resource){:target="_blank"}.

## Reference
[Update a resource in an Azure Resource Manager template (Microsoft Docs)][Microsoft Docs]{:target="_blank"}


## Learn more

[Bicep learning path (Microsoft Learn)][Bicep Learning Path]{:target="_blank"}

[Azure Bastion learning module (Microsoft Learn)][Azure Bastion Learning Module]{:target="_blank"}

[Azure Bastion (Microsoft Docs)][Azure Bastion]{:target="_blank"}
