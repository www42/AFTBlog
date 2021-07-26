---
layout: post
title: "How to update a Bicep resource"
date: 2021-07-23 09:09:41 +0200
categories: Bicep ARM Azure Automation
image1: /assets/images/2021-07-23-how-to-update-a-bicep-resource/bicep-logo-256.png
image2: /assets/images/2021-07-23-how-to-update-a-bicep-resource/main-modules.bicep.png
image3: /assets/images/2021-07-23-how-to-update-a-bicep-resource/noparam-vnet.bicep.png
image4: /assets/images/2021-07-23-how-to-update-a-bicep-resource/noparam-vnet_update.bicep.png
---

[Microsoft Docs]:https://docs.microsoft.com/en-us/azure/architecture/guide/azure-resource-manager/advanced-templates/update-resource
[Bicep GitHub]:https://github.com/Azure/bicep
[Bicep Learning Path]:https://docs.microsoft.com/en-us/learn/paths/bicep-deploy/
[Azure Bastion]:https://docs.microsoft.com/en-us/azure/bastion/bastion-overview
[Azure Bastion Learning Module]:https://docs.microsoft.com/en-us/learn/modules/intro-to-azure-bastion/


[<img src="{{ page.image1 | relative_url }}" alt="bicep logo" width="100"/>][Bicep GitHub]{:target="_blank"}
[Project Bicep][Bicep GitHub]{:target="_blank"}

Lets say you want to deploy a virtual network on Azure with a single subnet. In Bicep this reads a few lines of code:

<img src="{{ page.image3 | relative_url }}" alt="vnet.bicep" width="900"/>

Next you want to add a second subnet to the virtual network, may be because of Azure Bastion.

In Bicep no problem. Specify the original properties with their original values, and add the new properties (green box).

<img src="{{ page.image4 | relative_url }}" alt="vnet_update.bicep" width="900"/>

Put this altogether in a Bicep module structure. The output from the creating Bicep module is taken by the updating Bicep module as input. An output type *object* is used.

<img src="{{ page.image2 | relative_url }}" alt="bicep module structure" width="600"/>


You can find the files [here](https://github.com/www42/AFT/tree/main/Bicep/Update_Bicep_Resource){:target="_blank"}.

## Reference
[Update a resource in an Azure Resource Manager template (Microsoft Docs)][Microsoft Docs]{:target="_blank"}


## Learn more

[Bicep learning path (Microsoft Learn)][Bicep Learning Path]{:target="_blank"}

[Azure Bastion learning module (Microsoft Learn)][Azure Bastion Learning Module]{:target="_blank"}
