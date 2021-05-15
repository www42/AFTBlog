---
layout: post
title: "Azure Managed Identities"
date: 2021-05-14 12:15:27 ++0200
categories: Azure Cloud OAuth2
image1: /assets/images/2021-05-14-azure-managed-identities/how-it-works.png
---

Azure AD-managed identities for Azure resources (MI for short) is an admin friendly way to manage identities representing certain Azure resources like virtual machines, app services, Kubernetes clusters, and more. MIs are able to get permissions within Azure via Azure RBAC.

Microsoft's documentation for Managed Identities (MI) starts [here](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/).



## Quick reminder: Instance Metadata Service

An Azure virtual machine can communicate with the Hyper-V Host by using the Instance Metadata Service (IMDS). The communication is neither authenticated nor encrypted, but does not leave the Host system. IMDS at the Host system exposes an API at

```bash
http://169.254.169.254/metadata
```
with [several endpoint categories](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/instance-metadata-service?tabs=windows#endpoint-categories), e.g. `instance` providing information on compute and networking 
```bash
http://169.254.169.254/metadata/instance
```

John Savill created [a nice video](https://www.youtube.com/watch?v=M5BO91VOfXo) on this topic.


## How Managed Identity works for a VM

Now the idea of Managed Identitiy:

Starting with a VM without assigned MI. No matter wether it's Windows or Linux.

<img src="{{ page.image1 | relative_url }}" alt="Root user login" width="900"/>

Image by [Microsoft Docs](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/how-managed-identities-work-vm).

1. Azure Resource Manager (ARM) receives a request to enable MI for the virtual machine.

2. ARM creates a Service Principal (SP) within the tenant trusted by the Azure subscription. The SP gets an certificate for authentication.

3. ARM updates the identity endpoint category of IMDS with the informations of th SP just created
```bash
http://169.254.169.254/metadata/identity
```
This way the VM is connected to a Service Principal in Azure AD. ARM cares about renewing SP's certificate and updates IMDS accordingly. Now the virtual machine has a MI.

4.  The only task for the administrator is to assign an appropriate Azure RBAC role to the MI.

5. If the VM needs an authentication, that is if an app running on the VM needs an authentication, the app code simply gets an OAuth access token via IDMS without specifying a password or certificate
```bash
http://169.254.169.254/metadata/identity/oauth2/token
```

6. The SP behind the IMDS in turn requests an access token by using client ID and certificate. Azure AD emits an access token in the form of a JSON Web Token (JWT).

7. The access token is used by the app to get an Azure authorization.


## User assigned vs. System assigned


## Demo

Create an Windows virtual machine `VM1` without MI (resource group `MI-RG`). 

- Quick reminder: Test IMDS
```powershell
# Run this from inside VM1
$Uri      = "http://169.254.169.254/metadata/instance?api-version=2021-03-01"
$Header   = @{"Metadata" = "true"}
$response = Invoke-RestMethod -Headers $Header -Method GET -Uri $Uri -Proxy $null
$response | Format-List
$response.compute
$response.network
# Get the resource group name from IMDS
$rgName = $response.compute.resourceGroupName
```

1. Request a system assigned MI for VM1
```bash
# Run this from CloudShell (Bash)
az vm identity assign --name VM1 --resource-group MI-RG 
``` 

2. List the Service Principal created by ARM
```bash
# Run this from CloudShell (Bash)
az ad sp list --display-name 'VM1' --query "[].{objectId:objectId,objectType:objectType,servicePrincipalType:servicePrincipalType,keyCredentials:keyCredentials}"
``` 

3. List MI
```bash
# Run this from CloudShell (Bash)
az vm identity show --name 'VM1' --resource-group 'MI-RG'
```
The `principalId` of the MI corresponds to `objectId` of the SP.

4. Assign a role to the MI (`Reader` role at resource group level)
```bash
# Run this from CloudShell (Bash)
miId=$(az vm identity show --name 'VM1' --resource-group 'MI-RG' --query "principalId" --output tsv)
rgId=$(az group show --name 'MI-RG' --query "id" --output tsv)
az role assignment create --assignee $miId --role Reader --scope $rgId
```

5. Request an OAuth2 access token from within the VM
```powershell
# Run this from inside VM1 (PowerShell)
$Uri      = "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F"
$Header   = @{"Metadata" = "true"}
$response = Invoke-RestMethod -Headers $Header -Method GET -Proxy $null -Uri $Uri
```

6. Inspect the access token
```powershell
# Run this from inside VM1 (PowerShell)
$response
$token = $response.access_token
```

7. Use the access token to list all resource inside resource group ([see here](https://docs.microsoft.com/en-us/rest/api/resources/resources/listbyresourcegroup))
```bash
# Run this from CloudShell (Bash)
az group show --name MI-RG --query "id" 
# Copy resource group ID including double quotes
```
```powershell
# Run this from inside VM1 (PowerShell)
$rgId    =    # Paste resource group ID you copied in the previos step
$uri     = "https://management.azure.com$rgId/resources?api-version=2021-04-01"
$Header  = @{"authorization" = "Bearer $token"}
$response = Invoke-RestMethod -Method Get -Uri $uri -Headers $Header
$response.value
```









## Tipps and tricks

* For a complete list of Azure resources that support MI [click here](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/services-support-managed-identities).

* You can decode a JSON Web Token (JWT) at [https://jwt.ms](https://jwt.ms/)


## Unanswered Questions

* How enumerate / get swagger of identity endpoint. There is no documentation.

* Does an identity endpoint exist prior to enabling MI?

* Inside VM1: How to get resource ID of the resource group without installing PowerShell module or Azure CLI?

Cutting VM resource id after rg?