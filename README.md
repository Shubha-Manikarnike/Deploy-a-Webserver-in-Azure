# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
This project contains a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create a policy via Azure CLI which ensures that the deployed resources contain tags

3. Create your infrastructure as code

4. Write Packer template to create an Azure VM IMage.

5. Write terraform template to create Azure VMs based on the Image created previously

6. Deploy the resources and verify the created VMs in Azure



### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
1. Login to Azure CLI with your Azure creddentials
2. Create the Azure policy on CLI by using the file tagging-policy.json
3. Build the Packer template - server.json to create the VM Image in Azure
4. Apply the terraform template to create VMs and related resources in Azure
5. Modify variables in variables.tf to change number of VMs, location, resource group etc.
6. Destroy the terraform infrastructure

### Output
1. Login to Azure portal and verify the VM created with the corresponding security rules and load balancers.
2. You can also verify the resources using terraform show

