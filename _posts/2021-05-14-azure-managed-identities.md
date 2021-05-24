---
layout: post
title: "Azure Managed Identities"
date: 2021-05-14 12:15:27 ++0200
categories: Azure Cloud OAuth2
image1: /assets/images/2021-05-14-azure-managed-identities/how-it-works.png
image2: /assets/images/2021-05-14-azure-managed-identities/MI-SP-general.png
image3: /assets/images/2021-05-14-azure-managed-identities/System-assigned-MI.png
image4: /assets/images/2021-05-14-azure-managed-identities/User-assigned-MI.png
image5: /assets/images/2021-05-14-azure-managed-identities/MI-SP-VM.png
---

Two common problems:

* When a script is running inside an Azure VM: How to assign the script a certain authorization role, lets say Contributor to a resource group 😳

* When an app running inside an Azure VM needs to know a secret connection string to access a storage account: How to authorize the app to the key vault containing the connection string 😳

Creating a Service Principle does not meet the requirements, because the Service Principle needs to authenticate itselft by a secret or certificate. Maintaining secrets is just the problem.

**Solution to all these problems is: Azure Managed Identity.**

An Azure Managed Identity is an Azure resource type with a Service Principle in the background, i.e. inside Azure AD. While the Service Principle is authenticating itself by a certificate the corresponding automatically the Managed Identity can borrow the OAuth token from the Service Principal. This way a Managed Identity is able to get permissions within Azure via Azure RBAC.

<img src="{{ page.image2 | relative_url }}" alt="Managed ID and Service Principal are connected" width="400"/>



Documentation for Azure Managed Identity starts [here](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/).






## System Assigned vs. User Assigned

Virtual Machine is only an example. Managed Identity is available for many other Azure resource types, including App Services, Container Instance, Azure Function, Logic Apps and more.

A *System Assigned MI* share the same lifecycle as the virtual machine it represents. If the virtual machine gets deleted the MI is deleted too.

<img src="{{ page.image3 | relative_url }}" alt="System assigned Managed ID" width="400"/>

A *User Assigned MI* is an independent resource in Azure. Zero, one, or more virtual machines can use the same MI. If all virtual machines are deleted the user assigned MI is still alive.

<img src="{{ page.image4 | relative_url }}" alt="User assigned Managed ID" width="400"/>







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

<img src="{{ page.image5 | relative_url }}" alt="MI for virtual machine" width="400"/>


Starting with a VM without assigned MI. No matter wether it's Windows or Linux.

<img src="{{ page.image1 | relative_url }}" alt="How it works" width="900"/>

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
