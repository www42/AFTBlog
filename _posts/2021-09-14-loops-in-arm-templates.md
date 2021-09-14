---
layout: post
title: "Loops in ARM Templates"
date: 2021-09-14 20:49:57 +0200
categories: Azure ARM Automation
---

[ARM Templates Docs]:https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/

## Resource loops




{% highlight json linenos %}
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "functions": [],
    "variables": {},
    "resources": [
        {
            "type": "Microsoft.Network/routeTables",
            "apiVersion": "2020-11-01",
            "copy": {
                "count": 3,
                "name": "routeTableLoop"
            },
            "name": "[concat( 'RouteTable-', copyIndex() )]",
            "location": "westeurope",
            "properties": {}
        }
    ],
    "outputs": {}
}
{% endhighlight %}

This template will deploy three route tables. Their names are constructed by concatenating the fix string `RouteTable-` and the `copyIndex()` resulting in

```
RouteTable-0
RouteTable-1
RouteTable-2
```

You can shift the `copyIndex()` by yielding an argument, so 
{% highlight json linenos %}
{
            "name": "[concat( 'RouteTable-', copyIndex(2) )]",
}
{% endhighlight %}

will result in 
```
RouteTable-2
RouteTable-3
RouteTable-4
```

## Variable loops

But what if you want to name the route tables
```
RouteTable-NetworkA
RouteTable-NetworkB
RouteTable-NetworkC
```

Possible solution:

{% highlight json linenos %}
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "virtualNetworkNames": {
            "type": "array",
            "defaultValue": [
                "NetworkA",
                "NetworkB",
                "NetworkC"
            ]
        }
    },
    "functions": [],
    "variables": {
        "networkCount": "[length(parameters('virtualNetworkNames'))]",
        "copy": [
            {
                "name": "routeTableNames",
                "count": "[variables('networkCount')]",
                "input": "[concat( 'RouteTable-', parameters('virtualNetworkNames')[copyIndex('routeTableNames')] )]"
            }
        ]
    },
    "resources": [
        {
            "type": "Microsoft.Network/routeTables",
            "apiVersion": "2020-11-01",
            "copy": {
                "count": "[variables('networkCount')]",
                "name": "routeTableLoop"
            },
            "name": "[variables('routeTableNames')[copyIndex()]]",
            "location": "westeurope",
            "properties": {}
        }
    ],
    "outputs": {}
}{% endhighlight %}


## Learn more

[ARM Templates docs landing page.][ARM Templates Docs]{:target="_blank"}
